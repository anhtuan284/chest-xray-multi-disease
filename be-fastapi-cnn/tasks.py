import io
import base64
import time
import os
import traceback
from PIL import Image

# Set environment variable to control TensorFlow log verbosity
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'  # Reduce TensorFlow log verbosity

import keras
import numpy as np
import tensorflow as tf
from celery import shared_task, states
from celery.exceptions import Ignore

# Attempt to properly configure GPU for Celery workers
USE_GPU = False
try:
    # Check if GPU is available
    physical_devices = tf.config.list_physical_devices('GPU')
    if len(physical_devices) > 0:
        print(f"Found {len(physical_devices)} GPU(s). Attempting to use GPU.")
        # Try to enable memory growth to avoid allocating all GPU memory at once
        for device in physical_devices:
            tf.config.experimental.set_memory_growth(device, True)
            print(f"Enabled memory growth for {device}")
        
        # Try a small tensor operation to test CUDA context
        with tf.device('/GPU:0'):
            test_tensor = tf.constant([[1.0, 2.0], [3.0, 4.0]])
            test_result = tf.matmul(test_tensor, test_tensor)
            _ = test_result.numpy()  # Force execution
            
        print("CUDA context successfully initialized. GPU will be used.")
        USE_GPU = True
    else:
        print("No GPUs found, using CPU.")
except Exception as e:
    print(f"Error initializing GPU: {e}. Falling back to CPU.")

# Import application modules
from config import settings
from services.image_service import ImageService
from services.storage_service import storage_service
from utils.gradcam import (
    process_and_generate_images_from_memory,
    get_img_array_from_memory,
    create_zip_from_images
)
from utils.metrics import track_predictions, IMAGE_SIZE_HISTOGRAM

# Load model based on available hardware
try:
    device = '/GPU:0' if USE_GPU else '/CPU:0'
    print(f"Loading DenseNet model on {device}...")
    
    with tf.device(device):
        densenet_model = keras.models.load_model(settings.MODEL_PATH)
    
    print(f"DenseNet model loaded successfully on {device}.")
except Exception as e:
    print(f"Error loading DenseNet model: {e}")
    # Try fallback to CPU if GPU loading failed
    if USE_GPU:
        print("Trying fallback to CPU...")
        try:
            with tf.device('/CPU:0'):
                densenet_model = keras.models.load_model(settings.MODEL_PATH)
            print("DenseNet model loaded successfully on CPU (fallback).")
        except Exception as cpu_e:
            print(f"Error loading model on CPU: {cpu_e}")
            densenet_model = None
    else:
        densenet_model = None

@shared_task(bind=True, name='tasks.predict_densenet')
def predict_densenet(self, image_base64, font_size=40):
    """
    Celery task for processing DenseNet prediction with GradCAM
    and returning zip of result images
    
    Args:
        self: Task instance
        image_base64: Base64 encoded image string
        font_size: Font size for image annotations
        
    Returns:
        A dictionary with result status and zip file data in base64
    """
    try:
        self.update_state(state=states.STARTED, meta={'status': 'Processing image'})
        
        if not densenet_model:
            self.update_state(
                state=states.FAILURE,
                meta={'status': 'Model not loaded'}
            )
            raise Ignore()
        
        # Decode base64 image
        if "," in image_base64:
            image_base64 = image_base64.split(",")[1]
        
        image_data = base64.b64decode(image_base64)
        IMAGE_SIZE_HISTOGRAM.observe(len(image_data))
        
        # Load and process image
        img = Image.open(io.BytesIO(image_data))
        if img.mode != 'RGB':
            img = img.convert('RGB')
        
        # Process image to generate GradCAM images
        device = '/GPU:0' if USE_GPU else '/CPU:0'
        with tf.device(device):
            try:
                # Process image to generate GradCAM images
                images = process_and_generate_images_from_memory(
                    img, densenet_model, settings.LAST_CONV_LAYER,
                    settings.CLASS_NAMES, font_size=font_size
                )
                
                # Calculate predictions for metrics
                img_array = get_img_array_from_memory(img, size=(224, 224))
                predictions = densenet_model.predict(img_array)
            except Exception as e:
                print(f"Error during prediction on {device}: {e}")
                # If GPU fails, try CPU as fallback
                if USE_GPU:
                    with tf.device('/CPU:0'):
                        images = process_and_generate_images_from_memory(
                            img, densenet_model, settings.LAST_CONV_LAYER,
                            settings.CLASS_NAMES, font_size=font_size
                        )
                        
                        img_array = get_img_array_from_memory(img, size=(224, 224))
                        predictions = densenet_model.predict(img_array)
                else:
                    raise
        
        # Track prediction metrics
        track_predictions(predictions, settings.CLASS_NAMES)
        
        # Create zip file
        zip_buffer = create_zip_from_images(images)
        
        # Convert zip data to base64
        zip_base64 = base64.b64encode(zip_buffer.getvalue()).decode('utf-8')
        
        return {
            'status': 'success',
            'zip_base64': zip_base64
        }
        
    except Exception as e:
        error_msg = f"Error in prediction task: {str(e)}\n{traceback.format_exc()}"
        print(error_msg)
        self.update_state(
            state=states.FAILURE,
            meta={
                'status': 'error',
                'error': error_msg
            }
        )
        raise Ignore()

