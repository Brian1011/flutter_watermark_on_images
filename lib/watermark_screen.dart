import 'dart:io';

import 'package:flutter/material.dart';

class WatermarkScreen extends StatefulWidget {
  const WatermarkScreen({Key? key}) : super(key: key);

  @override
  State<WatermarkScreen> createState() => _WatermarkScreenState();
}

class _WatermarkScreenState extends State<WatermarkScreen> {
  late File assetFile;
  File? watermarkedImage;

  addWaterMarkToPhoto() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add watermark to images")),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/rectangle_image.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: addWaterMarkToPhoto,
                child: const Text("Add water mark"),
              ),
              const SizedBox(height: 20),
              watermarkedImage != null
                  ? Image.file(
                      watermarkedImage!,
                      height: 200,
                      width: 200,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ));
  }
}
