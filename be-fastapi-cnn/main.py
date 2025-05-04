import keras
import cloudinary
import time
import base64
import io
import traceback
from PIL import Image

from fastapi import FastAPI, File, UploadFile, HTTPException, Form, Query, BackgroundTasks, Depends
from fastapi.responses import StreamingResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from celery.result import AsyncResult
from dotenv import load_dotenv

from config import settings
from schemas import ImageRequest, ImageResponse, TaskRequest, TaskSubmitResponse, TaskStatusResponse, TaskListResponse, MinioImageResponse
from services.image_service import ImageService
from services.stats_service import disease_stats_service
from services.storage_service import storage_service
from celery_config import celery_app, get_redis_client
from tasks import predict_densenet, predict_densenet_cloudinary, predict_densenet_minio

from utils.gradcam import process_and_generate_images_from_memory, get_img_array_from_memory, create_zip_from_images
from utils.metrics import (
    metrics_middleware, 
    metrics_endpoint, 
    track_predictions, 
    MODEL_LOAD_TIME,
    IMAGE_SIZE_HISTOGRAM
)

load_dotenv()

densenet_model = None
MINIO_AVAILABLE = storage_service.client is not None

# Startup and shutdown events
@asynccontextmanager
async def lifespan(app: FastAPI):
    global densenet_model
    
    # Load model and track loading time
    start_time = time.time()
    try:
        densenet_model = keras.models.load_model(settings.MODEL_PATH)
        MODEL_LOAD_TIME.set(time.time() - start_time)
    except Exception as e:
        print(f"Failed to load model: {str(e)}")
        # Continue without the model - will be handled in the endpoint
        densenet_model = None
    
    # Configure Cloudinary
    cloudinary.config(
        cloud_name=settings.CLOUDINARY_CLOUD_NAME,
        api_key=settings.CLOUDINARY_API_KEY,
        api_secret=settings.CLOUDINARY_API_SECRET
    )
    
    # Yield control to FastAPI
    yield