@shared_task(bind=True, name='tasks.predict_densenet_cloudinary')
def predict_densenet_cloudinary(self, image_base64, font_size=40):
    """
    Celery task for processing DenseNet prediction with GradCAM
    and uploading results to Cloudinary
    
    Args:
        self: Task instance
        image_base64: Base64 encoded image string
        font_size: Font size for image annotations
        
    Returns:
        A dictionary with result status and Cloudinary URLs
    """
    try:
        self.update_state(state=states.STARTED, meta={'status': 'Processing image'})
        
        if not densenet_model:
            self.update_state(
                state=states.FAILURE,
                meta={'status': 'Model not loaded'}
            )
            raise Ignore()
        
        # Decode and process image
        img = ImageService.load_image_from_base64(image_base64)
        IMAGE_SIZE_HISTOGRAM.observe(len(base64.b64decode(image_base64.split(",")[1] if "," in image_base64 else image_base64)))
        
        # Process with TensorFlow using selected device
        device = '/GPU:0' if USE_GPU else '/CPU:0'
        with tf.device(device):
            try:
                # Process image to generate GradCAM images
                images = process_and_generate_images_from_memory(
                    img, densenet_model, settings.LAST_CONV_LAYER,
                    settings.CLASS_NAMES, font_size=font_size
                )
                
                # Calculate predictions for metrics
                img_array = get_img_array_from_memory(img, size=(224, 224))
                predictions = densenet_model.predict(img_array)
            except Exception as e:
                print(f"Error during prediction on {device}: {e}")
                # If GPU fails, try CPU as fallback
                if USE_GPU:
                    with tf.device('/CPU:0'):
                        images = process_and_generate_images_from_memory(
                            img, densenet_model, settings.LAST_CONV_LAYER,
                            settings.CLASS_NAMES, font_size=font_size
                        )
                        
                        img_array = get_img_array_from_memory(img, size=(224, 224))
                        predictions = densenet_model.predict(img_array)
                else:
                    raise
        
        # Track prediction metrics
        track_predictions(predictions, settings.CLASS_NAMES)
        
        # Upload images to Cloudinary
        self.update_state(state='UPLOADING', meta={'status': 'Uploading images to Cloudinary'})
        image_urls = [ImageService.upload_to_cloudinary(image) for image in images]
        
        return {
            'status': 'success',
            'image_urls': ",".join(image_urls)
        }
        
    except Exception as e:
        error_msg = f"Error in prediction task: {str(e)}\n{traceback.format_exc()}"
        print(error_msg)
        self.update_state(
            state=states.FAILURE,
            meta={
                'status': 'error',
                'error': error_msg
            }
        )
        raise Ignore()

@shared_task(bind=True, name='tasks.predict_densenet_minio')
def predict_densenet_minio(self, image_base64, font_size=40):
    """
    Celery task for processing DenseNet prediction with GradCAM
    and uploading results to MinIO storage
    
    Args:
        self: Task instance
        image_base64: Base64 encoded image string
        font_size: Font size for image annotations
        
    Returns:
        A dictionary with result status and MinIO URLs
    """
    try:
        self.update_state(state=states.STARTED, meta={'status': 'Processing image'})
        
        if not densenet_model:
            self.update_state(
                state=states.FAILURE,
                meta={'status': 'Model not loaded'}
            )
            raise Ignore()
        
        # Decode and process image
        if "," in image_base64:
            image_base64 = image_base64.split(",")[1]
            
        image_data = base64.b64decode(image_base64)
        IMAGE_SIZE_HISTOGRAM.observe(len(image_data))
        
        img = Image.open(io.BytesIO(image_data))
        if img.mode != 'RGB':
            img = img.convert('RGB')
        
        # Process with TensorFlow using selected device
        device = '/GPU:0' if USE_GPU else '/CPU:0'
        with tf.device(device):
            try:
                # Process image to generate GradCAM images
                self.update_state(state='PROCESSING', meta={'status': 'Generating GradCAM visualizations'})
                images = process_and_generate_images_from_memory(
                    img, densenet_model, settings.LAST_CONV_LAYER,
                    settings.CLASS_NAMES, font_size=font_size
                )
                
                # Calculate predictions for metrics
                img_array = get_img_array_from_memory(img, size=(224, 224))
                predictions = densenet_model.predict(img_array)
            except Exception as e:
                print(f"Error during prediction on {device}: {e}")
                # If GPU fails, try CPU as fallback
                if USE_GPU:
                    with tf.device('/CPU:0'):
                        images = process_and_generate_images_from_memory(
                            img, densenet_model, settings.LAST_CONV_LAYER,
                            settings.CLASS_NAMES, font_size=font_size
                        )
                        
                        img_array = get_img_array_from_memory(img, size=(224, 224))
                        predictions = densenet_model.predict(img_array)
                else:
                    raise
        
        # Track prediction metrics
        track_predictions(predictions, settings.CLASS_NAMES)
        
        # Upload images to MinIO
        self.update_state(state='UPLOADING', meta={'status': 'Uploading images to MinIO storage'})
        
        # Use storage_service to upload images to MinIO
        image_urls = storage_service.upload_images(images, prefix='gradcam')
        
        return {
            'status': 'success',
            'image_urls': image_urls
        }
        
    except Exception as e:
        error_msg = f"Error in prediction task: {str(e)}\n{traceback.format_exc()}"
        print(error_msg)
        self.update_state(
            state=states.FAILURE,
            meta={
                'status': 'error',
                'error': error_msg
            }
        )
        raise Ignore()