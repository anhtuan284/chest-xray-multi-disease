import os
import io
import uuid
import socket
from datetime import timedelta
from typing import List, Dict, Optional
from minio import Minio
from minio.error import S3Error
from dotenv import load_dotenv

load_dotenv()

class StorageService:
    """Service for handling object storage operations using MinIO"""
    
    def __init__(self, endpoint: str = None, access_key: str = None, 
                 secret_key: str = None, secure: bool = None,
                 bucket_name: str = None):
        """Initialize MinIO client with configuration from environment or parameters"""
        
        # Use parameters if provided, otherwise use environment variables
        self.endpoint = endpoint or os.getenv('MINIO_ENDPOINT', 'minio:9000')
        self.access_key = access_key or os.getenv('MINIO_ACCESS_KEY', 'minioadmin')
        self.secret_key = secret_key or os.getenv('MINIO_SECRET_KEY', 'minioadmin')
        
        # If secure parameter is None, check environment variable or default to False
        if secure is None:
            self.secure = os.getenv('MINIO_SECURE', 'false').lower() == 'true'
        else:
            self.secure = secure
            
        self.bucket_name = bucket_name or os.getenv('MINIO_BUCKET_NAME', 'chestscan')
        
        # Check if we're running outside Docker and need to use localhost instead of container hostname
        self._adjust_endpoint_for_local_development()
        
        print(f"Initializing MinIO client with endpoint: {self.endpoint}")
        
        # Initialize MinIO client with error handling
        try:
            self.client = Minio(
                endpoint=self.endpoint,
                access_key=self.access_key,
                secret_key=self.secret_key,
                secure=self.secure
            )
            
            self._ensure_bucket_exists()
        except Exception as e:
            print(f"Error initializing MinIO client: {e}")
            print("WARNING: MinIO storage will not be available. Check your connection settings.")
            self.client = None
    
    def _adjust_endpoint_for_local_development(self):
        """
        Check if we need to adjust the endpoint for local development.
        If the endpoint contains a hostname that can't be resolved,
        replace it with localhost.
        """
        if ":" in self.endpoint:
            hostname, port = self.endpoint.split(":", 1)
            
            # Check if hostname is resolvable
            try:
                socket.gethostbyname(hostname)
                # If we get here, hostname is valid
            except socket.gaierror:
                # Hostname can't be resolved, replace with localhost
                print(f"Cannot resolve MinIO hostname '{hostname}'. Replacing with 'localhost'.")
                self.endpoint = f"localhost:{port}"
    
    def _ensure_bucket_exists(self):
        """Create the bucket if it doesn't exist"""
        if not self.client:
            return
            
        try:
            if not self.client.bucket_exists(self.bucket_name):
                self.client.make_bucket(self.bucket_name)
                print(f"Created bucket: {self.bucket_name}")
            else:
                print(f"Bucket '{self.bucket_name}' already exists")
        except S3Error as e:
            print(f"Error ensuring bucket exists: {e}")
        except Exception as e:
            print(f"Unexpected error checking bucket: {e}")
    
    def upload_file(self, file_data: bytes, object_name: Optional[str] = None, 
                   content_type: str = 'application/octet-stream') -> str:
        """
        Upload a file to MinIO storage
        
        Args:
            file_data: The file data as bytes
            object_name: Name of the object in the bucket (generated if not provided)
            content_type: MIME type of the file
        
        Returns:
            URL to access the uploaded file
        """
        if not self.client:
            raise RuntimeError("MinIO client not initialized")
            
        try:
            # Generate a unique object name if not provided
            if not object_name:
                ext = self._get_extension_from_content_type(content_type)
                object_name = f"gradcam/{uuid.uuid4()}{ext}"
            
            # Upload the file
            self.client.put_object(
                bucket_name=self.bucket_name,
                object_name=object_name,
                data=io.BytesIO(file_data),
                length=len(file_data),
                content_type=content_type
            )
            
            # Generate a presigned URL (valid for 7 days)
            url = self.client.presigned_get_object(
                bucket_name=self.bucket_name,
                object_name=object_name,
                expires=timedelta(days=7)
            )
            
            return url
            
        except S3Error as e:
            print(f"Error uploading file to MinIO: {e}")
            raise
    
    def upload_images(self, images: List, prefix: str = 'gradcam') -> List[str]:
        """
        Upload multiple PIL images to MinIO storage
        
        Args:
            images: List of PIL Image objects
            prefix: Folder prefix for the objects
            
        Returns:
            List of URLs to access the uploaded images
        """
        if not self.client:
            raise RuntimeError("MinIO client not initialized")
            
        urls = []
        
        try:
            for i, image in enumerate(images):
                # Convert PIL image to bytes
                img_buffer = io.BytesIO()
                image.save(img_buffer, format='JPEG')
                img_bytes = img_buffer.getvalue()
                
                # Generate object name
                object_name = f"{prefix}/{uuid.uuid4()}.jpg"
                
                # Upload image
                url = self.upload_file(
                    file_data=img_bytes,
                    object_name=object_name,
                    content_type='image/jpeg'
                )
                
                urls.append(url)
                
            return urls
            
        except Exception as e:
            print(f"Error uploading images to MinIO: {e}")
            raise
    
    def _get_extension_from_content_type(self, content_type: str) -> str:
        """Get appropriate file extension based on content type"""
        content_type_map = {
            'image/jpeg': '.jpg',
            'image/png': '.png',
            'image/gif': '.gif',
            'application/zip': '.zip',
            'application/pdf': '.pdf',
            'text/plain': '.txt'
        }
        
        return content_type_map.get(content_type, '')
    
    def get_bucket_policy(self) -> dict:
        """Get the current bucket policy"""
        if not self.client:
            raise RuntimeError("MinIO client not initialized")
            
        try:
            policy = self.client.get_bucket_policy(self.bucket_name)
            return policy
        except S3Error as e:
            print(f"Error getting bucket policy: {e}")
            return {}

# Create singleton instance
storage_service = StorageService()