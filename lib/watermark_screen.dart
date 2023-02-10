import 'package:flutter/material.dart';

class WatermarkScreen extends StatefulWidget {
  const WatermarkScreen({Key? key}) : super(key: key);

  @override
  State<WatermarkScreen> createState() => _WatermarkScreenState();
}

class _WatermarkScreenState extends State<WatermarkScreen> {
  takePhoto() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add watermark to images")),
      body: Container(
        child: const Center(
          child: IconButton(
            icon: Icon(Icons.camera_alt_outlined, size: 40),
            onPressed: null,
          ),
        ),
      ),
    );
  }
}
