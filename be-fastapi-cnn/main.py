import keras
import cloudinary

from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.responses import StreamingResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware

from config import settings
from schemas import ImageRequest, ImageResponse
from services.image_service import ImageService

import utils

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

try:
    densenet_model = keras.models.load_model(settings.MODEL_PATH)
except Exception as e:
    raise RuntimeError(f"Failed to load model: {str(e)}")

@app.post("/densenet_predict")
async def densenet_predict(file: UploadFile = File(...)):
    try:
        img = ImageService.load_image_from_request(file.file)
        images = utils.process_and_generate_images_from_memory(
            img, densenet_model, settings.LAST_CONV_LAYER, settings.CLASS_NAMES
        )
        zip_buffer = utils.create_zip_from_images(images)
        
        return StreamingResponse(
            zip_buffer,
            media_type='application/zip',
            headers={
                "Content-Disposition": "attachment; filename=grad_cam_images.zip",
                "Content-Type": "application/zip"
            }
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/v2/densenet_predict", response_model=ImageResponse)
async def densenet_predict_v2(request: ImageRequest):
    try:
        img = ImageService.load_image_from_base64(request.image)
        images = utils.process_and_generate_images_from_memory(
            img, densenet_model, settings.LAST_CONV_LAYER, settings.CLASS_NAMES
        )
        image_urls = [ImageService.upload_to_cloudinary(image) for image in images]
        return ImageResponse(image_urls=",".join(image_urls))
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5000)
