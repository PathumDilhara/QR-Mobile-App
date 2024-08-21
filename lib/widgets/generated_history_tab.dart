import 'package:flutter/material.dart';
import 'package:qr_mobile_app/model/generated_qr_model.dart';
import 'package:qr_mobile_app/utils/colors.dart';

import '../user_services/hive_db_services/generated_qr_services.dart';


class GeneratedHistoryTab extends StatefulWidget {
  const GeneratedHistoryTab({super.key});

  @override
  State<GeneratedHistoryTab> createState() => _GeneratedHistoryTabState();
}

class _GeneratedHistoryTabState extends State<GeneratedHistoryTab> {

  final GeneratedQRServices qrServices = GeneratedQRServices();
  List<GeneratedQRModel> allQRCodes = [];

  @override
  void initState() {
    super.initState();
    _checkIfUserIsNew();
  }

  // new user
  void _checkIfUserIsNew() async {
    final bool isNewUser = await qrServices.isQRBoxEmpty();
    // print("***********************$isNewUser");
    if (isNewUser) {
      await qrServices.createInitialQRCodes();
    }

    _loadQrCodes();
  }

  // Method to load stored qr codes
  Future<void> _loadQrCodes() async {
    final List<GeneratedQRModel> loadedQrCodes = await qrServices.loadQRCodes();
    setState(() {
      allQRCodes = loadedQrCodes;
      // print("****************${loadedQrCodes.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 10),
        itemCount: allQRCodes.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 5.0,
            ),
            child: ListTile(
              tileColor: AppColors.kMainColor.withOpacity(0.3),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  size: 25,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.kWhiteColor.withOpacity(0.7)
                      : AppColors.kBlackColor,
                ),
              ),
              title: Text(
              allQRCodes[index].title,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
