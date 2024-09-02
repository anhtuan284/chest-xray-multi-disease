import io

from flask import Flask, request, jsonify, send_file
import torch
from ultralytics import YOLO
from PIL import Image

app = Flask(__name__)
model = YOLO('models/best.pt')

@app.route('/yolo_predict', methods=['POST'])
def yolo_predict():
    img_bytes = request.files['image'].read()
    img = Image.open(io.BytesIO(img_bytes)).convert("RGB")

    results = model.predict(img, imgsz=640)

    result = results[0]

    img_with_boxes = result.plot()

    # Change numpy array to PIL.Image
    img_with_boxes_pil = Image.fromarray(img_with_boxes)

    # Lưu kết quả vào một object byte
    img_byte_arr = io.BytesIO()
    img_with_boxes_pil.save(img_byte_arr, format='JPEG')
    img_byte_arr.seek(0)

    return send_file(img_byte_arr, mimetype='image/jpeg')

if __name__ == '__main__':
    app.run(debug=True)
