# Chest X-ray Analyzer

A mobile and web application for analyzing chest X-ray images using AI models for disease detection and visualization.

## Overview

The Chest X-ray Analyzer is a comprehensive solution for healthcare professionals to analyze and interpret chest X-ray images. The application leverages state-of-the-art AI models (YOLO and DenseNet121) to detect and highlight potential abnormalities in chest X-ray images.

## Features

- **Multi-model Analysis**: Uses both YOLO (object detection) and DenseNet121 (classification with heatmaps) models
- **Cross-platform Support**: Works on iOS, Android, and Web
- **Patient Management**: Track patient records and X-ray history
- **Interactive UI**: User-friendly interface with responsive design for different screen sizes
- **Image Manipulation**: Zoom, pan, and analyze X-ray images with detailed visualization
- **Real-time Analysis**: Quick processing and visualization of results

## Architecture

The application uses a multi-tier architecture:

- **Frontend**: Flutter application (this repository)
- **Backend Services**: 
  - FastAPI service for CNN-based analysis (DenseNet121)
  - FastAPI service for YOLO-based detection
  - Strapi CMS for patient data management
  - Vector database for RAG (Retrieval-Augmented Generation)

## Installation and Setup

### Prerequisites

- Flutter SDK 3.29.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / Xcode for mobile deployment
- Backend services set up and running

### Setup Steps

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/chest-xray-multi-disease.git
   ```

2. Navigate to the Flutter project:
   ```
   cd chest-xray-multi-disease/fe_flutter
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the application:
   ```
   flutter run
   ```

### Configuration

- Update the API endpoints in `config.dart` to match your backend services
- Adjust the application settings in `settings.json` as needed

## Development

### Project Structure

```
lib/
├── main.dart                  # Application entry point
├── src/
    ├── core/                  # Core functionality
    │   ├── models/            # Data models
    │   ├── services/          # Core services
    │   └── utils/             # Utility functions
    ├── features/              # Feature modules
    │   ├── prediction/        # X-ray analysis feature
    │   │   ├── models/        # Prediction models
    │   │   ├── presentation/  # UI components
    │   │   └── services/      # Prediction services
    │   ├── patients/          # Patient management feature
    │   └── settings/          # Application settings
    └── app.dart               # Application configuration
```

### Key Technologies

- **State Management**: Riverpod
- **Data Handling**: Built Value for immutable models
- **Navigation**: GoRouter
- **Backend Integration**: RESTful API integration with backend services
- **Image Processing**: Custom widgets for image manipulation and visualization

## Deployment

### Web Deployment

The application can be deployed to Vercel or other web hosting services:

1. Build the web app:
   ```
   flutter build web --release
   ```

2. Deploy the `build/web` directory to your hosting service

### Mobile Deployment

1. Build the Android app:
   ```
   flutter build apk --release
   ```

2. Build the iOS app:
   ```
   flutter build ios --release
   ```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Flutter team for the amazing framework
- YOLO and DenseNet121 model creators for the AI capabilities
- All contributors to this project
