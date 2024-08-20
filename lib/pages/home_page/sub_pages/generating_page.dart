import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:screenshot/screenshot.dart';

class QRGeneratingPage extends StatefulWidget {
  const QRGeneratingPage({super.key});

  @override
  State<QRGeneratingPage> createState() => _QRGeneratingPageState();
}

class _QRGeneratingPageState extends State<QRGeneratingPage> {
  final TextEditingController qrInputController = TextEditingController();
  String? qrData;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void dispose() {
    qrInputController.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted
      // print("Permission granted");
    } else if (status.isDenied) {
      // Handle permission denied
      // print("Permission denied");
      // openAppSettings();
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, redirect to settings
      // print("Permission permanently denied");
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    qrData = qrInputController.text;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: qrData == null || qrData!.isEmpty ? 200 : 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                child: Center(
                  child: _buildTextField(),
                ),
              ),
              SizedBox(
                height: qrData == null || qrData!.isEmpty ? 0 : 30,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // For snack bar
                      FutureBuilder(
                        future: _qrImageView(qrData),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show a loading indicator while waiting
                          } else if (snapshot.hasError) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  // "Error: ${snapshot.error}
                                  content: Text(
                                    "No QR code data provided.",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  duration: Duration(seconds: 1),
                                ), //
                              );
                            });
                            return const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 100,
                            ); // Return a fallback widget
                          } else {
                            return snapshot
                                .data!; // Display the QR code when done
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              qrData == null || qrData!.isEmpty
                  ? const SizedBox()
                  : _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Text input field for provide data to create QR code
  Widget _buildTextField() {
    return TextField(
      maxLines: 2,
      autofocus:
          true, //  text field will focus itself if nothing else is already focused.
      onTap: () {
        setState(() {
          qrInputController.text = "";
        });
      },
      controller: qrInputController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              qrData = qrInputController.text;
              print(qrData);
              FocusScope.of(context).unfocus();
            });
          },
          icon: const Icon(
            Icons.done_outlined,
            size: 30,
          ),
        ),
        hintText: "Enter text or URL to generate QR code",
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.w100,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppColors.kMainColor,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: AppColors.kBlackColor.withOpacity(0.3),
            width: 2
          )
        )
      ),

      // when tap the tik icon on keyboard or enter of keyboard
      onSubmitted: (value) {
        setState(() {
          qrData = value;
        });
      },
    );
  }

  // QR code generator
  Future<Widget?> _qrImageView(String? qrData) async {
    if (qrData == null || qrData.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Text(
            "No data provided",
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.kWhiteColor.withOpacity(0.7)
                  : AppColors.kSubtitleColor.withOpacity(0.3),
            ),
          ),
        ],
      );
    } else {
      return Screenshot(
        controller: screenshotController,
        child: Column(
          children: <Widget>[
            QrImageView(
              data: qrData,
              backgroundColor: Colors.white,
              //embeddedImage: const ExactAssetImage("assets/images/flutter.png"),
              version: QrVersions.auto,
              size: MediaQuery.of(context).size.width * 0.8,
            ),
          ],
        ),
      );
    }
  }

  // Save button
  Widget _saveButton() {
    return GestureDetector(
      onTap: () async {
        try {
          await _requestPermission();
          // check unnecessary imports
          await Future.delayed(const Duration(milliseconds: 300));
          final Uint8List? image = await screenshotController.capture();
          if (image != null) {
            final result =
                await ImageGallerySaver.saveImage(image, name: "MyQrImage");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 3,
                backgroundColor: AppColors.kMainColor,
                duration: const Duration(seconds: 1),
                content: Text(
                  result['isSuccess']
                      ? "Image Saved Successfully."
                      : "Failed to Save Image.",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
        } catch (err) {
          // print('Error saving image: $err');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1),
              content: Text(
                "Failed to capture image.",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 20,
        ),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.kMainColor,
              AppColors.kMainColor.withOpacity(0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          ),
          // color: AppColors.kMainColor,
          borderRadius: BorderRadius.circular(100),
          //color: AppColors.kMainColor,
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Save",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.kWhiteColor,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.save_alt,
                size: 30,
                color: AppColors.kWhiteColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
