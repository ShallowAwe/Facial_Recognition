import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

class FaceCropService {
  Future<File?> cropFace(File imageFile, Face face) async {
    final image = await decodeImage(imageFile);
    if (image == null) return null;

    final rect = face.boundingBox;

    final x = rect.left.toInt().clamp(0, image.width);
    final y = rect.top.toInt().clamp(0, image.height);
    final w = rect.width.toInt().clamp(0, image.width - x);
    final h = rect.height.toInt().clamp(0, image.height - y);

    final faceCrop = img.copyCrop(image, x:x, y:y, width: w, height: h);

    final tempPath = "${imageFile.parent.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final croppedFile = File(tempPath)..writeAsBytesSync(img.encodeJpg(faceCrop, quality: 100));
    return croppedFile;
  }

  Future<img.Image?> decodeImage(File file) async {
    final bytes = await file.readAsBytes();
    return img.decodeImage(bytes);
  }
}
