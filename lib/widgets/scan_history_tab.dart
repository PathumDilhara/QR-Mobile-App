import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/colors.dart';

class ScanHistoryTab extends StatefulWidget {
  const ScanHistoryTab({super.key});

  @override
  State<ScanHistoryTab> createState() => _ScanHistoryTabState();
}

class _ScanHistoryTabState extends State<ScanHistoryTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 10),
        itemCount: 20,
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
                "Scn $index",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
