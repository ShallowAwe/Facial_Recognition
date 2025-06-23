import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_recognition/services/facenet_service.dart';
import 'package:image_recognition/services/mlkit_service.dart';
import 'package:image_recognition/services/face_crop_service.dart';

import 'package:image_recognition/widgets/build_cropped_images.dart';
import 'package:image_recognition/widgets/comparebuttons.dart';
import 'package:image_recognition/widgets/embeddings.dart';
import 'package:image_recognition/widgets/modelstatus.dart';
import 'package:image_recognition/widgets/result_Build.dart';
import 'package:image_recognition/widgets/statusMessage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image1;
  File? _image2;
  File? _croppedFace1;
  File? _croppedFace2;

  final FaceNetService _faceNetService = FaceNetService();
  final MLKitService _mlKitService = MLKitService();
  final FaceCropService _faceCropService = FaceCropService();

  double? _similarity;
  List<double>? _emb1;
  List<double>? _emb2;

  bool _isModelLoaded = false;
  bool _isProcessing = false;
  String _statusMessage = "Loading model...";

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    setState(() {
      _statusMessage = "Loading face recognition model...";
    });

    await _faceNetService.loadModel();

    setState(() {
      _isModelLoaded = _faceNetService.isLoaded;
      _statusMessage = _isModelLoaded ? "Model loaded successfully!" : "Failed to load model";
    });

    if (_isModelLoaded) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _statusMessage = "";
          });
        }
      });
    }
  }

  Future<void> _pickImage(int imageNumber) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          _image1 = File(pickedFile.path);
        } else {
          _image2 = File(pickedFile.path);
        }
        _similarity = null;
        _croppedFace1 = null;
        _croppedFace2 = null;
        _emb1 = null;
        _emb2 = null;
      });
    }
  }

  Future<void> _compareFaces() async {
    if (!_isModelLoaded) {
      _showMessage("Model is still loading...", isError: true);
      return;
    }

    if (_image1 == null || _image2 == null) {
      _showMessage("Please select both images.", isError: true);
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = "Detecting faces...";
      _similarity = null;
      _croppedFace1 = null;
      _croppedFace2 = null;
    });

    try {
      final faces1 = await _mlKitService.detectFaces(_image1!);
      if (faces1.isEmpty) {
        _showMessage("No face detected in Image 1", isError: true);
        return;
      }
      final cropped1 = await _faceCropService.cropFace(_image1!, faces1[0]);
      if (cropped1 == null) {
        _showMessage("Failed to crop face from Image 1", isError: true);
        return;
      }

      final faces2 = await _mlKitService.detectFaces(_image2!);
      if (faces2.isEmpty) {
        _showMessage("No face detected in Image 2", isError: true);
        return;
      }
      final cropped2 = await _faceCropService.cropFace(_image2!, faces2[0]);
      if (cropped2 == null) {
        _showMessage("Failed to crop face from Image 2", isError: true);
        return;
      }

      setState(() {
        _croppedFace1 = cropped1;
        _croppedFace2 = cropped2;
        _statusMessage = "Generating embeddings...";
      });

      final emb1 = await _faceNetService.getEmbedding(cropped1);
      final emb2 = await _faceNetService.getEmbedding(cropped2);

      final sim = _cosineSimilarity(emb1, emb2);

      setState(() {
        _emb1 = emb1;
        _emb2 = emb2;
        _similarity = sim;
        _statusMessage = "Comparison complete!";
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _statusMessage = "");
        }
      });
    } catch (e) {
      _showMessage("Error during comparison: $e", isError: true);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    setState(() {
      _statusMessage = message;
      _isProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  double _cosineSimilarity(List<double> emb1, List<double> emb2) {
    double dot = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < emb1.length; i++) {
      dot += emb1[i] * emb2[i];
      normA += emb1[i] * emb1[i];
      normB += emb2[i] * emb2[i];
    }
    return dot / (sqrt(normA) * sqrt(normB));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Recognition'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildModelStatus(_isModelLoaded),
            const SizedBox(height: 20),
            _buildImageSelectionRow(),
            const SizedBox(height: 20),
            buildCroppedImages(_croppedFace1, _croppedFace2),
            const SizedBox(height: 20),
            buildCompareButton(_isModelLoaded, _isProcessing,() {
              _compareFaces();
            },),
            const SizedBox(height: 20),
            if (_statusMessage.isNotEmpty) buildStatusMessage(_statusMessage),
            const SizedBox(height: 20),
            if (_similarity != null) buildSimilarityResult(_similarity),
            const SizedBox(height: 20),
            if (_emb1 != null && _emb2 != null) buildEmbeddings(_emb1, _emb2),
          ],
        ),
      ),
    );
  }

 
  Widget _buildImageSelectionRow() {
    return Row(
      children: [
        Expanded(child: _imagePreview(_image1, "Select Image 1", () => _pickImage(1))),
        const SizedBox(width: 20),
        Expanded(child: _imagePreview(_image2, "Select Image 2", () => _pickImage(2))),
      ],
    );
  }

  Widget _imagePreview(File? image, String label, VoidCallback onPressed) {
    return Column(
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: image != null 
                ? Image.file(image, fit: BoxFit.cover) 
                : const Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.black87,
          ),
          child: Text(label),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mlKitService.dispose();
    super.dispose();
  }
}
