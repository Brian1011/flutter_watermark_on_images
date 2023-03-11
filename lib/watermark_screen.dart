import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as ui;
import 'package:path_provider/path_provider.dart';

class WatermarkScreen extends StatefulWidget {
  const WatermarkScreen({Key? key}) : super(key: key);

  @override
  State<WatermarkScreen> createState() => _WatermarkScreenState();
}

class _WatermarkScreenState extends State<WatermarkScreen> {
  String assetFilePath = 'assets/rectangle_image.png';

  Future<File> getFileFromAsset() async {
    final byteData = await rootBundle.load(assetFilePath);
    final file = File('${(await getTemporaryDirectory()).path}/image.png');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  File? watermarkedImage;

  addWaterMarkToPhoto() async {
    File assetFile = await getFileFromAsset();
    // decode image and return new image
    ui.Image? originalImage = ui.decodeImage(assetFile.readAsBytesSync());

    // watermark text
    String waterMarkText = "flutter is awesome";

    // add watermark to image
    ui.drawString(originalImage!, ui.arial_24, 10, (originalImage.height - 210),
        waterMarkText);

    // create temporary directory on storage
    var tempDir = await getTemporaryDirectory();

    // generate random name
    Random _random = Random();
    String randomFileName = _random.nextInt(10000).toString();

    // store new image on filename
    File(tempDir.path + '/$randomFileName.png')
        .writeAsBytesSync(ui.encodePng(originalImage));

    // set watermarked image from image path
    setState(() {
      watermarkedImage = File(tempDir.path + '/$randomFileName.png');
    });
  }

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
                assetFilePath,
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
