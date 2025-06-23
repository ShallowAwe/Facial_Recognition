  import 'package:flutter/material.dart';

Widget buildStatusMessage(String statusMessage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusMessage,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
      ),
    );
  }