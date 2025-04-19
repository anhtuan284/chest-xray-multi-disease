import io
import zipfile
import os

import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt

from PIL import ImageDraw, ImageFont, Image

from keras._tf_keras.keras.applications.densenet import preprocess_input
from keras._tf_keras.keras.preprocessing.image import img_to_array, array_to_img
from keras._tf_keras.keras.models import Model

def make_gradcam_heatmap(img_array, model, last_conv_layer_name, pred_index=None):
    grad_model = Model(
        inputs=[model.input],
        outputs=[model.get_layer(last_conv_layer_name).output, model.output]
    )

    with tf.GradientTape() as tape:
        last_conv_layer_output, preds = grad_model(img_array)
        if pred_index is None:
            pred_index = tf.argmax(preds[0])
        class_channel = preds[:, pred_index]

    grads = tape.gradient(class_channel, last_conv_layer_output)
    pooled_grads = tf.reduce_mean(grads, axis=(0, 1, 2))
    last_conv_layer_output = last_conv_layer_output[0]
    heatmap = last_conv_layer_output @ pooled_grads[..., tf.newaxis]
    heatmap = tf.squeeze(heatmap)
    heatmap = tf.maximum(heatmap, 0) / tf.math.reduce_max(heatmap)
    return heatmap.numpy()


def display_gradcam(img, heatmap, alpha=0.5):
    heatmap = np.uint8(255 * heatmap)
    jet = plt.cm.get_cmap("jet")
    jet_colors = jet(np.arange(256))[:, :3]
    jet_heatmap = jet_colors[heatmap]
    jet_heatmap = array_to_img(jet_heatmap)
    jet_heatmap = jet_heatmap.resize((img.shape[1], img.shape[0]))
    jet_heatmap = img_to_array(jet_heatmap)
    superimposed_img = jet_heatmap * alpha + img
    superimposed_img = array_to_img(superimposed_img)
    return superimposed_img


def add_text_to_image(image, text, font_size=40):
    draw = ImageDraw.Draw(image)

    try:
        font = ImageFont.truetype("arial.ttf", font_size)  # Use Arial font if available
    except IOError:
        font = ImageFont.load_default()  # Fallback to default if Arial is not available

    # Set text position and color
    text_position = (20, image.height - 50)  # Adjusted position slightly higher
    text_color = (255, 255, 255)  # White text

    # Add the text to the image
    draw.text(text_position, text, fill=text_color, font=font)

    return image


def get_img_array_from_memory(img, size):
    """
    Convert PIL image to preprocessed numpy array ready for the model
    """
    # Ensure img is in RGB mode (3 channels)
    if img.mode != 'RGB':
        img = img.convert('RGB')
    
    # Resize the image
    img = img.resize(size)
    
    # Convert to array and add batch dimension
    img_array = img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    
    # Preprocess for DenseNet
    return preprocess_input(img_array)


def process_and_generate_images_from_memory(img, model, last_conv_layer_name, labels, top=3, font_size=40):
    """Process image and generate GradCAM visualizations with optional font size."""
    try:
        # Ensure image is in RGB mode
        if img.mode != 'RGB':
            img = img.convert('RGB')
        
        # Get preprocessed image array
        img_array = get_img_array_from_memory(img, size=(224, 224))
        
        # Get model predictions
        preds = model.predict(img_array)
        top_indices = preds[0].argsort()[-top:][::-1]

        images = []

        for index in top_indices[:3]:
            disease_name = labels[index]
            confidence = preds[0][index] * 100  # Convert to percentage

            # Generate heatmap
            heatmap = make_gradcam_heatmap(img_array, model, last_conv_layer_name, pred_index=index)

            # Generate Grad-CAM image - convert to RGB first
            rgb_img = img_to_array(img)
            superimposed_img = display_gradcam(rgb_img, heatmap)

            # Add disease name and confidence score to the image
            text = f"{disease_name}: {confidence:.2f}%"
            final_image = add_text_to_image(superimposed_img, text, font_size=font_size)

            images.append(final_image)

        return images
    except Exception as e:
        # Log the error for debugging
        import traceback
        print(f"Error in process_and_generate_images_from_memory: {e}")
        print(traceback.format_exc())
        raise


def save_image_to_memory(image, fmt='JPEG'):
    """Save image to a BytesIO memory buffer."""
    img_buffer = io.BytesIO()
    image.save(img_buffer, format=fmt)
    img_buffer.seek(0)
    return img_buffer


def create_zip_from_images(images):
    """Create a ZIP archive from a list of images in-memory."""
    zip_buffer = io.BytesIO()
    with zipfile.ZipFile(zip_buffer, 'w') as zip_file:
        for i, img in enumerate(images):
            img_buffer = save_image_to_memory(img)
            zip_file.writestr(f'image_{i}.jpg', img_buffer.getvalue())
    zip_buffer.seek(0)
    return zip_buffer