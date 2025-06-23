# 👤 Face Recognition Flutter App

This Flutter app performs **on-device face recognition** using a pre-trained **FaceNet model** (`facenet_mobilenet.tflite`). It lets users select two face images, detects faces using **Google ML Kit**, generates **embeddings**, and compares them to calculate how similar the faces are.

---

## 🔍 What It Does

- **Face Selection**: Users select two images from the gallery.
- **Face Detection**: Google ML Kit is used to detect and crop the main faces from each image.
- **Embedding Generation**: A lightweight `.tflite` version of the FaceNet model generates 128-dimensional embeddings for each detected face.
- **Similarity Calculation**: The app calculates **cosine similarity** between the two embeddings and gives a percentage score with a simple label like "Very Similar".

---

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK (version 3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ShallowAwe/Facial_Recognition.git
   cd Facial_Recognition
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Place the model file:**
   - Download or ensure `facenet_mobilenet.tflite` is in the `assets/models/` folder
   - Update `pubspec.yaml` to include the model in assets

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

### Core Dependencies
- `flutter/material.dart` - UI framework
- `tflite_flutter` - TensorFlow Lite integration
- `google_ml_kit` - Face detection
- `image_picker` - Image selection
- `image` - Image processing

### Add to pubspec.yaml:
```yaml
dependencies:
  flutter:
    sdk: flutter
  tflite_flutter: ^0.10.4
  google_ml_kit: ^0.16.0
  image_picker: ^1.0.4
  image: ^4.1.3

flutter:
  assets:
    - assets/models/facenet_mobilenet.tflite
```

---

## 🧠 Model Setup

### FaceNet Model
1. Download the `facenet_mobilenet.tflite` model
2. Place it in `assets/models/facenet_mobilenet.tflite`
3. Ensure the model is included in `pubspec.yaml` assets

### Model Information
- **Input**: 160x160x3 RGB image
- **Output**: 128-dimensional embedding vector
- **Size**: ~3.4MB
- **Format**: TensorFlow Lite (.tflite)
- **Architecture**: MobileNet-based FaceNet

---

## 🔐 Permissions

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS (ios/Runner/Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to capture photos for face recognition</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select images for face recognition</string>
```

---

## 🎯 How to Use

1. **Launch the app**
2. **Select first image** - Tap on the first image placeholder to choose from gallery
3. **Select second image** - Tap on the second image placeholder to choose from gallery  
4. **Compare faces** - Tap "Compare Faces" button to start processing
5. **View results** - See similarity percentage and match verdict

### Example Results
- **90%+ similarity**: "Very Similar" (Likely same person)
- **70-89% similarity**: "Similar" (Possibly same person)
- **50-69% similarity**: "Somewhat Similar" (Different people with similar features)
- **<50% similarity**: "Not Similar" (Different people)

---

## 🤖 Why These Tools?

| Tool              | Purpose                              | Why                                               |
|------------------|--------------------------------------|---------------------------------------------------|
| **Google ML Kit**     | Detect faces in the input image      | It's fast, offline, and easy to integrate with Flutter |
| **FaceNet TFLite**    | Generate vector representation of face | Embeddings allow efficient face comparison         |
| **Cosine Similarity** | Compare two embeddings               | Standard technique for face verification           |
| **Flutter**           | App UI and logic                     | Cross-platform, expressive UI, ML integration      |

---

## 📸 UI Overview

- Displays two user-selected images and their cropped face previews.
- On clicking **"Compare Faces"**, the app shows:
  - Similarity Score (e.g., `83.8%`)
  - Verdict (e.g., `Very Similar`)
  - Optional: 128D face embeddings printed for transparency/debugging.

---

## 📂 File Structure

```
lib/
├── main.dart
├── mianScreen.dart
├── services/
│   ├── face_crop_service.dart         # Handles cropping face regions from images
│   ├── facenet_service.dart           # Loads and runs FaceNet TFLite model
│   ├── image_picker_service.dart      # Handles image selection from device
│   └── mlkit_service.dart             # Detects faces using Google ML Kit
├── widgets/
│   ├── build_cropped_images.dart      # Widget to show cropped face images
│   ├── comparebuttons.dart            # Compare Faces button and logic
│   ├── embeddings.dart                # Shows raw embedding vectors
│   ├── modelstatus.dart               # Shows model load status
│   ├── result_Build.dart              # Displays similarity result
│   └── statusMessage.dart             # Shows status messages on screen
assets/
└── models/
    └── facenet_mobilenet.tflite       # Pre-trained FaceNet model
```

---

## ⚙️ Technical Details

### Face Detection Pipeline
1. **Image Selection** → User picks images from gallery
2. **Face Detection** → ML Kit detects face boundaries
3. **Face Cropping** → Extract face region (160x160)
4. **Preprocessing** → Normalize pixel values
5. **Embedding Generation** → FaceNet model creates 128D vector
6. **Similarity Calculation** → Cosine similarity between embeddings

### Performance
- **Face Detection**: ~100-300ms per image
- **Embedding Generation**: ~50-150ms per face
- **Memory Usage**: ~50MB during processing
- **Model Size**: 3.4MB
- **Accuracy**: High accuracy for well-lit, frontal face images

---

## 📱 Screenshots

### App Flow & Results Demonstration

| Screen | Image | Description |
|--------|-------|-------------|
| **Home Screen** | ![Home Screen](![Home Ui](https://github.com/user-attachments/assets/77627155-5fb8-4f4e-8769-69f52f7e5151) | Initial app interface where users can select two images for comparison. Clean UI with placeholder areas for image selection. |
| **Face Selection & Processing** | ![Face Selection](https://github.com/user-attachments/assets/1f7f5198-e7e1-4446-9cf3-bfa280c025d7) | Shows selected images with detected and cropped face regions. The app automatically detects faces using ML Kit and prepares them for comparison. |
| **High Similarity Result** | ![Results - High Match](https://github.com/user-attachments/assets/0456fc73-f644-4121-b1ec-652c7c675af9) | Demonstrates a **high similarity score** between two face images. Shows percentage match and "Very Similar" verdict, indicating likely same person. |

### Result Analysis

**Screenshot Analysis:**
- **Good Lighting**: All images show clear, well-lit faces which improve detection accuracy
- **Frontal Poses**: Faces are positioned frontally, optimal for the FaceNet model
- **High Similarity Score**: The result screen shows a high percentage match, indicating the faces are likely from the same person
- **Clean Detection**: Face cropping appears accurate with proper boundary detection

**Why High Similarity:**
- Similar facial structure and features
- Consistent lighting conditions
- Clear face visibility without obstructions
- Proper image quality for embedding generation

---

## 🔧 Troubleshooting

### Common Issues

**Model not loading?**
- Ensure `facenet_mobilenet.tflite` is in the correct `assets/models/` folder
- Check `pubspec.yaml` includes the model in assets section
- Clean and rebuild the project: `flutter clean && flutter pub get`

**Face not detected?**
- Ensure good lighting and clear face visibility
- Try images with faces facing forward
- Check image resolution (minimum 160x160 recommended)
- Avoid heavily shadowed or blurry images

**Low similarity scores?**
- Ensure both images contain clear, well-lit faces
- Try images with similar angles and expressions
- Check if faces are properly cropped and centered
- Avoid images with extreme expressions or accessories

**App crashes on image selection?**
- Check permissions are granted for camera and storage
- Ensure device has sufficient memory
- Try with smaller image files

---

## 🔮 Future Possibilities

- Compare faces with a pre-defined dataset (face library)
- Real-time recognition with camera feed
- Face-based app login or attendance system
- Save and export embedding profiles
- Multiple face detection and comparison
- Integration with cloud-based face recognition APIs
- Batch processing of multiple images

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart style guidelines
- Add comments for complex logic
- Test on both Android and iOS if possible
- Update documentation for new features

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Google ML Kit** for providing excellent face detection capabilities
- **FaceNet** research paper and model architecture
- **Flutter team** for the amazing cross-platform framework
- **TensorFlow Lite** for efficient on-device ML inference
- **Open source community** for various packages and tools

---

## 👨‍💻 Author

**Rudrankur P. Indurkar**  
📧 rudraindurkar9@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/rudrankurindurkar)  
🐙 [GitHub](https://github.com/ShallowAwe)

---

## 📊 Project Stats

![GitHub stars](https://img.shields.io/github/stars/ShallowAwe/Facial_Recognition?style=social)
![GitHub forks](https://img.shields.io/github/forks/ShallowAwe/Facial_Recognition?style=social)
![GitHub issues](https://img.shields.io/github/issues/ShallowAwe/Facial_Recognition)
![GitHub license](https://img.shields.io/github/license/ShallowAwe/Facial_Recognition)

---

*If you find this project helpful, please consider giving it a ⭐ on GitHub!*