app = FastAPI(
    title="Chest X-Ray Disease Classification API",
    description="API for detecting diseases in chest X-ray images using DenseNet121",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add metrics middleware
app.middleware("http")(metrics_middleware)

# Helper function to get task status
async def get_task_status(task_id: str) -> dict:
    """Get the current status of a task"""
    try:
        task_result = AsyncResult(task_id, app=celery_app)
        
        result = {
            'task_id': task_id,
            'status': task_result.status,
        }
        
        if task_result.successful():
            result['result'] = task_result.result
        elif task_result.failed():
            result['error'] = str(task_result.result)
        elif task_result.state == 'PROGRESS' and task_result.info:
            result.update(task_result.info)
        
        return result
    except Exception as e:
        print(f"Error getting task status: {e}")
        return {
            'task_id': task_id,
            'status': 'ERROR',
            'error': str(e)
        }

# Load model (if not loaded during startup)
if not 'densenet_model' in globals() or densenet_model is None:
    try:
        start_time = time.time()
        densenet_model = keras.models.load_model(settings.MODEL_PATH)
        MODEL_LOAD_TIME.set(time.time() - start_time)
    except Exception as e:
        print(f"Failed to load model: {str(e)}")
        densenet_model = None

@app.post("/densenet_predict", 
         tags=["Predictions"],
         summary="Predict diseases with GradCAM visualization (ZIP response)",
         description="Analyze chest X-ray image using DenseNet121 model and return GradCAM visualizations as a ZIP file.")
async def densenet_predict(file: UploadFile = File(...), font_size: int = Form(40)):
    try:
        # Load and track image size
        contents = await file.read()
        IMAGE_SIZE_HISTOGRAM.observe(len(contents))
        
        # Create a BytesIO object from the contents
        file_bytes = io.BytesIO(contents)
        
        # Load and ensure RGB mode
        img = Image.open(file_bytes)
        if img.mode != 'RGB':
            img = img.convert('RGB')
            
        print(f"Image mode: {img.mode}, size: {img.size}")
        
        # Process images and track predictions
        images = process_and_generate_images_from_memory(
            img, densenet_model, settings.LAST_CONV_LAYER, 
            settings.CLASS_NAMES, font_size=font_size
        )
        
        # Track predictions
        img_array = get_img_array_from_memory(img, size=(224, 224))
        predictions = densenet_model.predict(img_array)
        track_predictions(predictions, settings.CLASS_NAMES)
        
        zip_buffer = create_zip_from_images(images)
        
        return StreamingResponse(
            zip_buffer,
            media_type='application/zip',
            headers={
                "Content-Disposition": "attachment; filename=grad_cam_images.zip",
                "Content-Type": "application/zip"
            }
        )
    except Exception as e:
        print(f"Error in densenet_predict: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/v2/densenet_predict", 
          response_model=ImageResponse, 
          tags=["Predictions"],
          summary="Predict diseases with Cloudinary URLs",
          description="Analyze chest X-ray image using DenseNet121 model and return Cloudinary URLs for GradCAM visualizations.")
async def densenet_predict_v2(request: ImageRequest, font_size: int = 40):
    try:
        # Decode and track image size
        image_data = base64.b64decode(request.image)
        IMAGE_SIZE_HISTOGRAM.observe(len(image_data))
        
        # Load and ensure RGB mode
        img = ImageService.load_image_from_base64(request.image)
        if img.mode != 'RGB':
            img = img.convert('RGB')
        
        # Process images and track predictions
        images = process_and_generate_images_from_memory(
            img, densenet_model, settings.LAST_CONV_LAYER, 
            settings.CLASS_NAMES, font_size=font_size
        )
        
        # Track predictions
        img_array = get_img_array_from_memory(img, size=(224, 224))
        predictions = densenet_model.predict(img_array)
        track_predictions(predictions, settings.CLASS_NAMES)
        
        image_urls = [ImageService.upload_to_cloudinary(image) for image in images]
        return ImageResponse(image_urls=",".join(image_urls))
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        print(f"Error in densenet_predict_v2: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/async/densenet_predict", 
          response_model=TaskSubmitResponse, 
          tags=["Async Predictions"],
          summary="Submit async prediction job",
          description="Submit an asynchronous task for chest X-ray analysis with DenseNet121 and get a task ID for later retrieval.")
async def async_densenet_predict(file: UploadFile = File(...), font_size: int = Form(40)):
    """Submit an asynchronous task for image prediction with zip result"""
    try:
        contents = await file.read()
        image_base64 = base64.b64encode(contents).decode('utf-8')
        
        # Submit task to Celery
        task = predict_densenet.delay(image_base64, font_size)
        
        return TaskSubmitResponse(
            task_id=task.id,
            status="submitted"
        )
        
    except Exception as e:
        print(f"Error submitting async task: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/tasks/{task_id}", 
         response_model=TaskStatusResponse, 
         tags=["Tasks"],
         summary="Check task status",
         description="Check the current status of an asynchronous prediction task.")
async def check_task_status(task_id: str):
    """Check the status of an async task"""
    try:
        task_status = await get_task_status(task_id)
        return TaskStatusResponse(**task_status)
    except Exception as e:
        print(f"Error checking task status: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/tasks/{task_id}/result", 
         tags=["Tasks"],
         summary="Get task results",
         description="Get the results of a completed prediction task, either as image URLs or a ZIP file.")
async def get_task_result(task_id: str):
    """Get the result of a completed task"""
    try:
        task_result = AsyncResult(task_id, app=celery_app)
        
        if not task_result.ready():
            raise HTTPException(
                status_code=202,  # Accepted but not ready
                detail=f"Task {task_id} is still processing"
            )
        
        if task_result.failed():
            raise HTTPException(
                status_code=500,
                detail=f"Task {task_id} failed: {str(task_result.result)}"
            )
        
        result = task_result.result
        
        if 'zip_base64' in result:
            # Return the ZIP file as a download
            zip_data = base64.b64decode(result['zip_base64'])
            return StreamingResponse(
                io.BytesIO(zip_data),
                media_type='application/zip',
                headers={
                    "Content-Disposition": f"attachment; filename=grad_cam_images_{task_id}.zip",
                    "Content-Type": "application/zip"
                }
            )
        elif 'image_urls' in result:
            # Return the Cloudinary URLs
            return JSONResponse(content={
                "status": "success",
                "image_urls": result['image_urls'].split(",")
            })
        else:
            return JSONResponse(content=result)
            
    except HTTPException:
        raise
    except Exception as e:
        print(f"Error retrieving task result: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/stats/diseases/weekly", 
         tags=["Statistics"],
         summary="Weekly disease statistics",
         description="Get disease prediction statistics aggregated by week for monitoring disease trends.")
async def get_weekly_disease_stats():
    """
    Get disease prediction statistics for the current week
    """
    try:
        weekly_stats = disease_stats_service.get_weekly_stats()
        return {
            "status": "success",
            "data": {
                "weekly_stats": weekly_stats,
                "total": disease_stats_service.get_disease_summary()
            }
        }
    except Exception as e:
        print(f"Error getting weekly stats: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/stats/diseases/summary", 
         tags=["Statistics"],
         summary="Overall disease summary",
         description="Get a summary of all disease predictions with total counts, sorted by frequency.")
async def get_disease_summary():
    """
    Get a summary of all disease predictions
    """
    try:
        summary = disease_stats_service.get_disease_summary()
        # Sort diseases by count in descending order
        sorted_diseases = dict(sorted(summary.items(), key=lambda item: item[1], reverse=True))
        
        return {
            "status": "success",
            "data": {
                "summary": sorted_diseases,
                "total_predictions": sum(summary.values())
            }
        }
    except Exception as e:
        print(f"Error getting disease summary: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/stats/diseases/daily", 
         tags=["Statistics"],
         summary="Daily disease statistics",
         description="Get daily disease prediction statistics for a specified period (1-365 days).")
async def get_daily_disease_stats(days: int = Query(30, ge=1, le=365)):
    """
    Get daily disease prediction statistics for the specified period
    """
    try:
        daily_stats = disease_stats_service.get_daily_stats(days=days)
        return {
            "status": "success",
            "data": {
                "daily_stats": daily_stats,
                "days_period": days
            }
        }
    except Exception as e:
        print(f"Error getting daily stats: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/metrics", 
         tags=["Monitoring"],
         summary="Prometheus metrics",
         description="Expose Prometheus metrics for monitoring system performance and predictions.")
async def metrics():
    return await metrics_endpoint()

@app.get("/health", 
         tags=["Health Checks"],
         summary="Basic health check",
         description="Check if the API and model are healthy and get version information.")
async def health_check():
    return {"status": "healthy", "model": "densenet", "version": "1.0"}

@app.get("/health/redis", 
         tags=["Health Checks"],
         summary="Redis health check",
         description="Check the health of the Redis connection and get statistics about connected clients.")
async def redis_health_check():
    try:
        # Use the centralized Redis client getter
        redis_client = get_redis_client()
        redis_info = redis_client.info()
        
        # Check connected clients count
        connected_clients = redis_info.get("connected_clients", 0)
        max_clients = redis_info.get("maxclients", 0)
        
        return {
            "status": "healthy", 
            "redis_version": redis_info.get("redis_version", "unknown"),
            "connected_clients": connected_clients,
            "max_clients": max_clients,
            "client_percentage": f"{(connected_clients/max_clients)*100:.1f}%" if max_clients > 0 else "unknown"
        }
    except Exception as e:
        raise HTTPException(
            status_code=503,
            detail=f"Redis connection failed: {str(e)}"
        )

@app.get("/health/celery", 
         tags=["Health Checks"],
         summary="Celery health check",
         description="Check the health of the Celery task queue, worker availability, and task statistics.")
async def celery_health_check():
    try:
        # Try to get a client using the centralized approach
        try:
            redis_client = get_redis_client()
            redis_info = redis_client.info()
            connected_clients = redis_info.get("connected_clients", 0)
        except Exception:
            connected_clients = "unknown"
            
        # Simple ping to check if Celery is running
        i = celery_app.control.inspect()
        availability = i.ping() or {}
        
        if not availability:
            raise HTTPException(
                status_code=503,
                detail="No Celery workers available"
            )
        
        # Get worker stats
        stats = i.stats() or {}
        active = i.active() or {}
        
        return {
            "status": "healthy",
            "workers": list(availability.keys()),
            "tasks_processed": {worker: stat["total"].get("tasks.predict_densenet", 0) + 
                               stat["total"].get("tasks.predict_densenet_cloudinary", 0) +
                               stat["total"].get("tasks.predict_densenet_minio", 0)
                               for worker, stat in stats.items()},
            "active_tasks": {worker: len(tasks) for worker, tasks in active.items()},
            "redis_clients": connected_clients
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=503,
            detail=f"Celery health check failed: {str(e)}"
        )

@app.post("/v3/densenet_predict", 
          response_model=TaskSubmitResponse, 
          tags=["Async Predictions"],
          summary="Predict with MinIO storage",
          description="Submit a chest X-ray image for processing with results stored in MinIO object storage.")
async def densenet_predict_v3(file: UploadFile = File(...), font_size: int = Form(40)):
    """
    Submit an image for processing with DenseNet model and store results in MinIO.
    This approach reduces Redis memory usage by keeping only task metadata in Redis.
    
    Args:
        file: Chest X-ray image file
        font_size: Font size for annotations on result images
    
    Returns:
        Task submission response with task_id for polling
    """
    if not MINIO_AVAILABLE:
        raise HTTPException(
            status_code=503,
            detail="MinIO storage service is not available. Please use /densenet_predict or /v2/densenet_predict endpoints instead."
        )
        
    try:
        # Read file contents
        contents = await file.read()
        
        # Track image size for metrics
        IMAGE_SIZE_HISTOGRAM.observe(len(contents))
        
        # Convert to base64 for Celery task
        image_base64 = base64.b64encode(contents).decode('utf-8')
        
        # Submit task to Celery with MinIO storage
        task = predict_densenet_minio.delay(image_base64, font_size)
        
        return TaskSubmitResponse(
            task_id=task.id,
            status="submitted"
        )
        
    except Exception as e:
        print(f"Error submitting task to process with MinIO storage: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/v3/tasks/{task_id}/result", 
         response_model=MinioImageResponse, 
         tags=["Tasks"],
         summary="Get MinIO task results",
         description="Get the results of a completed prediction task with images stored in MinIO as URLs.")
async def get_minio_task_result(task_id: str):
    """
    Get the result of a completed MinIO storage task
    
    Args:
        task_id: The ID of the submitted task
        
    Returns:
        The list of URLs to the processed images in MinIO
    """
    if not MINIO_AVAILABLE:
        raise HTTPException(
            status_code=503,
            detail="MinIO storage service is not available."
        )
        
    try:
        task_result = AsyncResult(task_id, app=celery_app)
        
        if not task_result.ready():
            raise HTTPException(
                status_code=202,  # Accepted but not ready
                detail=f"Task {task_id} is still processing"
            )
        
        if task_result.failed():
            raise HTTPException(
                status_code=500,
                detail=f"Task {task_id} failed: {str(task_result.result)}"
            )
        
        result = task_result.result
        
        if 'image_urls' in result and isinstance(result['image_urls'], list):
            # Return the MinIO URLs
            return MinioImageResponse(
                status="success",
                image_urls=result['image_urls']
            )
        else:
            raise HTTPException(
                status_code=500,
                detail="Invalid result format from task"
            )
            
    except HTTPException:
        raise
    except Exception as e:
        print(f"Error retrieving MinIO task result: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health/minio", 
         tags=["Health Checks"],
         summary="MinIO health check",
         description="Check if MinIO storage is working properly.")
async def minio_health_check():
    """Check if MinIO storage is working properly"""
    if not MINIO_AVAILABLE:
        raise HTTPException(
            status_code=503,
            detail="MinIO storage service is not available."
        )
        
    try:
        # Try to create a small test file
        test_data = b"MinIO health check"
        test_file_name = f"health_check/test_{int(time.time())}.txt"
        
        # Upload test file and get URL
        url = storage_service.upload_file(
            test_data,
            test_file_name,
            content_type="text/plain"
        )
        
        return {
            "status": "healthy",
            "message": "MinIO storage is working properly",
            "test_url": url
        }
    except Exception as e:
        raise HTTPException(
            status_code=503,
            detail=f"MinIO storage is unavailable: {str(e)}"
        )

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5000)
