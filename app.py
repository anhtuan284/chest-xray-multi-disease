import io
import zipfile
import keras
import imageutil
from flask_cors import CORS
from flask import Flask, request, send_file
from ultralytics import YOLO
from PIL import Image

app = Flask(__name__)
CORS(app)

# Load models
yolo_model = YOLO('models/best.pt')
densenet_model = keras.saving.load_model('DenseNet121_epoch_30.keras')


class CFG:
    CLASS_NAMES = [
        "Atelectasis",
        "Cardiomegaly",
        "Effusion",
        "Infiltration",
        "Mass",
        "Nodule",
        "Pneumonia",
        "Pneumothorax",
        "Consolidation",
        "Edema",
        "Emphysema",
        "Fibrosis",
        "Pleural_Thickening",
        "Hernia",
    ]
    LAST_CONV_LAYER = 'conv5_block16_concat'


def load_image_from_request(request_file):
    """Load image from incoming request."""
    img_bytes = request_file.read()
    return Image.open(io.BytesIO(img_bytes)).convert("RGB")


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


@app.route('/yolo_predict', methods=['POST'])
def yolo_predict():
    img = load_image_from_request(request.files['image'])
    results = yolo_model.predict(img, imgsz=640)
    img_with_boxes = Image.fromarray(results[0].plot())  # Convert result to PIL Image
    img_buffer = save_image_to_memory(img_with_boxes)

    return send_file(img_buffer, mimetype='image/jpeg')


@app.route('/densenet_predict', methods=['POST'])
def densenet_predict():
    img = load_image_from_request(request.files['image'])
    images = imageutil.process_and_generate_images_from_memory(
        img, densenet_model, CFG.LAST_CONV_LAYER, CFG.CLASS_NAMES
    )
    zip_buffer = create_zip_from_images(images)

    return send_file(
        zip_buffer,
        mimetype='application/zip',
        as_attachment=True,
        download_name='grad_cam_images.zip'
    )


if __name__ == '__main__':
    app.run(debug=True)
