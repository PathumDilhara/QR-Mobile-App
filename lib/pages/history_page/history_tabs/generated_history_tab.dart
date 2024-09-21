import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_app/model/generated_qr_model.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/floating_action_button_location.dart';

import '../../../provider/qr_history_provider.dart';

class GeneratedHistoryTab extends StatelessWidget {
  const GeneratedHistoryTab({super.key});

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
              : AppColors.kMainPurpleColor,
          onPressed: qrHistoryProvider.storedGenQRCodes.isEmpty
              ? () {}
              : () async {
                  await qrHistoryProvider.clearGeneratedQRBox();
                  qrHistoryProvider.loadGeneratedQRCodes();
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
                Icons.clear_all_outlined,
                size: 25,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: CustomFabLocation(),
      body: FutureBuilder(
        future: qrHistoryProvider
            .loadGeneratedQRCodes(), // if true below if else part will be executed
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            // Check if the QR code list is empty
            if (qrHistoryProvider.storedGenQRCodes.isEmpty) {
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

            // if box is not empty
            return ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: kBottomNavigationBarHeight + 10),
              itemCount: qrHistoryProvider.storedGenQRCodes.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final GeneratedQRModel qrCode =
                    qrHistoryProvider.storedGenQRCodes[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 5.0,
                  ),
                  child: Consumer<QRHistoryProvider>(
                    builder: (BuildContext context,
                        QRHistoryProvider qrHistoryProvider, Widget? child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Dismissible(
                          key: ValueKey<String>(qrCode.id),
                          onDismissed: (DismissDirection direction) async {
                            await qrHistoryProvider
                                .deleteGeneratedQRCode(qrCode);
                          },
                          child: ListTile(
                            tileColor: AppColors.kMainPurpleColor.withOpacity(0.3),
                            trailing: IconButton(
                              onPressed: () async {
                                await qrHistoryProvider
                                    .deleteGeneratedQRCode(qrCode);
                                qrHistoryProvider.loadGeneratedQRCodes();
                              },
                              icon: Icon(
                                Icons.delete_outline,
                                size: 25,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.kWhiteColor.withOpacity(0.7)
                                    : AppColors.kPurpleColor,
                              ),
                            ),
                            title: Text(
                              qrCode.title,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
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
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.kWhiteColor.withOpacity(0.7)
                                    : AppColors.kBlackColor.withOpacity(0.5),
                              ),
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
