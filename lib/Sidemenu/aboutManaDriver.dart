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
                  text: localizations.aboutUsDescription,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  textcolor: KblackColor,
                ),
                const SizedBox(height: 8),
                CustomText(
                  text: localizations.ourGoalDescription,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  textcolor: KblackColor,
                ),
                const SizedBox(height: 8),
                CustomText(
                  text: localizations.facilitatorDescription,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  textcolor: KblackColor,
                ),
                const SizedBox(height: 10),
                sectionTitle(localizations.whatWeDoTitle),
                const SizedBox(height: 5),
                bullet(localizations.connectOwnersDrivers),
                const SizedBox(height: 5),
                bullet(localizations.transparentBookingSystem),
                const SizedBox(height: 5),
                bullet(localizations.easyCommunication),
                const SizedBox(height: 5),
                bullet(localizations.promoteConvenience),

                const SizedBox(height: 10),
                sectionTitle(localizations.whatWeDoNotDoTitle),
                const SizedBox(height: 5),
                bullet(localizations.notEmployDrivers),
                const SizedBox(height: 5),
                bullet(localizations.notOwnVehicles),
                const SizedBox(height: 5),
                bullet(localizations.notGuaranteeAvailability),
                const SizedBox(height: 5),
                bullet(localizations.notResponsibleDisputes),

                const SizedBox(height: 10),
                sectionTitle(localizations.ourVisionTitle),
                const SizedBox(height: 5),
                CustomText(
                  text: localizations.ourVisionDescription,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  textcolor: KblackColor,
                ),
                const SizedBox(height: 10),
                sectionTitle(localizations.ourCommitmentTitle),
                const SizedBox(height: 5),
                CustomText(
                  text: localizations.ourCommitmentIntro,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  textcolor: KblackColor,
                ),
                const SizedBox(height: 5),

                bullet(localizations.commitmentTransparency),
                const SizedBox(height: 5),
                bullet(localizations.commitmentSafetyPrivacy),
                const SizedBox(height: 5),
                bullet(localizations.commitmentImprovement),
                CustomText(
                  text: localizations.commitmentAgreement,
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
