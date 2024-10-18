import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_app/model/scanned_qr_model.dart';
import 'package:qr_mobile_app/utils/colors.dart';

import '../../../provider/qr_history_provider.dart';
import '../../../utils/floating_action_button_location.dart';

class ScanHistoryTab extends StatefulWidget {
  const ScanHistoryTab({super.key});

  @override
  State<ScanHistoryTab> createState() => _ScanHistoryTabState();
}

class _ScanHistoryTabState extends State<ScanHistoryTab> {

  // late initializer for QRHistoryProvider
  late QRHistoryProvider qrHistoryProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call your provider method after the widget tree is built
      Provider.of<QRHistoryProvider>(context, listen: false).loadScnQRCodes();
    });
  }

  // Load the QR history provider once when dependencies are available.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    qrHistoryProvider = Provider.of<QRHistoryProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      // Using Consumer to rebuild the FAB only when necessary
      floatingActionButton: Consumer<QRHistoryProvider>(
        builder: (context, value, child) {
          // Determine if the stored QR list is empty based on the provider's state
          bool isScnStoredQrListEmpty =
              qrHistoryProvider.storedScnQRCodes.isEmpty;

          return SizedBox(
            width: 120,
            height: 50,
            child: FloatingActionButton(
              backgroundColor: isScnStoredQrListEmpty
                  ? Colors.grey
                  : AppColors.kMainPurpleColor,
              onPressed: isScnStoredQrListEmpty
                  ? null // Disable button if list is empty
                  : () async {
                      await qrHistoryProvider.clearScnQRBox();
                    },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Clear all",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Icon(
                    Icons.clear_all_outlined,
                    size: 25,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: CustomFabLocation(),

      // Using Consumer to listen to changes in QRHistoryProvider for list updates
      body: Consumer<QRHistoryProvider>(
        builder: (context, value, child) {
          // If no QR codes are stored, show the empty message
          if (qrHistoryProvider.storedScnQRCodes.isEmpty) {
            return Center(
              child: Text(
                "No history available",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black.withOpacity(0.5),
                ),
              ),
            );
          }

          // Build the ListView when QR codes are available
          return ListView.builder(
            padding:
                const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 10),
            itemCount: qrHistoryProvider.storedScnQRCodes.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final ScannedQrModel qrCode =
                  qrHistoryProvider.storedScnQRCodes[index];

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 5.0,
                ),
                child: Dismissible(
                  key: ValueKey<String>(qrCode.id),
                  onDismissed: (direction) async {
                    // Delete QR code
                    await qrHistoryProvider.deleteScnQRCode(qrCode);
                  },
                  child: ListTile(
                    tileColor: AppColors.kMainPurpleColor.withOpacity(0.3),
                    trailing: IconButton(
                      onPressed: () async {
                        // Delete on button press
                        await qrHistoryProvider.deleteScnQRCode(qrCode);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        size: 25,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.kWhiteColor.withOpacity(0.7)
                            : AppColors.kPurpleColor,
                      ),
                    ),
                    title: Text(
                      qrCode.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.kWhiteColor.withOpacity(0.7)
                            : AppColors.kBlackColor,
                      ),
                    ),
                    subtitle: Text(
                      "${DateFormat.yMMMd().format(
                        DateTime.parse(
                          qrCode.date.toString(),
                        ),
                      )} ${DateFormat.Hm().format(
                        DateTime.parse(
                          qrCode.date.toString(),
                        ),
                      )}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.kWhiteColor.withOpacity(0.7)
                            : AppColors.kBlackColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
