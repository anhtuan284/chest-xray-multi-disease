import 'package:flutter/material.dart';

class PredictionScreen extends StatelessWidget {
  const PredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predict X-Ray'),
      ),
      body: const Center(
        child: Text('Upload X-Ray Image'),
      ),
    );
  }
}
