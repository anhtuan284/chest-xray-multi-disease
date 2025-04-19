import keras
import cloudinary
import time
import base64
import io
import traceback
from PIL import Image

from fastapi import FastAPI, File, UploadFile, HTTPException, Form, Query
from fastapi.responses import StreamingResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware

from config import settings
from schemas import ImageRequest, ImageResponse
from services.image_service import ImageService
from services.stats_service import disease_stats_service

# Import utils properly with explicit imports
import utils
from utils.gradcam import process_and_generate_images_from_memory, get_img_array_from_memory, create_zip_from_images
from utils.metrics import (
    metrics_middleware, 
    metrics_endpoint, 
    track_predictions, 
    MODEL_LOAD_TIME,
    IMAGE_SIZE_HISTOGRAM
)

# Configure Cloudinary
cloudinary.config(
    cloud_name=settings.CLOUDINARY_CLOUD_NAME,
    api_key=settings.CLOUDINARY_API_KEY,
    api_secret=settings.CLOUDINARY_API_SECRET
)

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Add metrics middleware
app.middleware("http")(metrics_middleware)

# Load model and track loading time
start_time = time.time()
try:
    densenet_model = keras.models.load_model(settings.MODEL_PATH)
    MODEL_LOAD_TIME.set(time.time() - start_time)
except Exception as e:
    raise RuntimeError(f"Failed to load model: {str(e)}")

@app.post("/densenet_predict")
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

@app.post("/v2/densenet_predict", response_model=ImageResponse)
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

# Add new endpoint for disease statistics
@app.get("/stats/diseases/weekly")
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

# Add endpoint for disease summary
@app.get("/stats/diseases/summary")
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

# Add endpoint for daily disease statistics
@app.get("/stats/diseases/daily")
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

# Add metrics endpoint
@app.get("/metrics")
async def metrics():
    return await metrics_endpoint()

@app.get("/health")
async def health_check():
    return {"status": "healthy", "model": "densenet", "version": "1.0"}

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5000)
