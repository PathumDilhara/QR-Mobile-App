import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_mobile_app/admob_helper/admob_helper.dart';
import 'package:qr_mobile_app/model/generated_qr_model.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:screenshot/screenshot.dart';

import '../../provider/qr_history_provider.dart';
import '../../provider/settings_provider.dart';

class QRGeneratingPage extends StatefulWidget {
  const QRGeneratingPage({super.key});

  @override
  State<QRGeneratingPage> createState() => _QRGeneratingPageState();
}

class _QRGeneratingPageState extends State<QRGeneratingPage> {
  final TextEditingController qrInputController = TextEditingController();
  String? qrData;
  final ScreenshotController screenshotController = ScreenshotController();

  bool isCreated = false;

  AdmobHelper admobHelper = new AdmobHelper();

  @override
  void dispose() {
    qrInputController.dispose();
    super.dispose();
  }

  // Function to check and request permission
  Future<bool> _checkAndRequestPermission() async {
    // final status = await Permission.storage.status;
    bool permissionGranted =
        await Permission.storage.isGranted || await Permission.photos.isGranted;

    if (!permissionGranted) {
      permissionGranted = await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted;
      // Request permission
      // final result = await Permission.storage.request();
      // return result.isGranted;
      // return permissionGranted;
    }

    // return true; // Permission already granted
    return permissionGranted;
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
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 20.0,
                right: 20,
                top: 30,
                bottom: qrData!.isEmpty ? 80 : 150),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: qrData == null || qrData!.isEmpty ? 200 : 60,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: double.infinity,
                    child: Center(
                      child: _buildTextField(),
                    ),
                  ),
                  isCreated ? const SizedBox() : _generateButton(),
                  SizedBox(
                    height: qrData == null || qrData!.isEmpty ? 0 : 30,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    child: FutureBuilder(
                      future: _qrImageView(qrData),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: AppColors.kMainPurpleColor,
                          ); // Show a loading indicator while waiting
                        } else if (snapshot.hasError) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.redAccent,
                                // "Error: ${snapshot.error}
                                content: Text(
                                  "No QR code data provided.",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
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
                    ),
                  ),
                  qrData == null || qrData!.isEmpty
                      ? const SizedBox()
                      : _saveButton(),
                ],
              ),
            ),
          ),
          // // Advertisement
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: SizedBox(
          //     height: 50,
          //     // color: Colors.red,
          //     child: AdWidget(
          //       ad: AdmobHelper.getBannerAd()..load(),
          //       key: UniqueKey(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Text input field for provide data to create QR code
  Widget _buildTextField() {
    // Don't create a new instance of QRHistoryProvider inside the onPressed callback,
    // instead of using the one provided by the Provider.
    // get existing instance
    // final qrHistoryProvider = Provider.of<QRHistoryProvider>(context);
    // final settingsProvider = Provider.of<SettingsProvider>(context);

    return TextField(
      maxLines: 2,
      autofocus:
          true, //  text field will focus itself if nothing else is already focused.
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onTapAlwaysCalled: true,
      style: const TextStyle(color: AppColors.kBlackColor),
      onChanged: (value) {
        if (value.isEmpty) {
          setState(() {
            qrInputController.text = "";
            isCreated = false;
          });
        }
      },
      controller: qrInputController,
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.kWhiteColor,
          hintText: "Enter text or URL to generate QR code",
          hintStyle: TextStyle(
            color: AppColors.kGreyColor,
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: AppColors.kGreyColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: AppColors.kMainPurpleColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  color: AppColors.kBlackColor.withOpacity(0.3), width: 2))),

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
              fontSize: 17,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.kWhiteColor.withOpacity(0.7)
                  : AppColors.kGreyColor,
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
              size: MediaQuery.of(context).size.height * 0.4,
            ),
          ],
        ),
      );
    }
  }

  // Save button
  Widget _saveButton() {
    DateTime datetime = DateTime.now();
    // String formattedDateTime =
    //     "${datetime.toLocal().toString().split(' ')[0].replaceAll('-', '')}_${datetime.toLocal().toString().split(' ')[1].split('.')[0].replaceAll(':', '')}";
    String formattedDateTime = DateFormat('yyyyMMdd_HHmmss').format(datetime);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(3),
          overlayColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.1)),
          minimumSize: const WidgetStatePropertyAll(
            Size(double.infinity, 50),
          ),
          backgroundColor:
              const WidgetStatePropertyAll(AppColors.kMainPurpleColor),
        ),
        onPressed: () async {
          // interstitial add will show when saving qr code
          admobHelper.loadInterstitialAds();

          bool permissionGranted = await _checkAndRequestPermission();
          if (permissionGranted) {
            // await _requestPermission();
            try {
              // check unnecessary imports
              await Future.delayed(const Duration(milliseconds: 300));
              final Uint8List? image = await screenshotController.capture();
              if (image != null) {
                // Save image to gallery
                final result = await ImageGallerySaverPlus.saveImage(image,
                    name: "QR_$formattedDateTime");

                // Show success or failure message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    elevation: 3,
                    backgroundColor: AppColors.kSnackBarBgColor,
                    duration: const Duration(seconds: 1),
                    content: Text(
                      result['isSuccess']
                          ? "Image Saved Successfully."
                          : "Failed to Save Image.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.7)
                            : Colors.white,
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
                    "Failed to save image.",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }
          } else {
            bool isPermanentlyDenied =
                await Permission.storage.status.isPermanentlyDenied;
            if (isPermanentlyDenied) {
              openAppSettings();
            } else {
              await Permission.storage.request();
            }
            // Permission was denied
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                duration: Duration(seconds: 1),
                content: Text(
                  "Permission denied. Unable to save image.",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }
        },
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

  Widget _generateButton() {
    final qrHistoryProvider = Provider.of<QRHistoryProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(3),
          overlayColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.1)),
          minimumSize: const WidgetStatePropertyAll(
            Size(double.infinity, 50),
          ),
          backgroundColor:
              const WidgetStatePropertyAll(AppColors.kMainPurpleColor),
        ),
        onPressed: () async {
          isCreated = true;

          // interstitial add will create when generate qr code
          admobHelper.createInterstitialAds();

          // instance of GeneratedQRModel
          GeneratedQRModel generatedQRModel = GeneratedQRModel(
            title: qrInputController.text,
            date: DateTime.now(),
          );

          FocusScope.of(context).unfocus();
          if (settingsProvider.isHistorySaving &&
              qrInputController.text.isNotEmpty) {
            await qrHistoryProvider.storeGeneratedQR(generatedQRModel);
          }
        },
        child: const Text(
          "Generate",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.kWhiteColor,
          ),
        ),
      ),
    );
  }
}
