import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_mobile_app/model/scanned_qr_model.dart';
import 'package:qr_mobile_app/provider/qr_history_provider.dart';
import 'package:qr_mobile_app/provider/settings_provider.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/routers.dart';
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

  late QRHistoryProvider qrHistoryProvider; // Declare the provider
  late SettingsProvider settingsProvider; // Declare the provider

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize the provider
  // }


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

  bool isCameraPaused = false; // State variable to track camera status

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
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
                      Text(
                        "Scan code",
                        style: AppTextStyles.appDescriptionTextStyle.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
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
          _flashButton(),
          _cameraControlButton(),
        ],
      ),
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

            // Pause camera and navigate to result page
            qrViewController.pauseCamera();
            AppRouter.router
                .push("/scan_result", extra: result!.code.toString());
            if(settingsProvider.isHistorySaving) {
              await qrHistoryProvider.storeScnQR(scannedQRModel);
            }
            // print("************************${scannedQRModel.title}");
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
              color: AppColors.kMainColor,
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
            final IconData flash =
                snapshot.data == false || snapshot.data == null
                    ? Icons.flash_off_outlined
                    : Icons.flash_on_outlined;
            return Icon(
              flash,
              size: 24,
              color: snapshot.data == false || snapshot.data == null
                  ? AppColors.kMainColor
                  : AppColors.kWhiteColor,
            );
          },
        ),
      ),
    );
  }

  Widget _cameraControlButton() {
    return Positioned(
      right: 10,
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
                  ? AppColors.kMainColor
                  : AppColors.kWhiteColor,
            );
          },
        ),
      ),
    );
  }
}
