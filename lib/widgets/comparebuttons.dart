 import 'package:flutter/material.dart';

Widget buildCompareButton(bool isModelLoaded, bool isProcessing, Function() compareFaces) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: (isModelLoaded && !isProcessing) ? compareFaces : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isProcessing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Text("Processing..."),
                ],
              )
            : Text(isModelLoaded ? "Compare Faces" : "Loading Model..."),
      ),
    );
  }
