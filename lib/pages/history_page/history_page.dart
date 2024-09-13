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
              AppColors.kMainPurpleColor.withOpacity(0.1),
            ),
            indicatorColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.5)
                : AppColors.kMainPurpleColor,
            labelColor: AppColors.kMainPurpleColor,
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: const [
              Tab(
                child: Text(
                  "Generated",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Tab(
                child: Text(
                  "Scanned",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          "History",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextColor(context),
          ),
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
