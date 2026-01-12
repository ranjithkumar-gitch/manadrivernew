import 'package:flutter/material.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

import 'package:url_launcher/url_launcher.dart';

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
              text: "NYZO RIDE – OWNER",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 10),

            CustomText(
              text: "Last Updated: January 2026",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            CustomText(
              text:
                  "Nyzo Ride (“Nyzo”, “we”, “our”, “us”) respects your privacy and is committed to protecting the personal information of users (“you”, “user”, “driver”, “vehicle owner”) who use the Nyzo Ride mobile application, website, and related services (collectively, the “Platform”).",

              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 10),

            CustomText(
              text:
                  "This Privacy Policy explains how we collect, use, store, share, and protect your information.",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 25),

            sectionTitle("1. INFORMATION WE COLLECT"),
            const SizedBox(height: 15),

            CustomText(
              text: "1.1 Personal Information",
              fontWeight: FontWeight.w600,
              fontSize: 15,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: "We may collect the following:",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet("Full name"),
            bullet("Mobile number"),
            bullet("Email address (optional)"),
            bullet("Profile photo (optional)"),
            bullet(
              "Government ID details (for drivers – License, PAN/Aadhaar where required)",
            ),
            bullet("Vehicle details (vehicle owners)"),

            const SizedBox(height: 20),

            CustomText(
              text: "1.2 Location Information",
              fontWeight: FontWeight.w600,
              fontSize: 15,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet("Real-time location during active trips"),
            bullet("Pickup and drop locations"),
            bullet("Trip routes and distance data"),

            const SizedBox(height: 8),
            CustomText(
              text:
                  "Location is collected only when the app is in use and for trip-related purposes.",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),

            const SizedBox(height: 20),

            CustomText(
              text: "1.3 Usage & Device Information",
              fontWeight: FontWeight.w600,
              fontSize: 15,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet("Device model, OS version"),
            bullet("App usage data"),
            bullet("IP address"),
            bullet("Crash logs and diagnostic data"),

            const SizedBox(height: 20),

            CustomText(
              text: "1.4 Payment Information",
              fontWeight: FontWeight.w600,
              fontSize: 15,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet("Payment status"),
            bullet("Transaction ID"),
            bullet(
              "Payment method (Nyzo does NOT store card or UPI credentials)",
            ),

            const SizedBox(height: 20),

            sectionTitle("2. HOW WE USE YOUR INFORMATION"),
            const SizedBox(height: 5),
            CustomText(
              text: "We use your information to:",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 5),
            bullet("Connect vehicle owners with drivers"),
            bullet("Enable bookings and trip management"),
            bullet("Verify driver identity and eligibility"),
            bullet("Process payments and refunds"),
            bullet("Improve app performance and user experience"),
            bullet("Communicate service updates and alerts"),
            bullet("Prevent fraud and misuse"),
            bullet("Comply with legal obligations"),

            const SizedBox(height: 20),

            sectionTitle("3. INFORMATION SHARING"),
            const SizedBox(height: 5),
            CustomText(
              text: "Nyzo Ride does not sell or rent your personal data",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 5),
            CustomText(
              text: "We may share limited information with:",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 5),
            bullet(
              "Drivers / Vehicle Owners – only what is required for a trip",
            ),
            bullet("Payment gateways – for transaction processing"),
            bullet("Cloud & technology partners – app hosting, analytics"),
            bullet(
              "Law enforcement / government authorities – when legally required",
            ),

            const SizedBox(height: 20),

            sectionTitle("4. DATA STORAGE & SECURITY"),
            const SizedBox(height: 10),
            bullet("Data is stored on secure servers"),
            bullet("Industry-standard encryption is used"),
            bullet("Access is limited to authorized personnel only"),
            bullet("Regular security audits are conducted"),
            CustomText(
              text:
                  "Despite best efforts, no digital system is 100% secure. Users share data at their own risk.",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            sectionTitle("5. USER RIGHTS"),
            const SizedBox(height: 10),
            CustomText(
              text: "You have the right to:",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet("Access your personal data"),
            bullet("Update or correct your information"),
            bullet("Request deletion of your account"),
            bullet("Withdraw consent (where applicable)"),
            CustomText(
              text:
                  "Account deletion requests may be subject to legal or regulatory retention requirements.",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),

            const SizedBox(height: 20),

            sectionTitle("6. DATA RETENTION"),
            const SizedBox(height: 10),
            bullet("Data is retained only as long as necessary"),
            bullet(
              "Trip and transaction records may be retained for legal, tax, or dispute purposes",
            ),
            bullet("Inactive accounts may be deleted after a defined period"),

            const SizedBox(height: 20),

            sectionTitle("7. CHILDREN’S PRIVACY"),
            const SizedBox(height: 10),
            bullet("Nyzo Ride is not intended for users under 18 years."),
            bullet("We do not knowingly collect data from minors."),

            const SizedBox(height: 20),

            sectionTitle("8. THIRD-PARTY SERVICES"),
            const SizedBox(height: 10),
            bullet(
              "Nyzo Ride may contain links or integrations with third-party services.",
            ),
            bullet("We are not responsible for their privacy practices."),

            const SizedBox(height: 20),

            sectionTitle("9. PLATFORM NATURE DISCLAIMER"),
            const SizedBox(height: 10),
            CustomText(
              text: "Nyzo Ride is a technology platform only:",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            bullet("Nyzo is not a transport operator"),
            bullet("Nyzo does not own vehicles"),
            bullet("Nyzo does not employ drivers"),
            bullet(
              "Drivers and vehicle owners are independent service providers",
            ),

            const SizedBox(height: 20),

            sectionTitle("10. CHANGES TO THIS POLICY"),
            const SizedBox(height: 10),
            bullet(
              "Nyzo Ride may update this Privacy Policy from time to time.",
            ),
            bullet(
              "Updated versions will be published within the app or website.",
            ),
            bullet(
              "Continued use of the platform implies acceptance of the revised policy.",
            ),

            const SizedBox(height: 20),

            sectionTitle("11. CONTACT US"),
            const SizedBox(height: 10),
            CustomText(
              text: "For privacy concerns or data requests, contact:",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 10),
            CustomText(
              text: "Nyzo Ride Support",
              fontWeight: FontWeight.w600,
              fontSize: 14,
              textcolor: KblackColor,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _sendEmail("hello@nyzoride.com"),
              child: support("hello@nyzoride.com", "Email:"),
            ),
            GestureDetector(
              onTap: () => _callNumber("9000464851"),
              child: support("9000464851", "Phone:"),
            ),

            // GestureDetector(
            //   onTap: () => _callNumber("8520851338"),
            //   child: support("8520851338", "Phone:"),
            // ),
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
      fontWeight: FontWeight.w600,
      fontSize: 16,
      textcolor: KblackColor,
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
}
