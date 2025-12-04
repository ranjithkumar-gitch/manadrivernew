import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/l10n/app_localizations.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final List<Map<String, String>> conditions = [
      {"title": localizations.tDt1, "description": localizations.tD_D1},
      {"title": localizations.tDt2, "description": localizations.tD_D2},
      {"title": localizations.tDt3, "description": localizations.tD_D3},
      {"title": localizations.tDt4, "description": localizations.tD_D4},
      {"title": localizations.tDt5, "description": localizations.tD_D5},
      {"title": localizations.tDt6, "description": localizations.tD_D6},
      {"title": localizations.tDt7, "description": localizations.tD_D7},
      {"title": localizations.tDt8, "description": localizations.tD_D8},
      {"title": localizations.tDt9, "description": localizations.tD_D9},
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
                  text: localizations.menuTC,
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
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textcolor: KblackColor,
                ),
                SizedBox(height: 8),
                CustomText(
                  text: conditions[index]['description']!,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textcolor: kseegreyColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
