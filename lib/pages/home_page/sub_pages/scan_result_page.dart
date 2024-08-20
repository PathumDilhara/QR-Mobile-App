import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/routers.dart';

import '../../../utils/text_styles.dart';

class ScanResultPage extends StatefulWidget {
  final String result;
  const ScanResultPage({super.key, required this.result});

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  QRViewController? qrViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async {
            AppRouter.router.push("/home");
          },
          icon: Icon(Icons.arrow_back,
              size: 30,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.kWhiteColor.withOpacity(0.7)
                  : AppColors.kBlackColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Scanned Result",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.kWhiteColor
                                      : AppColors.kBlackColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                widget.result,
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.kWhiteColor.withOpacity(0.7)
                                        : AppColors.kBlackColor.withOpacity(0.5)),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
               await  Clipboard.setData(ClipboardData(text: widget.result));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    backgroundColor: AppColors.kMainColor,
                    content: Text(
                      " Copied to clipboard",
                      style: AppTextStyles.appDescriptionTextStyle.copyWith(
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
            )
          ],
        ),
      ),
    );
  }
}
