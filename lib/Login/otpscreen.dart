import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/Login/loginScreen.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/l10n/app_localizations.dart';
import 'package:mana_driver/service.dart';
import 'package:mana_driver/viewmodels/register_viewmodel.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String phoneNumberWithCode;
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final String fcmToken;
  final String verificationId;
  final bool isTestOtp;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.phoneNumberWithCode,
    required this.firstName,
    required this.lastName,
    required this.fcmToken,
    required this.email,
    required this.countryCode,
    this.isTestOtp = true,
    required this.verificationId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

final FCMService fcmService = FCMService();

class _OtpScreenState extends State<OtpScreen> {
  bool _isLoading = false;
  String? _currentVerificationId;
  bool _isResending = false;
  String? _otpErrorMessage;

  int _secondsLeft = 60;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    print('OTP ${widget.verificationId}');
    _currentVerificationId = widget.verificationId;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _resendOtp() async {
    if (_isResending) return;

    setState(() => _isResending = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${widget.phoneNumber}",
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {},

        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.message ?? "Resend failed")));
        },

        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _currentVerificationId = verificationId;
            _otpErrorMessage = null;
          });
          _startTimer();

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("OTP resent")));
        },

        codeAutoRetrievalTimeout: (_) {},
      );
    } finally {
      setState(() => _isResending = false);
    }
  }

  final TextEditingController otpController = TextEditingController();

  String capitalizeFirst(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
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
                            length: 6,
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
                              margin: const EdgeInsets.symmetric(horizontal: 5),
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
                                    text:
                                        _secondsLeft > 0
                                            ? "Resend OTP in 00:${_secondsLeft.toString().padLeft(2, '0')}"
                                            : "Resend OTP",
                                    style: TextStyle(
                                      color:
                                          _secondsLeft > 0
                                              ? kgreyColor
                                              : korangeColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer:
                                        _secondsLeft > 0
                                            ? null
                                            : (TapGestureRecognizer()
                                              ..onTap = _resendOtp),
                                  ),

                                  // TextSpan(
                                  //   text: localizations.resendOtp,
                                  //   style: TextStyle(
                                  //     color: korangeColor,
                                  //     fontWeight: FontWeight.w600,
                                  //   ),
                                  // ),
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
                          onPressed: _verifyOtp,
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

  Future<void> _verifyOtp() async {
    final localizations = AppLocalizations.of(context)!;

    final otp = otpController.text.trim();

    if (otpController.text.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter valid OTP")));

      return;
    }

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _currentVerificationId!,

        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      String message = "OTP verification failed. Please try again.";

      if (e.code == 'invalid-verification-code') {
        message = "Incorrect OTP. Please try again.";
      } else if (e.code == 'session-expired') {
        message = "OTP expired. Please request a new one.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),

          behavior: SnackBarBehavior.floating,

          duration: const Duration(seconds: 2),
        ),
      );

      return;
    }

    setState(() => _isLoading = true);

    try {
      final vm = Provider.of<RegisterViewModel>(context, listen: false);

      final success = await vm.register(
        fisrtName: capitalizeFirst(widget.firstName.trim()),

        lastName: widget.lastName,

        email: widget.email.isEmpty ? "" : widget.email,

        phone: widget.phoneNumber,

        countryCode: widget.countryCode,

        fcmToken: widget.fcmToken,
      );

      if (success) {
        await SharedPrefServices.setFirstName(widget.firstName);

        await SharedPrefServices.setLastName(widget.lastName);

        await SharedPrefServices.setEmail(
          widget.email.isEmpty ? "" : widget.email,
        );

        await SharedPrefServices.setNumber(widget.phoneNumber);

        await SharedPrefServices.setCountryCode(widget.countryCode);

        await SharedPrefServices.setFcmToken(widget.fcmToken);

        await SharedPrefServices.setislogged(true);

        await fcmService.sendNotification(
          recipientFCMToken: widget.fcmToken,

          title: localizations.welcomeRydyn,

          body:
              "${capitalizeFirst(widget.firstName)} ${localizations.registrationSuccessMessage}",
        );

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Text(
                localizations.pleaseLogin,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              title: Center(
                child: Text(
                  localizations.registrationSuccessful,
                  style: GoogleFonts.poppins(
                    color: korangeColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: Text(
                    localizations.ok,
                    style: GoogleFonts.poppins(
                      color: korangeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.errorMessage ?? localizations.registrationFailed),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
