import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

import 'package:mana_driver/l10n/app_localizations.dart';

class AboutManaDriverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final List<Map<String, String>> conditions = [
      {"title": localizations.menuAbtMD, "description": localizations.mDdisk},
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 5),
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
                    ),
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: localizations.menuAbtMD,
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: conditions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: conditions[index]['title']!,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  textcolor: KblackColor,
                ),
                SizedBox(height: 8),
                CustomText(
                  text:
                      "We are a technology-driven platform built to simplify the connection between vehicle owners and independent, verified drivers.",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  textcolor: KblackColor,
                ),
                const SizedBox(height: 8),
                CustomText(
                  text:
                      "Our goal is to make it easy for vehicle owners to find reliable drivers whenever they need—whether it is for one-way trips, round trips, hourly usage, or outstation travel.",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  textcolor: KblackColor,
                ),
                const SizedBox(height: 8),
                CustomText(
                  text:
                      "We act only as a facilitator, providing a digital platform that enables owners and drivers to connect, communicate, and complete trips smoothly. We do not employ drivers, nor do we provide transportation services directly.",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  textcolor: KblackColor,
                ),
                const SizedBox(height: 10),
                sectionTitle('What We Do'),
                const SizedBox(height: 5),
                bullet(
                  'Connect vehicle owners with available independent drivers',
                ),
                const SizedBox(height: 5),
                bullet(
                  'Provide a transparent booking and trip management system',
                ),
                const SizedBox(height: 5),
                bullet('Enable easy communication between owners and drivers'),
                const SizedBox(height: 5),
                bullet('Promote convenience, flexibility, and efficiency'),

                const SizedBox(height: 10),
                sectionTitle('What We Do Not Do'),
                const SizedBox(height: 5),
                bullet('We do not employ drivers as staff or agents'),
                const SizedBox(height: 5),
                bullet('We do not own or operate vehicles'),
                const SizedBox(height: 5),
                bullet('We do not guarantee driver availability'),
                const SizedBox(height: 5),
                bullet(
                  'We do not take responsibility for personal disputes between owners and drivers',
                ),
                const SizedBox(height: 10),
                sectionTitle('Our Vision'),
                const SizedBox(height: 5),
                CustomText(
                  text:
                      "To become a trusted and convenient driver-connection platform, empowering vehicle owners with flexibility and peace of mind while supporting independent drivers through fair opportunities.",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  textcolor: KblackColor,
                ),
                const SizedBox(height: 10),
                sectionTitle('Our Commitment'),
                const SizedBox(height: 5),
                CustomText(
                  text: "We are committed to:",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  textcolor: KblackColor,
                ),
                const SizedBox(height: 5),

                bullet('Transparency in platform usage'),
                const SizedBox(height: 5),
                bullet('User safety and data privacy'),
                const SizedBox(height: 5),
                bullet('Continuous improvement based on user feedback'),
                CustomText(
                  text:
                      "By using this platform, owners and drivers agree to interact responsibly, respectfully, and in accordance with our Terms & Conditions.",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  textcolor: KblackColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: CustomText(
              text: text,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textcolor: KblackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget support(String text, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textcolor: Colors.black,
          ),
          const Text(" ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: CustomText(
              text: text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textcolor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String text) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      textcolor: KblackColor,
    );
  }
}
