# Chest X-ray Disease Multi-Classification

This project aims to classify chest X-ray images into multiple categories of diseases using deep learning models. The project utilizes the YOLO model for object detection and the DenseNet model for classification. It provides a web interface for users to upload images for analysis and download results.

## Table of Contents

- [Project Description](#project-description)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Contributing](#contributing)
- [License](#license)

## Project Description

Chest X-rays are essential for diagnosing various lung diseases. This project uses deep learning models to assist in identifying diseases such as:

- Atelectasis
- Cardiomegaly
- Effusion
- Infiltration
- Mass
- Nodule
- Pneumonia
- Pneumothorax
- Consolidation
- Edema
- Emphysema
- Fibrosis
- Pleural Thickening
- Hernia

The project features a Flask web application where users can upload chest X-ray images and receive analysis results, including Grad-CAM visualizations.

## Features

- Upload and analyze chest X-ray images.
- Object detection using YOLO model.
- Multi-class classification using DenseNet model.
- Grad-CAM visualization for interpretability.
- Downloadable results in ZIP format.

## Technologies Used

- Python 3.10
- Flask
- Keras
- TensorFlow
- YOLO (Ultralytics)
- PIL (Pillow)
- HTML/CSS/JavaScript for the front-end

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/chest-xray-disease-multi-classification.git
   cd chest-xray-disease-multi-classification
Set up a virtual environment (optional but recommended):

bash

python -m venv .venv
source .venv/bin/activate  # On Windows use .venv\Scripts\activate

Install the required packages:

bash

    pip install -r requirements.txt

## Usage

    Run the Flask application:

    bash

    python app.py

    Open your web browser and go to http://127.0.0.1:5000.

    Upload a chest X-ray image and click "Upload & Analyze" to see the results.

## API Endpoints

    POST /yolo_predict
        Upload an image to detect objects using the YOLO model.
        Returns the image with bounding boxes for detected objects.

    POST /densenet_predict
        Upload an image for multi-class classification using the DenseNet model.
        Returns a ZIP file with Grad-CAM visualizations.

## Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request for any improvements or features.
License

This project is licensed under the MIT License. See the LICENSE file for more details.

sql


### Instructions to Customize
- **Project Description**: Feel free to adjust the description to match your specific goals or objectives.
- **Clone Link**: Replace the `https://github.com/yourusername/chest-xray-disease-multi-classification.git` with the actual URL of your repository.
- **License**: If you have a specific license for your project, make sure to include it in the LICENSE file and update the reference accordingly.

You can create a `README.md` file in the root of your project directory and copy the content above into it. Let me know if you need any modifications or additional sections!

