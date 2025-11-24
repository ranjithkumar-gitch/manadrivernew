import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    "images/chevronLeft.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: 'Privacy Policy',
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
            CustomText(
              text: "RYDYN – Privacy Policy (For Owners)",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 10),

            CustomText(
              text: "Last Updated: DD/MM/YYYY",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            CustomText(
              text:
                  "Thank you for using the Rydyn Driver App (“we”, “our”, “us”). "
                  "This Privacy Policy explains how we collect, use, and protect information.",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 25),

            sectionTitle("1. INFORMATION WE COLLECT"),
            const SizedBox(height: 10),

            CustomText(
              text:
                  "We collect information from both Owners (Customers) and Drivers (Partners).",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 15),

            CustomText(
              text: "1.1 Information from Owners",
              fontWeight: FontWeight.w600,
              fontSize: 15,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet("Name"),
            bullet("Phone"),
            bullet("Location"),
            bullet("Trip details"),
            bullet("Feedback and ratings"),

            const SizedBox(height: 20),

            CustomText(
              text: "1.2 Information from Drivers",
              fontWeight: FontWeight.w600,
              fontSize: 15,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet("Name"),
            bullet("Phone"),
            bullet("Address"),
            bullet("Driving License"),
            bullet("Vehicle RC"),
            bullet("Driver Photo"),
            bullet("Trip Data"),

            const SizedBox(height: 20),

            CustomText(
              text: "1.3 Technical Data",
              fontWeight: FontWeight.w600,
              fontSize: 15,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet("Device details"),
            bullet("IMEI/Device ID"),
            bullet("IP address"),
            bullet("Analytics"),
            bullet("Crash logs"),

            const SizedBox(height: 20),

            CustomText(
              text: "1.4 Location Information",
              fontWeight: FontWeight.w600,
              fontSize: 15,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: "Used for assigning drivers, safety,route optimization.",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            sectionTitle("2. HOW WE USE THE INFORMATION"),
            const SizedBox(height: 10),
            CustomText(
              text:
                  "We use collected data to assign rides, verify identity, ensure safety, manage payments, and improve app experience.",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            sectionTitle("3. SECURITY"),
            const SizedBox(height: 10),
            bullet("Encrypted storage"),
            bullet("Secure access"),
            bullet("Fraud prevention for both Owners & Drivers"),

            const SizedBox(height: 20),

            //---------------------------------------------------------
            // 4. ACCOUNT SECURITY
            //---------------------------------------------------------
            sectionTitle("4. ACCOUNT SECURITY"),
            const SizedBox(height: 10),
            bullet("Users must keep OTP/device secure"),
            bullet("Inform Rydyn about unauthorized access"),

            const SizedBox(height: 20),

            //---------------------------------------------------------
            // 5. PAYMENT INFORMATION
            //---------------------------------------------------------
            sectionTitle("5. PAYMENT INFORMATION"),
            const SizedBox(height: 10),
            bullet("Owners: UPI/Card processed securely"),
            bullet("Drivers: Bank/UPI details stored for payouts"),

            const SizedBox(height: 20),

            //---------------------------------------------------------
            // 6. DISCLOSURE OF INFORMATION
            //---------------------------------------------------------
            sectionTitle("6. DISCLOSURE OF INFORMATION"),
            const SizedBox(height: 10),
            bullet("Shared only with Drivers/Owners for ride-related purposes"),
            bullet("Payment partners"),
            bullet("Verification agencies"),
            bullet("Law authorities"),

            const SizedBox(height: 20),

            sectionTitle("7. PROHIBITED USES"),
            const SizedBox(height: 10),
            bullet("Fake bookings"),
            bullet("Manipulation"),
            bullet("Hacking"),
            bullet("Harmful content are not allowed"),

            const SizedBox(height: 20),

            sectionTitle("8. COOKIES"),
            const SizedBox(height: 10),
            CustomText(
              text: "Used only on our website for analytics.",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            sectionTitle("9. POLICY UPDATES"),
            const SizedBox(height: 10),
            CustomText(
              text:
                  "Rydyn may revise this Policy and updated versions will be shown in the app/website.",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            sectionTitle("10. CONTACT US"),
            const SizedBox(height: 10),
            CustomText(
              text: "Rydyn Private Limited",
              fontWeight: FontWeight.w600,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 6),
            CustomText(
              text: "Phone: 9010443536 / 8520851338",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 6),
            CustomText(
              text: "Email: support@rydyn.in",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 40),
          ],
        ),
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
              fontWeight: FontWeight.w500,
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
      fontSize: 16,
      textcolor: KblackColor,
    );
  }
}
