import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';

class QRScanningPage extends StatefulWidget {
  const QRScanningPage({super.key});

  @override
  State<QRScanningPage> createState() => _QRScanningPageState();
}

class _QRScanningPageState extends State<QRScanningPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? qrViewController;
  Barcode? result; // Variable to save the scanned QR code data
  dynamic title1;
  dynamic title2;

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // After a Scanned done automatically pause the camera if no need remove it
  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   qrViewController!.pauseCamera();
    // } else if (Platform.isIOS) {
    //   qrViewController!.resumeCamera();
    // }
  }

  void titleSet() {
    if (result != null) {
      title1 = result!.format.name == "qrcode"
          ? "QRCode : "
          : result!.format.name == "ean8"
              ? "Barcode : "
              : "Scanned code :";
      //title1 = "${result!.format.toString().split('.').last} : "; // this is also correct
      title2 = "${result!.code}";
    } else {
      title1 = 'Scan a code';
    }
  }

  bool isCameraPaused = false; // State variable to track camera status

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    titleSet();
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: AppColors.kMainColor,
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
                      (result != null)
                          ? Scrollbar(
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      softWrap: true,
                                      maxLines: 3,
                                      //overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: title1,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: title2,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (title2 != null) {
                                          Clipboard.setData(
                                              ClipboardData(text: title2));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration:
                                                  const Duration(seconds: 1),
                                              backgroundColor:
                                                  AppColors.kMainColor,
                                              content: Text(
                                                " Copied to clipboard",
                                                style: AppTextStyles
                                                    .appDescriptionTextStyle
                                                    .copyWith(
                                                  fontSize: 18,
                                                  color: AppColors.kWhiteColor,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.copy,
                                        size: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Text(
                              "Scan code",
                              style: AppTextStyles.appDescriptionTextStyle,
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
          _flashButton(),
          _cameraControlButton(),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController qrViewController) {
    this.qrViewController = qrViewController;
    qrViewController.scannedDataStream.listen(
      (event) {
        // what we want to do
        setState(() {
          result = event;
        });
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
          ),
          onPressed: () async {
            if (isCameraPaused) {
              await qrViewController!.resumeCamera();
            } else {
              await qrViewController!.pauseCamera();
            }
            setState(() {
              isCameraPaused = !isCameraPaused;
            });
          },
          child: Center(
            child: Icon(
              isCameraPaused ? Icons.play_arrow_outlined : Icons.pause,
              size: 30,
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
      right: 10,
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
            final IconData flash = snapshot.data == false
                ? Icons.flash_off_outlined
                : Icons.flash_on_outlined;
            return Icon(
              flash,
              size: 30,
              color: snapshot.data == false ? null : AppColors.kWhiteColor,
            );
          },
        ),
      ),
    );
  }

  Widget _cameraControlButton() {
    return Positioned(
      right: 10,
      bottom: 250,
      child: ElevatedButton(
        style: const ButtonStyle(backgroundColor: WidgetStateColor.transparent),
        onPressed: () async {
          await qrViewController!.flipCamera();
        },
        child: const Icon(
          Icons.flip_camera_ios_outlined,
          size: 24,
        ),
      ),
    );
  }
}
