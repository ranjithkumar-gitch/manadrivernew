import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

import 'package:mana_driver/l10n/app_localizations.dart';

class HelpAndSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent, // Important!
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF5100), Colors.white],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 56,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    // border: Border(
                    //   bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    // ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              "images/chevronLeft.png",
                              width: 24,
                              height: 24,
                              color: kwhiteColor,
                            ),
                          ),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: InkWell(
                      //     onTap: () => Navigator.pop(context),
                      //     child: Image.asset(
                      //       "images/chevronLeft.png",
                      //       width: 24,
                      //       height: 24,
                      //       color: kwhiteColor,
                      //     ),
                      //   ),
                      // ),
                      Center(
                        child: Text(
                          localizations.menuHelpSupport,
                          style: TextStyle(
                            color: kwhiteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 80.0),
                          child: Image.asset(
                            'images/helpand_support.png',
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16),

                        SizedBox(
                          width: 190,
                          child: CustomText(
                            text: localizations.hS_t1,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            textcolor: Color(0xFFFF6B00),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 12),

                        // Center(
                        //   child: CustomText(
                        //     text:
                        //         "Lorem Ipsum is simply dummy text\nof the printing and typesetting industry.",
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.w400,
                        //     textcolor: KorangeLightColor,
                        //   ),
                        // ),
                        SizedBox(height: 54),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: localizations.hS_t2,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            textcolor: KblackColor,
                          ),
                        ),
                        SizedBox(height: 16),

                        Column(
                          children: [
                            contactCard(
                              "images/phone.png",
                              localizations.hS_t3,
                              "+91 9000052798",
                            ),
                            SizedBox(height: 12),
                            contactCard(
                              "images/sendemail.png",
                              localizations.hS_t4,
                              "help@manadriver.com",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contactCard(String imagePath, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: KcontactcardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: KcontactimagecontainerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(4),
            child: Image.asset(imagePath, width: 48, height: 48),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textcolor: KcontacttextColor,
                ),
                SizedBox(height: 4),
                CustomText(
                  text: subtitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textcolor: korangeColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
