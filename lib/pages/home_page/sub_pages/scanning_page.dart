import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 350.0;
    titleSet();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
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
            child: (result != null)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // to use two text styles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(

                                  duration: const Duration(seconds: 1),
                                  backgroundColor: AppColors.kMainColor,
                                  content: Text(
                                    " Copied to clipboard",
                                    style: AppTextStyles.appDescriptionTextStyle
                                        .copyWith(
                                      fontSize: 18,
                                      color: AppColors.kWhiteColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.copy,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Buttons for camera control
                          ElevatedButton(
                            onPressed: () async {
                              await qrViewController!.flipCamera();
                            },
                            child: const Icon(Icons.flip_camera_ios_outlined, size: 24,)
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await qrViewController!.pauseCamera();
                            },
                            child: const Text(
                              "Pause",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await qrViewController!.resumeCamera();
                            },
                            child: const Text(
                              "Resume",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await qrViewController!.toggleFlash();
                            },
                            child: FutureBuilder(
                              future: qrViewController?.getFlashStatus(),
                              builder: (context, snapshot) {
                                final String flash =
                                    snapshot.data == false ? "OFF" : "ON";
                                return Text(
                                  "Flash: $flash",
                                  style: const TextStyle(fontSize: 18),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Text(
                    "Scan code",
                    style: AppTextStyles.appDescriptionTextStyle,
                  ),
          ),
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
}
