import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_mobile_app/utils/colors.dart';

class QRGeneratingPage extends StatefulWidget {
  const QRGeneratingPage({super.key});

  @override
  State<QRGeneratingPage> createState() => _QRGeneratingPageState();
}

class _QRGeneratingPageState extends State<QRGeneratingPage> {
  final TextEditingController qrInputController = TextEditingController();
  String? qrData;

  @override
  void dispose() {
    qrInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // qrData = qrInputController.text;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: _buildTextField(),
              ),
            ),
            Expanded(
              flex: 4,
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
            _saveButton()
          ],
        ),
      ),
    );
  }

  // Text input field for provide data to create QR code
  Widget _buildTextField() {
    return TextField(
      controller: qrInputController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              qrData = qrInputController.text;
            });
          },
          icon: const Icon(
            Icons.done_outlined,
            size: 30,
          ),
        ),
        hintText: "Enter QR Code",
        hintStyle: const TextStyle(
            color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w100),
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
      return Center(
        child: Text(
          "No data Provided",
          style: TextStyle(
            fontSize: 25,
            color: AppColors.kBlackColor.withOpacity(0.5),
          ),
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Center(
            child: Text(
              qrInputController.text,
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          QrImageView(
            data: qrData,
            embeddedImage: const ExactAssetImage("assets/images/flutter.png"),
            version: QrVersions.auto,
            size: MediaQuery.of(context).size.width * 0.8,
          ),
        ],
      );
    }
  }

  Widget _saveButton() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.kMainColor,
            duration: Duration(seconds: 1),
            content: Text(
              "Image Saved",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.kMainColor,
        ),
        child: const Center(
          child: Text(
            "Save",
            style: TextStyle(fontSize: 30, color: AppColors.kWhiteColor),
          ),
        ),
      ),
    );
  }
}
