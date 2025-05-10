import os
from typing import List

from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    """Application settings."""
    # Model configuration
    MODEL_PATH: str = os.environ.get('MODEL_PATH', 'models/DenseNet121_epoch_30.keras')
    LAST_CONV_LAYER: str = "conv5_block16_concat"  # Last convolutional layer name for DenseNet121
    CLASS_NAMES: List[str] = [
        "Atelectasis", "Cardiomegaly", "Effusion", "Infiltration", "Mass", "Nodule",
        "Pneumonia", "Pneumothorax", "Consolidation", "Edema", "Emphysema", "Fibrosis",
        "Pleural_Thickening", "Hernia",
    ]
    
    # Cloudinary configuration
    CLOUDINARY_CLOUD_NAME: str = os.environ.get('CLOUDINARY_CLOUD_NAME', '')
    CLOUDINARY_API_KEY: str = os.environ.get('CLOUDINARY_API_KEY', '')
    CLOUDINARY_API_SECRET: str = os.environ.get('CLOUDINARY_API_SECRET', '')
    
    # Redis configuration for Celery
    REDIS_URL: str = os.environ.get('REDIS_URL', 'redis://localhost:6379/0')
    
    # MinIO configuration
    MINIO_ENDPOINT: str = os.environ.get('MINIO_ENDPOINT', 'localhost:9000')
    MINIO_ACCESS_KEY: str = os.environ.get('MINIO_ACCESS_KEY', 'minioadmin')
    MINIO_SECRET_KEY: str = os.environ.get('MINIO_SECRET_KEY', 'minioadmin')
    MINIO_SECURE: bool = os.environ.get('MINIO_SECURE', 'false').lower() == 'true'
    MINIO_BUCKET_NAME: str = os.environ.get('MINIO_BUCKET_NAME', 'chestscan')
    
    class Config:
        env_file = '.env'
        case_sensitive = True

settings = Settings()
