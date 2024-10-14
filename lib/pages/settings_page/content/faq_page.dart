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
        : AppColors.kWhiteColor.withOpacity(0.95);
    Color titleColor =
        isDark ? AppColors.kWhiteColor.withOpacity(0.7) : AppColors.kBlackColor;
    // Color panelListBgColor = isDark ? AppColors.kWhiteColor.withOpacity(0.7) : AppColors.kPurpleColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "FAQ",
          style: AppTextStyles.appTitleStyle.copyWith(color: titleColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _buildPanel(AppColors.getFAQPanelBgColor(context)),
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
                  expandIconColor: AppColors.kMainPurpleColor,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isExpanded
                                  ? AppColors.kMainPurpleColor
                                  : AppColors.kBlackColor,
                            ),
                          ),
                        );
                      },
                      body: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: faq.description
                              .split('\n') // Split the description by new lines
                              .map(
                                (line) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Icon(
                                        Icons.circle, // Bullet point icon
                                        size:
                                            10, // Customize the size of the bullet
                                        color: AppColors
                                            .kGreyColor, // Bullet point color
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            8), // Space between bullet and text
                                    Expanded(
                                      child: Text(
                                        line.trim(), // Text of the description
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).toList(),
                        ),
                      ),

                      // body: ListTile(
                      //   leading: Icon(Icons.brightness_1, size: 10, color: AppColors.kGreyColor,),
                      //   title: Text(
                      //     faq.description,
                      //     style: TextStyle(
                      //       fontStyle: FontStyle.italic,
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.w500,
                      //       color: Colors.black.withOpacity(0.5),
                      //     ),
                      //   ),
                      // ),
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
