import 'package:flutter/material.dart';
import 'package:qr_mobile_app/utils/colors.dart';

class GeneratedHistoryTab extends StatefulWidget {
  const GeneratedHistoryTab({super.key});

  @override
  State<GeneratedHistoryTab> createState() => _GeneratedHistoryTabState();
}

class _GeneratedHistoryTabState extends State<GeneratedHistoryTab> {
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
                "Gen $index",
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
