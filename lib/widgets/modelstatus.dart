import 'package:flutter/material.dart';

Widget buildModelStatus(bool isModelLoaded) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isModelLoaded ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isModelLoaded ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isModelLoaded ? Icons.check_circle : Icons.hourglass_empty,
            color: isModelLoaded ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(
            isModelLoaded ? "Model Ready" : "Loading Model...",
            style: TextStyle(
              color: isModelLoaded ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }