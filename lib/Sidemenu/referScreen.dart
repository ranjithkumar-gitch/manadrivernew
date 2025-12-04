import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';

import 'package:mana_driver/l10n/app_localizations.dart';

class ReferFriendScreen extends StatelessWidget {
  const ReferFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: KblackColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: KblackColor,
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
                child: CustomText(
                  text: localizations.menuReferaFriend,
                  textcolor: kwhiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: 230,
              height: 230,
              child: Image.asset('images/refer_frd.png', fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),

            Center(
              child: CustomText(
                text: localizations.rat_Txt1,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                textcolor: kwhiteColor,
              ),
            ),
            const SizedBox(height: 24),

            Column(
              children: [
                StepItem(number: 1, text: localizations.rat_Txt2),
                SizedBox(height: 10),
                StepItem(number: 2, text: localizations.rat_Txt3),
                SizedBox(height: 10),
                StepItem(number: 3, text: localizations.rat_Txt4),
              ],
            ),

            const Spacer(),

            CustomButton(
              text: localizations.rat_Txt5,
              onPressed: () {},
              width: 220,
              height: 53,
            ),
          ],
        ),
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final int number;
  final String text;

  const StepItem({super.key, required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Number circle
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: kwhiteColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: const TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: CustomText(
            text: text,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textcolor: kwhiteColor,
          ),
        ),
      ],
    );
  }
}
