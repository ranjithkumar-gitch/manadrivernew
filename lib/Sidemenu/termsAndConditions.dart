import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
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
                  text: 'Terms & Conditions',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("NYZO RIDE – OWNER"),

            const SizedBox(height: 20),

            sectionTitle("1. PLATFORM PURPOSE"),
            const SizedBox(height: 10),
            bullet(
              "This application is only a technology platform that connects vehicle owners with independent drivers.",
            ),
            bullet(
              "The platform does not provide drivers as employees, does not guarantee driver availability, and does not offer transportation services.",
            ),

            const SizedBox(height: 20),

            sectionTitle("2. ELIGIBILITY"),
            const SizedBox(height: 10),
            bullet("The vehicle owner must be 18 years or older."),
            bullet(
              "The owner must have legal ownership or valid authorization to use the vehicle.",
            ),
            bullet(
              "Only legally registered vehicles are allowed on the platform.",
            ),

            const SizedBox(height: 20),

            sectionTitle("3. VEHICLE RESPONSIBILITY"),
            const SizedBox(height: 10),
            bullet(
              "The owner is fully responsible for the condition, safety, and legality of the vehicle.",
            ),
            bullet("Before every trip, the owner must ensure:"),
            bullet("Vehicle is in good running condition"),
            bullet("Adequate fuel is available"),
            bullet(
              "All documents (RC, Insurance, PUC, permits if applicable) are valid",
            ),

            const SizedBox(height: 20),

            sectionTitle("4. DRIVER RELATIONSHIP"),
            const SizedBox(height: 10),
            bullet(
              "Drivers on the platform are independent individuals, not employees or agents of the platform.",
            ),
            bullet(
              "The platform is not responsible for the conduct, behavior, or actions of drivers.",
            ),
            bullet("Owners are free to accept or reject any driver request."),

            const SizedBox(height: 20),

            sectionTitle("5. BOOKING & TRIP DETAILS"),
            const SizedBox(height: 10),
            bullet(
              "Owners must clearly select the correct trip type (One Way / Round Trip / Hourly / Outstation).",
            ),
            bullet(
              "Pickup, drop location, duration, and special instructions must be clearly mentioned.",
            ),
            bullet(
              "Any change during the trip must be mutually agreed between owner and driver.",
            ),

            const SizedBox(height: 20),

            sectionTitle("6. PAYMENTS"),
            const SizedBox(height: 10),
            bullet("Payment details are shown before booking confirmation."),
            bullet(
              "The platform only facilitates payments and is not responsible for off-app or cash transactions.",
            ),
            bullet(
              "Any additional charges must be settled directly between owner and driver.",
            ),

            const SizedBox(height: 20),

            sectionTitle("7. CANCELLATIONS"),
            const SizedBox(height: 10),
            bullet(
              "Repeated cancellations by the owner may result in temporary or permanent suspension.",
            ),
            bullet(
              "Cancellation charges, if applicable, will be displayed before confirmation.",
            ),

            const SizedBox(height: 20),

            sectionTitle("8. SAFETY & LIABILITY"),
            const SizedBox(height: 10),
            bullet(
              "The platform is not responsible for accidents, injuries, damages, theft, or losses during the trip.",
            ),
            bullet(
              "Any insurance claims must be handled directly between the owner, driver, and insurance company.",
            ),
            bullet(
              "Owners are advised to ensure active insurance coverage before every trip.",
            ),

            const SizedBox(height: 20),

            sectionTitle("9. POST-TRIP VEHICLE INSPECTION & BELONGINGS"),
            const SizedBox(height: 10),
            bullet(
              "After trip completion, the owner must immediately inspect the vehicle.",
            ),
            bullet("The platform is not responsible for:"),
            bullet(
              "Any personal belongings (cash, mobile phones, documents, valuables, etc.) left inside the vehicle",
            ),
            bullet(
              "Any scratches, dents, or damages identified after trip completion",
            ),
            bullet(
              "If any issue is noticed, the owner must raise it immediately with the driver.",
            ),
            bullet(
              "Complaints raised after delay or after leaving the vehicle will not be entertained.",
            ),

            const SizedBox(height: 20),

            sectionTitle("10. PROHIBITED ACTIVITIES"),
            const SizedBox(height: 10),
            bullet("Provide false vehicle or personal information"),
            bullet("Use the platform for illegal activities"),
            bullet("Misbehave, threaten, or harass drivers"),
            bullet(
              "Violation may lead to account termination without prior notice.",
            ),

            const SizedBox(height: 20),

            sectionTitle("11. RATINGS & FEEDBACK"),
            const SizedBox(height: 10),
            bullet("Owners should provide honest and fair feedback."),
            bullet(
              "Fake, abusive, or misleading reviews may result in account restrictions.",
            ),

            const SizedBox(height: 20),

            sectionTitle("12. ACCOUNT SUSPENSION OR TERMINATION"),
            const SizedBox(height: 10),
            bullet(
              "The platform reserves the right to suspend or terminate accounts if:",
            ),
            bullet("Terms & Conditions are violated"),
            bullet("Fraudulent activity is detected"),
            bullet("Repeated complaints are received"),

            const SizedBox(height: 20),

            sectionTitle("13. DATA USAGE & PRIVACY"),
            const SizedBox(height: 10),
            bullet("Owner data is used only for service-related purposes."),
            bullet(
              "Personal information will not be shared except when required by law.",
            ),

            const SizedBox(height: 20),

            sectionTitle("14. CHANGES TO TERMS"),
            const SizedBox(height: 10),
            bullet(
              "The platform may modify these Terms & Conditions at any time.",
            ),
            bullet(
              "Continued use of the app means acceptance of updated terms.",
            ),

            const SizedBox(height: 20),

            sectionTitle("15. ACCEPTANCE"),
            const SizedBox(height: 10),
            bullet(
              "By using this application, the owner confirms that they have read, understood, and agreed to all the above Terms & Conditions.",
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
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

Widget sectionTitle(String text) {
  return CustomText(
    text: text,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    textcolor: KblackColor,
  );
}
