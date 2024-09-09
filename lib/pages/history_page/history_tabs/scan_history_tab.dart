import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_app/model/scanned_qr_model.dart';
import 'package:qr_mobile_app/utils/colors.dart';

import '../../../provider/qr_history_provider.dart';
import '../../../utils/floating_action_button_location.dart';

class ScanHistoryTab extends StatelessWidget {
  const ScanHistoryTab({super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    final qrHistoryProvider = Provider.of<QRHistoryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: SizedBox(
        width: 120,
        height: 50,
        child: FloatingActionButton(
          backgroundColor: qrHistoryProvider.storedGenQRCodes.isEmpty
              ? Colors.grey
              : AppColors.kMainColor,
          onPressed: qrHistoryProvider.storedGenQRCodes.isEmpty
              ? () {}
              : () async {
                  await qrHistoryProvider.clearScnQRBox();
                  qrHistoryProvider.loadScnQRCodes();
                },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Clear all",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Icon(
                Icons.auto_delete_outlined,
                size: 25,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: CustomFabLocation(),
      body: FutureBuilder(
        future: qrHistoryProvider.loadScnQRCodes(),
        // if true below if else part will be executed
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            // Check if the QR code list is empty
            if (qrHistoryProvider.storedScnQRCodes.isEmpty) {
              return Center(
                child: Text(
                  "No history available",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.5),
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: kBottomNavigationBarHeight + 10),
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
                  child: Consumer<QRHistoryProvider>(
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ListTile(
                          tileColor: AppColors.kMainColor.withOpacity(0.3),
                          trailing: IconButton(
                            onPressed: () async {
                              await qrHistoryProvider.deleteScnQRCode(qrCode);
                            },
                            icon: Icon(
                              Icons.clear_all_outlined,
                              size: 25,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.kWhiteColor.withOpacity(0.7)
                                  : Colors.purple,
                            ),
                          ),
                          title: Text(
                            qrCode.title,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.black,
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
