import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_mobile_app/model/scanned_qr_model.dart';
import 'package:qr_mobile_app/provider/qr_history_provider.dart';
import 'package:qr_mobile_app/provider/settings_provider.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanningPage extends StatefulWidget {
  const QRScanningPage({super.key});

  @override
  State<QRScanningPage> createState() => _QRScanningPageState();
}

class _QRScanningPageState extends State<QRScanningPage>
    with SingleTickerProviderStateMixin {

  // QR coding
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? qrViewController;
  Barcode? result; // Variable to save the scanned QR code data

  late QRHistoryProvider qrHistoryProvider; // Declare the provider
  late SettingsProvider settingsProvider; // Declare the provider

  // Animation controller and tween
  late AnimationController _animationController;
  late Animation<double> _animation;

  double _previousValue = 0.0;

  bool isCameraPaused = false; // State variable to track camera status

  // For image picker obj
  final ImagePicker _picker = ImagePicker();
  File? _image;

  // Camera permission granted or not
  bool _isCameraPermissionGranted = false;
  bool _isCameraPermissionPermanentlyDenied = false;

  @override
  void initState() {
    super.initState();
    // Camera permission
    _checkCameraPermission();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Makes the animation move back and forth
    // Tween the animation between 0 and 1 for the full height movement
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  Future<void> _checkCameraPermission() async {
    // Request camera permission
    PermissionStatus status = await Permission.camera.status;
    setState(() {
      _isCameraPermissionGranted = status.isGranted;
    });

    if (status.isDenied || status.isPermanentlyDenied) {
      // If permission is denied, request it
      PermissionStatus requestStatus = await Permission.camera.request();

      if (requestStatus.isDenied) {
        // Handle the case where the user denies the permission again
        _showPermissionDeniedDialog();
      } else if (requestStatus.isPermanentlyDenied) {
        setState(() {
          _isCameraPermissionPermanentlyDenied =
              requestStatus.isPermanentlyDenied;
        });
        // If the user permanently denies the permission, prompt them to go to settings
      }
      setState(() {
        _isCameraPermissionGranted = requestStatus.isGranted;
        _isCameraPermissionPermanentlyDenied = !requestStatus.isGranted;
      });
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Camera Permission Required"),
        content: const Text(
            "This app requires camera access to scan QR codes. Please grant camera permission."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkCameraPermission(); // Try to request permission again
            },
            child: const Text("Retry"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isCameraPermissionPermanentlyDenied = true;
              });
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Controllers disposing methods
  @override
  void dispose() {
    _animationController.dispose();
    qrViewController?.dispose();
    // _bannerAd.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // After a Scanned done automatically pause the camera if no need remove it
  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   qrViewController?.pauseCamera();
    // } else if (Platform.isIOS) {
    //   qrViewController?.resumeCamera();
    // }
  }

  // Method to pick image
  Future<void> _pickImage() async {
    try {
      // Add a print statement before image picker action
      print('################Opening image picker...');

      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      // Check if the pickedFile is null or valid
      if (pickedFile != null) {
        print('##############Image selected: ${pickedFile.path}');
        setState(() {
          _image = File(pickedFile.path);
        });
        // *************** Function call here
      } else {
        print('#############No image selected.');
      }
    } catch (e) {
      // If there is an error, print the error details
      print('####################Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    return Scaffold(
      body: !_isCameraPermissionGranted
          ? _customScanScreen()
          : Stack(
              children: [
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                        overlay: QrScannerOverlayShape(
                          borderColor: AppColors.kMainPurpleColor,
                          borderRadius: 10,
                          borderLength: 50,
                          borderWidth: 10,
                          cutOutSize: scanArea,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Column(
                          children: [
                            // Text("RecognizedText$_recognizedText"),
                            Text(
                              "Scan code",
                              style: AppTextStyles.appDescriptionTextStyle
                                  .copyWith(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.kWhiteColor.withOpacity(0.7)
                                    : AppColors.kBlackColor,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _pauseResumeCameraButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Scanning animation bar
                _buildScanningAnimation(scanArea),
                _flashButton(),
                _cameraControlButton(),
                _galleryButton(),
              ],
            ),
    );
  }

  // Scanning animation widget
  Widget _buildScanningAnimation(double scanArea) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        bool isGoingDown = _animation.value > _previousValue;
        _previousValue = _animation.value;

        return Positioned(
          // (scanArea - 10) * _animation.value + MediaQuery.of(context).size.height * 0.22,
          top: (scanArea - 70) * _animation.value +
              MediaQuery.of(context).size.height *
                  0.22, // Moves from top to bottom
          left: MediaQuery.of(context).size.width * 0.18,
          right: MediaQuery.of(context).size.width * 0.18,
          child: Stack(
            children: [
              // Container(
              //   height: 1, // Thickness of the scanning bar
              //   color:
              //       AppColors.kMainColor, // Purple color for the scanning bar
              // ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      AppColors.kMainPurpleColor,
                      Colors.transparent,
                    ],
                    begin: !isGoingDown
                        ? Alignment.topCenter
                        : Alignment.bottomCenter,
                    end: !isGoingDown
                        ? Alignment.bottomCenter
                        : Alignment.topCenter,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController qrViewController) {
    // When you set listen: false, you're telling the Provider.of method that
    // this widget does not need to rebuild when the QRHistoryProvider changes.
    // This is useful when you only need to access the provider to call methods
    // on it or perform some non-UI-related actions, like saving data or invoking
    // a function, but you don't need to reflect any changes from the provider in
    // the UI.
    qrHistoryProvider = Provider.of<QRHistoryProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    this.qrViewController = qrViewController;
    qrViewController.scannedDataStream.listen(
      (event) async {
        // what we want to do
        setState(() {
          result = event;
        });

        try {
          if (result != null) {
            ScannedQrModel scannedQRModel = ScannedQrModel(
              title: result!.code.toString(),
              date: DateTime.now(),
            );

            // Pause camera, animation and open a bottom sheet
            qrViewController.pauseCamera();
            _animationController.stop();
            _openBottomSheet(result!.code.toString());
            if (settingsProvider.isHistorySaving) {
              await qrHistoryProvider.storeScnQR(scannedQRModel);
            }
          }
        } catch (err) {
          print(err.toString());
        }
      },
    );
  }

  Widget _pauseResumeCameraButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Buttons for camera control
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(60, 60),
              padding: const EdgeInsets.all(10),
              overlayColor: AppColors.kMainPurpleColor.withOpacity(0.3)),
          onPressed: () async {
            if (isCameraPaused) {
              await qrViewController!.resumeCamera();
              _animationController.repeat(reverse: true);
            } else {
              await qrViewController!.pauseCamera();
              _animationController.stop();
            }
            setState(() {
              isCameraPaused = !isCameraPaused;
            });
          },
          child: Center(
            child: Icon(
              isCameraPaused ? Icons.play_arrow_outlined : Icons.pause,
              size: 30,
              color: AppColors.kMainPurpleColor,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Widget _flashButton() {
    return Positioned(
      right: 20,
      top: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        style: const ButtonStyle(
          // minimumSize: WidgetStatePropertyAll(),
          backgroundColor: WidgetStateColor.transparent,
        ),
        onPressed: () async {
          await qrViewController!.toggleFlash();
          setState(() {});
        },
        child: FutureBuilder(
          future: qrViewController?.getFlashStatus(),
          builder: (context, snapshot) {
            final IconData flash =
                snapshot.data == false || snapshot.data == null
                    ? Icons.flash_off_outlined
                    : Icons.flash_on_outlined;
            return Icon(
              flash,
              size: 24,
              color: snapshot.data == false || snapshot.data == null
                  ? AppColors.kMainPurpleColor
                  : AppColors.kWhiteColor,
            );
          },
        ),
      ),
    );
  }

  Widget _cameraControlButton() {
    return Positioned(
      right: 20,
      bottom: 260,
      child: ElevatedButton(
        style: const ButtonStyle(backgroundColor: WidgetStateColor.transparent),
        onPressed: () async {
          await qrViewController!.flipCamera();
          setState(() {});
        },
        child: FutureBuilder(
          future: qrViewController?.getCameraInfo(),
          builder: (context, snapshot) {
            return Icon(
              Icons.flip_camera_ios_outlined,
              size: 24,
              color: snapshot.data == CameraFacing.back || snapshot.data == null
                  ? AppColors.kMainPurpleColor
                  : AppColors.kWhiteColor,
            );
          },
        ),
      ),
    );
  }

  Widget _galleryButton() {
    return Positioned(
      left: 20,
      //right: 0,
      bottom: 260,
      child: ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
        onPressed: () {
          print("**************************** Gallery button");
          _pickImage();
        },
        child: const Icon(
          Icons.photo_album_outlined,
          size: 24,
          color: AppColors.kMainPurpleColor,
        ),
      ),
    );
  }

  // Open bottom sheet
  void _openBottomSheet(String qrCode) {
    const urlPattern =
        r'^(https?:\/\/)?([\w-]+(\.[\w-]+)+)(\/[\w- ;,./?%&=]*)?$';
    final regExp = RegExp(urlPattern);
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        // bottom sheet main container
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey.withOpacity(0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // draggable indicator
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // Qr code result container
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      // Set minimum height
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.1,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SelectableText(
                          qrCode,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            color: regExp.hasMatch(qrCode)
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                // advertisement area and copy button
                Column(
                  children: [
                    // advertisement area

                    const SizedBox(
                      height: 10,
                    ),

                    // buttons
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Open in browser
                        ElevatedButton(
                          onPressed: regExp.hasMatch(qrCode)
                              ? () {
                                  _launchURL(qrCode);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.9, 50),
                            backgroundColor: regExp.hasMatch(qrCode)
                                ? AppColors.kMainPurpleColor
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Open in browser",
                            style: AppTextStyles.appTitleStyle.copyWith(
                              color: AppColors.kWhiteColor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Copy to clipboard
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await Clipboard.setData(
                                ClipboardData(text: qrCode),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: AppColors.kSnackBarBgColor,
                                  content: Text(
                                    "Copied to clipboard",
                                    style: AppTextStyles.appDescriptionTextStyle
                                        .copyWith(
                                      fontSize: 16,
                                      color: AppColors.kWhiteColor,
                                    ),
                                  ),
                                ),
                              );
                            } catch (err) {
                              SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor: AppColors.kMainPurpleColor,
                                content: Text(
                                  "Error copying to clipboard",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.appDescriptionTextStyle
                                      .copyWith(
                                    fontSize: 16,
                                    color: AppColors.kWhiteColor,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.9, 50),
                            //maximumSize: Size(MediaQuery.of(context).size.width* 0.48, 50),
                            backgroundColor: AppColors.kMainPurpleColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Copy to clipboard",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.appTitleStyle.copyWith(
                              color: AppColors.kWhiteColor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: kBottomNavigationBarHeight + 15,
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      // Resume the camera when the bottom sheet is dismissed
      qrViewController?.resumeCamera();
      _animationController.repeat(reverse: true);
    });
  }

  Future<void> _launchURL(String qrCode) async {
    final Uri url = Uri.parse(qrCode);

    // Regular expression for validating URLs
    const urlPattern =
        r'^(https?:\/\/)?([\w-]+(\.[\w-]+)+)(\/[\w- ;,./?%&=]*)?$';
    final regExp = RegExp(urlPattern);

    // print(regExp.hasMatch(qrCode));
    if (regExp.hasMatch(qrCode) && await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Invalid URL or could not launch $url");
    }
  }

  // if the camera permissions was denied this page will show
  Widget _customScanScreen() {
    return !_isCameraPermissionPermanentlyDenied
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Why we need access ?",
                  style: AppTextStyles.appTitleStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "This app requires camera access to scan QR codes. Please grant camera permission.",
                  style: AppTextStyles.appSubtitleStyle
                      .copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(3),
                      overlayColor:
                          WidgetStatePropertyAll(Colors.white.withOpacity(0.1)),
                      minimumSize: const WidgetStatePropertyAll(
                        Size(double.infinity, 50),
                      ),
                      backgroundColor: const WidgetStatePropertyAll(
                          AppColors.kMainPurpleColor),
                    ),
                    onPressed: () {
                      openAppSettings();
                      _checkCameraPermission();
                    },
                    child: Text(
                      "Allow",
                      style: AppTextStyles.appButtonTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

// Open in browser
// InkWell(
//   onTap: () {
//     _launchURL(qrCode);
//   },
//   borderRadius: BorderRadius.circular(10),
//   child: Material(
//     color: Colors.transparent, // Set the background color to transparent
//     borderRadius: BorderRadius.circular(10),
//     child: Container(
//       // margin: const EdgeInsets.symmetric(
//       //   horizontal: 30,
//       // ),
//       width: MediaQuery.of(context).size.width * 0.43,
//       height: 50,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: AppColors.kMainColor,
//       ),
//       child: Center(
//         child: Text(
//           "Open in browser",
//           style: AppTextStyles.appTitleStyle.copyWith(
//             color: AppColors.kWhiteColor,
//             fontSize: 20,
//           ),
//         ),
//       ),
//     ),
//   ),
// ),
