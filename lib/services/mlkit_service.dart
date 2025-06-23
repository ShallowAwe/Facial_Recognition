import 'dart:io';
import 'dart:math';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

class MLKitService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  Future<List<Face>> detectFaces(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faces = await _faceDetector.processImage(inputImage);
    return faces;
  }

  Future<img.Image?> alignFace(File imageFile, Face face) async {
    final rawImage = await decodeImage(imageFile);
    if (rawImage == null) return null;

    final leftEye = face.landmarks[FaceLandmarkType.leftEye]?.position;
    final rightEye = face.landmarks[FaceLandmarkType.rightEye]?.position;

    if (leftEye == null || rightEye == null) return rawImage;

    final dx = rightEye.x - leftEye.x;
    final dy = rightEye.y - leftEye.y;
    final angle = atan2(dy, dx);

    final rotatedImage = img.copyRotate(rawImage,angle: -angle * 180 / pi);
    return rotatedImage;
  }

  Future<img.Image?> decodeImage(File file) async {
    final bytes = await file.readAsBytes();
    return img.decodeImage(bytes);
  }

  void dispose() {
    _faceDetector.close();
  }
}
