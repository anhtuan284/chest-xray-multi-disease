import base64
import io
from PIL import Image
import cloudinary
import cloudinary.uploader
import time
from config import settings  # Changed from relative to absolute import

class ImageService:
    @staticmethod
    def load_image_from_request(file_like_object):
        """
        Load image from file-like object and ensure RGB mode
        """
        img = Image.open(file_like_object)
        # Ensure RGB mode for compatibility with the model
        if img.mode != 'RGB':
            img = img.convert('RGB')
        return img
    
    @staticmethod
    def load_image_from_bytes(image_bytes):
        """
        Load a PIL Image from bytes and ensure RGB mode
        """
        img = Image.open(io.BytesIO(image_bytes))
        # Ensure RGB mode for compatibility with the model
        if img.mode != 'RGB':
            img = img.convert('RGB')
        return img
    
    @staticmethod
    def load_image_from_base64(base64_string):
        """
        Load image from base64 string and ensure RGB mode
        """
        try:
            # Remove data URL prefix if present
            if "," in base64_string:
                base64_string = base64_string.split(",")[1]
                
            image_data = base64.b64decode(base64_string)
            img = Image.open(io.BytesIO(image_data))
            
            # Ensure RGB mode for compatibility with the model
            if img.mode != 'RGB':
                img = img.convert('RGB')
                
            return img
        except Exception as e:
            raise ValueError(f"Failed to decode base64 image: {str(e)}")
    
    @staticmethod
    def upload_to_cloudinary(image):
        """Upload image to Cloudinary and return URL"""
        from utils import save_image_to_memory
        
        # Convert PIL image to memory buffer
        img_buffer = save_image_to_memory(image)
        
        # Upload to Cloudinary
        upload_result = cloudinary.uploader.upload(
            img_buffer,
            folder="chestscan/gradcam",
            public_id=f"gradcam_{time.time()}_{hash(str(img_buffer.getvalue())[:100])}"
        )
        
        return upload_result['secure_url']
