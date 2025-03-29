import io
import base64

import cloudinary
import cloudinary.uploader
from PIL import Image
from config import settings  # Changed from relative to absolute import

class ImageService:
    @staticmethod
    def load_image_from_request(request_file) -> Image.Image:
        """Load image from incoming request."""
        try:
            img_bytes = request_file.read()
            return Image.open(io.BytesIO(img_bytes)).convert("RGB")
        except Exception as e:
            raise ValueError(f"Failed to load image from request: {str(e)}")

    @staticmethod
    def load_image_from_base64(base64_str: str) -> Image.Image:
        """Convert Base64 string to PIL Image."""
        try:
            img_data = base64.b64decode(base64_str)
            return Image.open(io.BytesIO(img_data)).convert("RGB")
        except Exception as e:
            raise ValueError(f"Failed to decode base64 image: {str(e)}")

    @staticmethod
    def upload_to_cloudinary(image: Image.Image) -> str:
        """Upload image to Cloudinary and return the URL."""
        img_buffer = io.BytesIO()
        image.save(img_buffer, format='JPEG')
        img_buffer.seek(0)

        try:
            upload_response = cloudinary.uploader.upload(img_buffer, folder="rebuildzone")
            return upload_response['secure_url']
        except Exception as e:
            raise RuntimeError(f"Failed to upload to Cloudinary: {str(e)}")
