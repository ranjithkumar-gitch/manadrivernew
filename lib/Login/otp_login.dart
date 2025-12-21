import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';

import 'package:mana_driver/Login/selectLanguage.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/l10n/app_localizations.dart';
import 'package:mana_driver/service.dart';

import 'package:mana_driver/viewmodels/login_viewmodel.dart';

import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';

class OtpLogin extends StatefulWidget {
  final String phoneNumber;

  const OtpLogin({super.key, required this.phoneNumber});

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  final TextEditingController otpController = TextEditingController();
  bool _isLoading = false;
  // @override
  // void initState() {
  //   super.initState();
  //   _checkUserRole();
  // }

  // Future<void> _checkUserRole() async {
  //   final role = await SharedPrefServices.getRoleCode();

  //   if (role != "Owner" && mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("This screen is only for Owners."),
  //         backgroundColor: Colors.redAccent,
  //       ),
  //     );
  //     Navigator.pop(context); // or redirect to login/home
  //   }
  // }

  final FCMService fcmService = FCMService();

  Future<void> fetchServiceKeys() async {
    try {
      final snap =
          await FirebaseFirestore.instance
              .collection("serviceKeys")
              .doc('p5xZLhdsUezpgluOIzSY')
              .get();

      if (!snap.exists) {
        print("Service keys document not found");
        return;
      }

      final data = snap.data()!;

      await SharedPrefServices.setAuthProvider(data["authProvider"] ?? "");
      await SharedPrefServices.setAuthUri(data["authUri"] ?? "");
      await SharedPrefServices.setClientEmail(data["clientEmail"] ?? "");
      await SharedPrefServices.setClientId(data["clientId"] ?? "");
      await SharedPrefServices.setClientUrl(data["clientUrl"] ?? "");
      await SharedPrefServices.setPrimaryKey(data["primaryKey"] ?? "");
      await SharedPrefServices.setPrivateKey(data["privateKey"] ?? "");
      await SharedPrefServices.setTokenUri(data["tokenUri"] ?? "");
      await SharedPrefServices.setUniverseDomain(data["universeDomain"] ?? "");

      print("Service keys saved to SharedPreferences!");

      print("authProvider      : ${SharedPrefServices.getAuthProvider()}");
      print("authUri           : ${SharedPrefServices.getAuthUri()}");
      print("clientEmail       : ${SharedPrefServices.getClientEmail()}");
      print("clientId          : ${SharedPrefServices.getClientId()}");
      print("clientUrl         : ${SharedPrefServices.getClientUrl()}");
      print("primaryKey        : ${SharedPrefServices.getPrimaryKey()}");
      print("privateKey        : ${SharedPrefServices.getPrivateKey()}");
      print("tokenUri          : ${SharedPrefServices.getTokenUri()}");
      print("universeDomain    : ${SharedPrefServices.getUniverseDomain()}");
    } catch (e) {
      print("Error loading service keys: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Column(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: localizations.enterYourOtp,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            textcolor: korangeColor,
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: kgreyColor,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.phoneNumber,
                                  style: TextStyle(color: korangeColor),
                                ),
                                TextSpan(text: " " + localizations.otpSent),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          Pinput(
                            controller: otpController,
                            length: 4,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            defaultPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              textStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: KblackColor,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: kbordergreyColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              textStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: korangeColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: kgreyColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  TextSpan(text: localizations.otpNotReceived),
                                  TextSpan(
                                    text: localizations.resendOtp,
                                    style: TextStyle(
                                      color: korangeColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _isLoading
                        ? const CircularProgressIndicator(color: korangeColor)
                        : CustomButton(
                          text: localizations.verifyOtp,
                          onPressed: () async {
                            setState(() => _isLoading = true);

                            try {
                              final vm = context.read<LoginViewModel>();

                              await vm.fetchLoggedInUser(widget.phoneNumber);
                              await fetchServiceKeys();
                              final role =
                                  await SharedPrefServices.getRoleCode();

                              if (!mounted) return;

                              if (role == "Owner") {
                                final docId = SharedPrefServices.getDocId();

                                if (docId != null && docId.isNotEmpty) {
                                  final snap =
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(docId)
                                          .get();

                                  if (snap.exists) {
                                    final driverToken =
                                        snap.data()?["fcmToken"] ?? "";

                                    if (driverToken.isNotEmpty) {
                                      await fcmService.sendNotification(
                                        recipientFCMToken: driverToken,
                                        title: localizations.welcomeBack,
                                        body: localizations.loggedInReady,
                                      );
                                      print("Login success notification sent!");
                                    }
                                  }
                                }
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BottomNavigation(),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LanguageSelectionScreen(),
                                  ),
                                );
                              }
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          },
                          width: 220,
                          height: 53,
                        ),

                    const SizedBox(height: 32),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
