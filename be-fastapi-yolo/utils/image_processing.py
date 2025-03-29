import io
import cv2
import numpy as np

from PIL import Image
from io import BytesIO


def preprocess_image(contents: bytes) -> np.ndarray:
    """Preprocess an image from bytes to a numpy array in RGB format."""
    image = Image.open(BytesIO(contents)).convert("RGB")  # Ensure RGB format
    
    # Convert PIL image to NumPy array (H, W, C)
    image = np.array(image)
    
    # Ensure the image is in the correct format (uint8 and has 3 color channels)
    if image.ndim == 2:
        # Convert grayscale to RGB
        image = cv2.cvtColor(image, cv2.COLOR_GRAY2RGB)
    elif image.shape[-1] == 4:
        # Convert RGBA to RGB
        image = cv2.cvtColor(image, cv2.COLOR_RGBA2RGB)
    
    return image


def save_image_to_memory(image: Image.Image, fmt='JPEG') -> io.BytesIO:
    """Save image to a BytesIO memory buffer."""
    img_buffer = io.BytesIO()
    image.save(img_buffer, format=fmt)
    img_buffer.seek(0)
    return img_buffer
