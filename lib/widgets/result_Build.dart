  import 'package:flutter/material.dart';

Widget buildSimilarityResult(
  double? similarity) {
  Color getSimilarityColor(double similarity) {
    if (similarity > 0.8) return Colors.green;
    if (similarity > 0.6) return Colors.orange;
    if (similarity > 0.4) return Colors.amber;
    return Colors.red;
  }
   String getSimilarityDescription(double similarity) {
    if (similarity > 0.8) return "Very Similar";
    if (similarity > 0.6) return "Similar";
    if (similarity > 0.4) return "Somewhat Similar";
    return "Different";
  }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: getSimilarityColor(similarity!).withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: getSimilarityColor(similarity), width: 2),
      ),
      child: Column(
        children: [
          Text("Similarity Score", style: TextStyle(fontSize: 16, color: getSimilarityColor(similarity), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("${(similarity * 100).toStringAsFixed(1)}%", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: getSimilarityColor(similarity))),
          const SizedBox(height: 8),
          Text(getSimilarityDescription(similarity), style: TextStyle(fontSize: 18, color: getSimilarityColor(similarity), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }