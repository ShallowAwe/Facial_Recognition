 import 'package:flutter/material.dart';

Widget buildEmbeddings(List<double>? emb1, List<double>? emb2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Embedding 1:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(emb1!.map((e) => e.toStringAsFixed(4)).join(', ')),
        const SizedBox(height: 10),
        const Text("Embedding 2:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(emb2!.map((e) => e.toStringAsFixed(4)).join(', ')),
      ],
    );
  }