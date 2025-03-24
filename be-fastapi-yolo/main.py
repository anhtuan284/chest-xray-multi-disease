from io import BytesIO
from PIL import Image
from fastapi import FastAPI, UploadFile, File, Request
from fastapi.responses import StreamingResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import base64
from pydantic import BaseModel

from utils.models import ModelManager
from utils.image_processing import preprocess_image, save_image_to_memory
from utils.metrics import metrics_middleware, metrics_endpoint

# Initialize model manager
model_manager = ModelManager()

app = FastAPI(title="MediScan API", description="Medical image analysis using YOLO models")

# Add middlewares
app.middleware("http")(metrics_middleware)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Expose metrics endpoint
@app.get("/metrics")
async def metrics():
    return await metrics_endpoint()

# Original endpoints
@app.post("/predict/")
async def predict(file: UploadFile = File(...)):
    """Perform object detection on an uploaded image."""

    # Read image file
    contents = await file.read()
    image = preprocess_image(contents)

    # Perform inference
    results = model_manager.predict_chest_xray(image)
    detections = model_manager.extract_detections(results)

    return {"detections": detections}


@app.post('/yolo_predict')
async def yolo_predict(file: UploadFile = File(...)):
    """Process an image using YOLO and return the annotated image."""
    contents = await file.read()
    img = Image.open(BytesIO(contents)).convert("RGB")

    results = model_manager.predict_chest_xray(img)

    # Convert result to PIL Image
    img_with_boxes = results[0].plot()
    img_with_boxes = Image.fromarray(img_with_boxes)

    # Save to buffer
    img_buffer = save_image_to_memory(img_with_boxes)

    return StreamingResponse(img_buffer, media_type="image/jpeg")


class Base64Image(BaseModel):
    image: str

@app.post('/yolo_predict_base64')
async def yolo_predict_base64(image_data: Base64Image):
    """Process a base64 encoded image using YOLO and return the annotated image in base64."""
    try:
        # Decode base64 image
        image_bytes = base64.b64decode(image_data.image)
        img = Image.open(BytesIO(image_bytes)).convert("RGB")

        # Perform prediction
        results = model_manager.predict_chest_xray(img)

        # Convert result to PIL Image
        img_with_boxes = results[0].plot()
        img_with_boxes = Image.fromarray(img_with_boxes)

        # Convert to base64
        buffered = BytesIO()
        img_with_boxes.save(buffered, format="JPEG")
        img_str = base64.b64encode(buffered.getvalue()).decode()

        return JSONResponse(content={"image": img_str})

    except Exception as e:
        return JSONResponse(
            status_code=400,
            content={"error": f"Failed to process image: {str(e)}"}
        )

# Basic health check endpoint
@app.get("/health")
async def health():
    return {"status": "healthy"}

# Run API server
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
