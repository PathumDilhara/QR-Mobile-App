import 'package:flutter/material.dart';
import 'package:qr_mobile_app/data/faq_data.dart';
import 'package:qr_mobile_app/model/faq_model.dart';
import 'package:qr_mobile_app/utils/colors.dart';
import 'package:qr_mobile_app/utils/text_styles.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<FAQModel> faqData = FAQData.faqData;
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor = isDark
        ? AppColors.kSettingsContentsPageBgColor
        : Colors.white.withOpacity(0.95);
    Color titleColor = isDark ? Colors.white.withOpacity(0.7) : Colors.black;
    Color panelListBgColor = isDark ? Colors.white.withOpacity(0.7) : AppColors.kPurpleColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // automaticallyImplyLeading: false,
        // leading: IconButton(
        //     onPressed: () {
        //       AppRouter.router.push("/settings");
        //     },
        //     icon: const Icon(Icons.arrow_back),),
        title: Text(
          "FAQ",
          style: AppTextStyles.appTitleStyle.copyWith(color: titleColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _buildPanel(panelListBgColor),
        ),
      ),
    );
  }

  Widget _buildPanel(Color panelListBgColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 30),
      child: Column(
        children: faqData.map<Widget>((FAQModel faq) {
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ExpansionPanelList(
                  elevation: 2,
                  expandIconColor: AppColors.kMainColor,
                  materialGapSize: 10,
                  expansionCallback: (int panelIndex, bool isExpanded) {
                    setState(() {
                      faq.isExpanded = isExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      backgroundColor: panelListBgColor,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            faq.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isExpanded
                                  ? AppColors.kMainColor
                                  : Colors.black,
                            ),
                          ),
                        );
                      },
                      body: ListTile(
                        title: Text(
                          faq.description,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                      isExpanded: faq.isExpanded,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ), // Space between tiles
            ],
          );
        }).toList(),
      ),
    );
  }
}
