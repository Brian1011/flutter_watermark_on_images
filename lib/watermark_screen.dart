import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
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
  File? watermarkedImage;
  bool loading = false;

  setLoadingStatus(bool value) {
    setState(() {
      loading = value;
    });
  }

  Future<File> getFileFromAsset() async {
    final byteData = await rootBundle.load(assetFilePath);
    final file = File('${(await getTemporaryDirectory()).path}/image.png');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  addWaterMarkToPhoto() async {
    setLoadingStatus(true);

    // get the image file
    File assetFile = await getFileFromAsset();

    // decode image and return new image
    ui.Image? originalImage = ui.decodeImage(assetFile.readAsBytesSync());

    // watermark text
    String waterMarkText = "flutter is awesome";

    // add watermark to image and specify the position
    ui.drawString(originalImage!, ui.arial_24, 10, (originalImage.height - 150),
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
    watermarkedImage = File(tempDir.path + '/$randomFileName.png');

    // delay for an extra second
    await Future.delayed(const Duration(seconds: 1));
    setLoadingStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        home: CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text("Add watermark to images"),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: loading
                  ? const Center(child: CupertinoActivityIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Before watermark"),
                        const SizedBox(height: 10),
                        Image.asset(
                          assetFilePath,
                          height: 200,
                          width: 200,
                        ),
                        const SizedBox(height: 20),
                        CupertinoButton.filled(
                            child: const Text("Add watermark"),
                            onPressed: () {
                              addWaterMarkToPhoto();
                            }),
                        const SizedBox(height: 20),
                        watermarkedImage != null
                            ? Column(
                                children: [
                                  const Divider(),
                                  const Text("With watermark"),
                                  const SizedBox(height: 10),
                                  Image.file(
                                    watermarkedImage!,
                                    height: 200,
                                    width: 200,
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
            )));
  }
}
