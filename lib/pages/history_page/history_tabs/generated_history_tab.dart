import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_app/model/generated_qr_model.dart';
import 'package:qr_mobile_app/utils/colors.dart';

import 'package:qr_mobile_app/utils/floating_action_button_location.dart';
import '../../../provider/qr_history_provider.dart';

class GeneratedHistoryTab extends StatefulWidget {
  const GeneratedHistoryTab({super.key});

  @override
  State<GeneratedHistoryTab> createState() => _GeneratedHistoryTabState();
}

class _GeneratedHistoryTabState extends State<GeneratedHistoryTab> {
  // late initializer for QRHistoryProvider
  late QRHistoryProvider qrHistoryProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Call your provider method after the widget tree is built
      Provider.of<QRHistoryProvider>(context, listen: false)
          .loadGeneratedQRCodes();
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
        builder: (context, qrHistoryProvider, child) {
          // Determine if the stored QR list is empty based on the provider's state
          bool isGenStoredQrListEmpty =
              qrHistoryProvider.storedGenQRCodes.isEmpty;

          return SizedBox(
            width: 120,
            height: 50,
            child: FloatingActionButton(
              backgroundColor: isGenStoredQrListEmpty
                  ? Colors.grey
                  : AppColors.kMainPurpleColor,
              // Only enable FAB action when there are QR codes to clear
              onPressed: isGenStoredQrListEmpty
                  ? (){} // Disable button if list is empty
                  : () async {
                      await qrHistoryProvider
                          .clearGeneratedQRBox(); // Clear QR box
                    },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Clear all",
                    style: TextStyle(fontSize: 15),
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
        builder: (context, qrHistoryProvider, child) {
          // If no QR codes are stored, show the empty message
          if (qrHistoryProvider.storedGenQRCodes.isEmpty) {
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
            itemCount: qrHistoryProvider.storedGenQRCodes.length,
            itemBuilder: (context, index) {
              final GeneratedQRModel qrCode =
                  qrHistoryProvider.storedGenQRCodes[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Dismissible(
                  key: ValueKey<String>(qrCode.id),
                  // Dismiss QR codes using swipe action
                  onDismissed: (DismissDirection direction) async {
                    await qrHistoryProvider
                        .deleteGeneratedQRCode(qrCode); // Delete QR code
                  },
                  child: ListTile(
                    tileColor: AppColors.kMainPurpleColor.withOpacity(0.3),
                    trailing: IconButton(
                      onPressed: () async {
                        await qrHistoryProvider.deleteGeneratedQRCode(
                            qrCode); // Delete on button press
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
                      "${DateFormat.yMMMd().format(DateTime.parse(qrCode.date.toString()))} ${DateFormat.Hm().format(DateTime.parse(qrCode.date.toString()))}",
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
