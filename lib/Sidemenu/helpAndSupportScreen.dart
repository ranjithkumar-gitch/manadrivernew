import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

import 'package:mana_driver/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatefulWidget {
  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
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

                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              MediaQuery.of(context).size.height -
                              kToolbarHeight -
                              MediaQuery.of(context).padding.top,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 🔹 IMAGE
                              Image.asset(
                                'images/helpand_support.png',
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),

                              const SizedBox(height: 16),

                              // 🔹 TITLE
                              SizedBox(
                                width: 190,
                                child: CustomText(
                                  text: localizations.hS_t1,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  textcolor: const Color(0xFFFF6B00),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              const SizedBox(height: 40),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: localizations.hS_t2,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  textcolor: KblackColor,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: localizations.helpDesc,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: Colors.grey.shade700,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: localizations.quickHelp,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  textcolor: KblackColor,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: localizations.chooseWay,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: Colors.grey.shade700,
                                ),
                              ),

                              const SizedBox(height: 15),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: localizations.callSupport,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  textcolor: KblackColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: localizations.callDesc,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () => _callNumber("+91 9000464851"),
                                  child: CustomText(
                                    text: "+91 9000464851",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textcolor: const Color(0xFFFF6B00),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: localizations.availableHours,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  textcolor: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: localizations.emailSupport,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  textcolor: KblackColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: localizations.emailDesc,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  textcolor: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () => _sendEmail("hello@nyzoride.com"),
                                  child: CustomText(
                                    text: "hello@nyzoride.com",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textcolor: const Color(0xFFFF6B00),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(
                                  text: localizations.emailReplyTime,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  textcolor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  void _callNumber(String phone) async {
    phone = phone.replaceAll("+91", "").trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number not available.")),
      );
      return;
    }

    if (phone.length != 10) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid phone number.")));
      return;
    }

    final Uri callUri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Unable to open dialer.")));
    }
  }

  void _sendEmail(String email) async {
    if (email.isEmpty || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid email address."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final Uri mailUri = Uri(scheme: 'mailto', path: email);

    if (await canLaunchUrl(mailUri)) {
      await launchUrl(mailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open email app.")),
      );
    }
  }

  Widget contactCard(
    String imagePath,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
