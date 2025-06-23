
# 👤 Face Recognition Flutter App

This Flutter app performs **on-device face recognition** using a pre-trained **FaceNet model** (`facenet_mobilenet.tflite`). It lets users select two face images, detects faces using **Google ML Kit**, generates **embeddings**, and compares them to calculate how similar the faces are.

---

## 🔍 What It Does

- **Face Selection**: Users select two images from the gallery.
- **Face Detection**: Google ML Kit is used to detect and crop the main faces from each image.
- **Embedding Generation**: A lightweight `.tflite` version of the FaceNet model generates 128-dimensional embeddings for each detected face.
- **Similarity Calculation**: The app calculates **cosine similarity** between the two embeddings and gives a percentage score with a simple label like “Very Similar”.

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
```

---

## 🔮 Future Possibilities

- Compare faces with a pre-defined dataset (face library)
- Real-time recognition with camera feed
- Face-based app login or attendance system
- Save and export embedding profiles

---

## 👨‍💻 Author

**Rudrankur P. Indurkar**  
📧 rudraindurkar9@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/rudrankurindurkar)

---
