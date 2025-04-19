import numpy as np

from ultralytics import YOLO
from PIL import Image
from typing import Dict, List, Any, Union


class ModelManager:
    """Manager for YOLO models."""
    
    def __init__(self):
        self.chest_xray_model = YOLO("./models/best.pt")
    
    def predict_chest_xray(self, image: Union[np.ndarray, Image.Image], img_size: int = 640):
        """Run prediction with chest X-ray model."""
        return self.chest_xray_model.predict(image, imgsz=img_size)
    
    def extract_detections(self, results) -> List[Dict[str, Any]]:
        """Extract detection information from YOLO results."""
        detections = []
        for r in results:
            for box in r.boxes:
                detections.append({
                    "class": int(box.cls),
                    "confidence": float(box.conf),
                    "bbox": box.xyxy.tolist()
                })
        return detections
