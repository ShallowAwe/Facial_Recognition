import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceNetService {
  Interpreter? _interpreter;

  FaceNetService();

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/mobilefacenet.tflite');
      
    
      print("Input shape: ${_interpreter!.getInputTensor(0).shape}");
      print("Output shape: ${_interpreter!.getOutputTensor(0).shape}");
      print("Model loaded successfully");
    } catch (e) {
      print("Failed to load model: $e");
    }
  }

  bool get isLoaded => _interpreter != null;

  Future<List<double>> getEmbedding(File imageFile) async {
    if (_interpreter == null) {
      throw Exception("Interpreter not initialized");
    }

    final bytes = await imageFile.readAsBytes();

    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception("Unable to decode image");
    }


    image = img.copyResize(image, width: 112, height: 112);

    var input = List.generate(1, (_) => 
      List.generate(112, (_) => 
        List.generate(112, (_) => 
          List.filled(3, 0.0))));

    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        final pixel = image.getPixel(x, y);
        input[0][y][x][0] = ((pixel.r - 128) / 128).toDouble();
        input[0][y][x][1] = ((pixel.g - 128) / 128).toDouble();
        input[0][y][x][2] = ((pixel.b - 128) / 128).toDouble();
      }
    }

   
    var output = List.filled(192, 0.0).reshape([1, 192]);
    
    try {
      _interpreter!.run(input, output);
    } catch (e) {
      print("Error with 112x112 input and 192 output: $e");
      
     
      image = img.copyResize(img.decodeImage(bytes)!, width: 160, height: 160);
      
      input = List.generate(1, (_) => 
        List.generate(160, (_) => 
          List.generate(160, (_) => 
            List.filled(3, 0.0))));

      for (int y = 0; y < 160; y++) {
        for (int x = 0; x < 160; x++) {
          final pixel = image.getPixel(x, y);
          input[0][y][x][0] = ((pixel.r - 128) / 128).toDouble();
          input[0][y][x][1] = ((pixel.g - 128) / 128).toDouble();
          input[0][y][x][2] = ((pixel.b - 128) / 128).toDouble();
        }
      }

      output = List.filled(512, 0.0).reshape([1, 512]);
      _interpreter!.run(input, output);
    }

    List<double> embedding = List.from(output[0]);
    double norm = sqrt(embedding.fold(0, (p, c) => p + c * c));
    List<double> normalizedEmbedding = embedding.map((e) => e / norm).toList();

    return normalizedEmbedding;
  }
}