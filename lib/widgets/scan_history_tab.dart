import 'package:flutter/material.dart';
import 'package:qr_mobile_app/model/scanned_qr_model.dart';
import 'package:qr_mobile_app/user_services/hive_db_services/scanned_qr_services.dart';
import 'package:qr_mobile_app/utils/colors.dart';

class ScanHistoryTab extends StatefulWidget {
  const ScanHistoryTab({super.key});

  @override
  State<ScanHistoryTab> createState() => _ScanHistoryTabState();
}

class _ScanHistoryTabState extends State<ScanHistoryTab> {

  final ScannedQRServices qrServices = ScannedQRServices();
  List<ScannedQrModel> allQRCodes = [];

  @override
  void initState() {
    super.initState();
    _checkIfUserIsNew();
  }

  // new user
  void _checkIfUserIsNew() async {
    final bool isNewUser = await qrServices.isQRBoxEmpty();
     print("***********************$isNewUser");
    if (isNewUser) {
      await qrServices.createInitialQRCodes();
    }

    _loadQrCodes();
  }

  // Method to load stored qr codes
  Future<void> _loadQrCodes() async {
    final List<ScannedQrModel> loadedQrCodes = await qrServices.loadQRCodes();
    setState(() {
      allQRCodes = loadedQrCodes;
       print("****************${loadedQrCodes.length}");
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
