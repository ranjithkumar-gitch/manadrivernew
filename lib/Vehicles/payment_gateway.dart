import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/Location/driverAssigned.dart';

import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

class PaymentGateway extends StatefulWidget {
  const PaymentGateway({super.key});

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => BottomNavigation()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: InkWell(
              //     onTap: () => Navigator.pop(context),
              //     child: Image.asset(
              //       "images/chevronLeft.png",
              //       width: 24,
              //       height: 24,
              //     ),
              //   ),
              // ),
              Center(
                child: CustomText(
                  text: "Payment",
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CustomText(
              text: 'Payment Gateway',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              textcolor: KaddresscardborderColor,
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              // _showDriverDialog(context);
            },
            child: Center(
              child: Text(
                'Payment Completed',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: korangeColor,
                  decoration: TextDecoration.underline,
                  decorationColor: korangeColor,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationThickness: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDriverDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,

      barrierLabel: "Driver Dialog",
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DriverAssignedScreen(),
            ),
          );
        });
        return Center(
          child: Container(
            height: 165,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => _buildPatternDot(index),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: 250,
                  child: Text(
                    "Driver assigned soon please\nwhile wait for confirm",

                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: KblackColor,
                      decoration: TextDecoration.none,
                    ),

                    textAlign: TextAlign.center,
                  ),
                ),
                // SizedBox(
                //   width: 250,
                //   child: CustomText(
                //     text: "Driver assigned soon please\nwhile wait for confirm",
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //     textcolor: KblackColor,
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPatternDot(int index) {
    bool isBig = index == 0 || index == 2;
    Color dotColor = isBig ? korangeColor : korangeresponseColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isBig ? 8 : 6,
      height: isBig ? 8 : 6,
      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
    );
  }
}

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showDriverDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CustomText(
          text: "",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          textcolor: Colors.white,
        ),
      ),
    );
  }

  void _showDriverDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Driver Dialog",
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => _buildPatternDot(index),
                  ),
                ),
                const SizedBox(height: 20),

                CustomText(
                  text: "Driver assigned soon please\nwhile wait for confirm",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textcolor: KblackColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPatternDot(int index) {
    bool isBig = index == 0 || index == 2;
    Color dotColor = isBig ? korangeColor : korangeresponseColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isBig ? 12 : 8,
      height: isBig ? 12 : 8,
      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
    );
  }
}
