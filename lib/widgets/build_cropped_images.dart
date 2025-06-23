 import 'dart:io';

import 'package:flutter/material.dart';

Widget buildCroppedImages(File? croppedFace1,File? croppedFace2) {
    if (croppedFace1 == null || croppedFace2 == null) return Container();
    return Row(
      children: [
        Expanded(child: _croppedImagePreview(croppedFace1, "Cropped Face 1")),
        const SizedBox(width: 20),
        Expanded(child: _croppedImagePreview(croppedFace2, "Cropped Face 2")),
      ],
    );
  }

  
   Widget _croppedImagePreview(File croppedFile, String label) {
    return Column(
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(croppedFile, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 10),
        Text(label),
      ],
    );
  }