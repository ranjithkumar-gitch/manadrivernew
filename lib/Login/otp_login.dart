import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';

import 'package:mana_driver/Login/selectLanguage.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
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
                            text: "Enter Your OTP",
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
                                const TextSpan(text: "OTP sent to "),
                                TextSpan(
                                  text: widget.phoneNumber,
                                  style: TextStyle(color: korangeColor),
                                ),
                                const TextSpan(
                                  text: " this OTP will get auto entering",
                                ),
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
                                color: korangeColor,
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
                                  const TextSpan(
                                    text: "You didn’t receive OTP? ",
                                  ),
                                  TextSpan(
                                    text: "Resend OTP",
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
                          text: 'Verify OTP',
                          onPressed: () async {
                            setState(() => _isLoading = true);

                            try {
                              final vm = context.read<LoginViewModel>();

                              await vm.fetchLoggedInUser(widget.phoneNumber);

                              final role =
                                  await SharedPrefServices.getRoleCode();

                              if (!mounted) return;

                              if (role == "Owner") {
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
