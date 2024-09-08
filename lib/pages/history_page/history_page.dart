import 'package:flutter/material.dart';
import 'package:qr_mobile_app/pages/history_page/history_tabs/generated_history_tab.dart';
import 'package:qr_mobile_app/pages/history_page/history_tabs/scan_history_tab.dart';

import '../../utils/colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final Color customColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.kWhiteColor.withOpacity(0.7)
        : AppColors.kBlackColor.withOpacity(0.8);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: TabBar(
            dividerColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black12
                : Colors.transparent,
            overlayColor: WidgetStatePropertyAll(
              AppColors.kMainColor.withOpacity(0.1),
            ),
            indicatorColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.5)
                : AppColors.kMainColor,
            labelColor: AppColors.kMainColor,
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: const [
              Tab(
                child: Text(
                  "Generated",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Tab(
                child: Text(
                  "Scanned",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          "History",
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: customColor),
        ),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          GeneratedHistoryTab(),
          ScanHistoryTab(),
        ],
      ),
    );
  }
}
