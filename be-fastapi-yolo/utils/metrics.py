from prometheus_client import Counter, Histogram, Gauge
from prometheus_client import generate_latest, CONTENT_TYPE_LATEST
from fastapi import Request, Response
from typing import Callable
import time

# Define metrics
REQUEST_COUNT = Counter(
    "app_request_count_total",
    "Total count of requests by endpoint and method",
    ["endpoint", "method"]
)

REQUEST_TIME = Histogram(
    "app_request_latency_seconds",
    "Histogram of request latency by endpoint and method (in seconds)",
    ["endpoint", "method"],
    buckets=[0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1.0, 2.5, 5.0, 7.5, 10.0]
)

REQUESTS_IN_PROGRESS = Gauge(
    "app_requests_in_progress",
    "Gauge of requests currently being processed by endpoint and method",
    ["endpoint", "method"]
)

ENDPOINT_FAILED_COUNTER = Counter(
    'app_failed_requests_total',
    'Count of failed requests per endpoint',
    ['endpoint', 'method', 'exception']
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
