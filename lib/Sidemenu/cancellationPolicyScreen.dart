import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/l10n/app_localizations.dart';

class CancellationPolicyScreen extends StatelessWidget {
  const CancellationPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
                  text: localizations.menuCancelPolicy,
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(localizations.cP_q1),
            SectionDescription(localizations.freeCancellationInfo),
            const SizedBox(height: 20),
            SectionTitle(localizations.cP_q2),
            SectionDescription(localizations.cP_a2),
            SectionDescription(localizations.cP_a22),
            SectionDescription(localizations.cP_a23),
            const SizedBox(height: 20),
            SectionTitle(localizations.cP_q5),
            SectionDescription(localizations.cP_a5),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      textcolor: KblackColor,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
  }
}

class SectionDescription extends StatelessWidget {
  final String text;

  const SectionDescription(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        CustomText(
          text: text,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          textcolor: KblackColor,
        ),
      ],
    );
  }
}
