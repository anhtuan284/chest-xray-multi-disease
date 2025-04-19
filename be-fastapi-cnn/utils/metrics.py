from prometheus_client import Counter, Histogram, Gauge
from prometheus_client import generate_latest, CONTENT_TYPE_LATEST
from fastapi import Request, Response
from typing import Callable
import time

from services.stats_service import disease_stats_service

# Define metrics
REQUEST_COUNT = Counter(
    "densenet_request_count_total",
    "Total count of DenseNet requests by endpoint and method",
    ["endpoint", "method"]
)

REQUEST_TIME = Histogram(
    "densenet_request_latency_seconds",
    "Histogram of DenseNet request latency by endpoint and method (in seconds)",
    ["endpoint", "method"],
    buckets=[0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1.0, 2.5, 5.0, 7.5, 10.0]
)

REQUESTS_IN_PROGRESS = Gauge(
    "densenet_requests_in_progress",
    "Gauge of DenseNet requests currently being processed by endpoint and method",
    ["endpoint", "method"]
)

ENDPOINT_FAILED_COUNTER = Counter(
    'densenet_failed_requests_total',
    'Count of failed DenseNet requests per endpoint',
    ['endpoint', 'method', 'exception']
)

PREDICTION_COUNTER = Counter(
    'densenet_predictions_total',
    'Count of predictions by disease class',
    ['disease_class']
)

PREDICTION_CONFIDENCE = Histogram(
    'densenet_prediction_confidence',
    'Confidence scores for DenseNet predictions',
    ['disease_class'],
    buckets=[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 0.99, 1.0]
)

IMAGE_SIZE_HISTOGRAM = Histogram(
    'densenet_input_image_size_bytes',
    'Size of input images in bytes',
    buckets=[10_000, 50_000, 100_000, 500_000, 1_000_000, 5_000_000]
)

MODEL_LOAD_TIME = Gauge(
    'densenet_model_load_time_seconds',
    'Time taken to load the DenseNet model'
)

# Middleware for metrics
async def metrics_middleware(request: Request, call_next: Callable) -> Response:
    endpoint = request.url.path
    method = request.method
    
    if endpoint == '/metrics':
        return await call_next(request)
    
    # Increment requests in progress
    REQUESTS_IN_PROGRESS.labels(endpoint=endpoint, method=method).inc()
    
    # Track request time
    start_time = time.time()
    try:
        response = await call_next(request)
        REQUEST_COUNT.labels(endpoint=endpoint, method=method).inc()
        return response
    except Exception as e:
        ENDPOINT_FAILED_COUNTER.labels(
            endpoint=endpoint, method=method, exception=type(e).__name__
        ).inc()
        raise
    finally:
        # Track request latency
        REQUEST_TIME.labels(endpoint=endpoint, method=method).observe(time.time() - start_time)
        # Decrement in-progress requests
        REQUESTS_IN_PROGRESS.labels(endpoint=endpoint, method=method).dec()

# Endpoint to expose metrics
async def metrics_endpoint():
    return Response(content=generate_latest(), media_type=CONTENT_TYPE_LATEST)

# Helper function to track prediction metrics
def track_predictions(predictions, labels):
    """
    Track prediction metrics for a batch of predictions
    
    Args:
        predictions: Model predictions array
        labels: List of class labels
    """
    # Get top indices
    top_indices = predictions[0].argsort()[-3:][::-1]
    
    for idx in top_indices:
        disease_name = labels[idx]
        confidence = float(predictions[0][idx])  # Convert to Python float to avoid numpy-related errors
        
        # Track disease class prediction
        PREDICTION_COUNTER.labels(disease_class=disease_name).inc()
        
        # Track confidence score
        PREDICTION_CONFIDENCE.labels(disease_class=disease_name).observe(confidence)
        
        # Record in SQLite stats service - only track the highest confidence prediction
        if idx == top_indices[0]:
            disease_stats_service.record_prediction(disease_name)
