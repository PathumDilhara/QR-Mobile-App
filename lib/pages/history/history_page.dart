import 'package:flutter/material.dart';
import 'package:qr_mobile_app/widgets/generated_history_tab.dart';
import 'package:qr_mobile_app/widgets/scan_history_tab.dart';

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
        : AppColors.kBlackColor;
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: TabBar(
            indicatorColor: WidgetStateColor.transparent,
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
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.kWhiteColor.withOpacity(0.7)
                  : AppColors.kBlackColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TabBarView(
          controller: _tabController,
          children: const [
            GeneratedHistoryTab(),
            ScanHistoryTab(),
          ],
        ),
      ),
    );
  }
}
