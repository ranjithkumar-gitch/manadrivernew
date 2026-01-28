import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Login/loginScreen.dart';
import 'package:mana_driver/Login/otpscreen.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customoutlinedbutton.dart';
import 'package:mana_driver/Widgets/mobileNumberInputField.dart';
import 'package:mana_driver/l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

import 'package:country_picker/country_picker.dart';

class UpdateNumber extends StatefulWidget {
  const UpdateNumber({super.key});

  @override
  State<UpdateNumber> createState() => _UpdateNumberState();
}

class _UpdateNumberState extends State<UpdateNumber> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPhoneController = TextEditingController();
  final TextEditingController newOTPController = TextEditingController();

  Country? selectedCountry;

  String? _verificationId;

  bool _otpVerified = false;
  bool _isLoading = false;
  bool _isOtpExpired = false;
  bool _canGenerateOtp = true;

  String? _newGeneratedOtp;
  bool _newOtpVerified = false;
  bool _canGenerateNewOtp = true;
  bool _isNewOtpExpired = false;

  int _newOtpSecondsLeft = 0;
  Timer? _newOtpTimer;

  bool _isGeneratingNewOtp = false;
  bool _isUpdating = false;

  String _generate6DigitOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  int _secondsLeft = 0;
  Timer? _otpTimer;

  void _startNewOtpTimer() {
    _newOtpTimer?.cancel();

    setState(() {
      _newOtpSecondsLeft = 40;
      _canGenerateNewOtp = false;
      _isNewOtpExpired = false;
      _newOtpVerified = false;
    });

    _newOtpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_newOtpSecondsLeft == 0) {
        timer.cancel();
        setState(() {
          _isNewOtpExpired = true;
          _canGenerateNewOtp = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("New number OTP expired. Generate again."),
          ),
        );
      } else {
        setState(() => _newOtpSecondsLeft--);
      }
    });
  }

  Future<void> _sendNewOtpViaNotification(String ownerToken) async {
    if (!_canGenerateNewOtp) return;

    final otp = _generate6DigitOtp();

    setState(() {
      _newGeneratedOtp = otp;
    });

    await fcmService.sendNotification(
      recipientFCMToken: ownerToken,
      title: "Verify New Mobile Number",
      body: "Your OTP is $otp (valid for 40 seconds)",
    );

    _startNewOtpTimer();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("OTP sent to notification")));
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  void dispose() {
    _otpTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    String savedCountryCode = await SharedPrefServices.getCountryCode() ?? "IN";
    String savedNumber = await SharedPrefServices.getNumber() ?? "";

    setState(() {
      selectedCountry = Country.parse(savedCountryCode);
      phoneController.text = savedNumber;
    });
  }

  Future<void> _updateMobileAndLogout() async {
    try {
      String? userId = await SharedPrefServices.getUserId();
      if (userId == null || userId.isEmpty) {
        throw Exception("User not found");
      }

      final query =
          await FirebaseFirestore.instance
              .collection("users")
              .where("userId", isEqualTo: userId)
              .get();

      if (query.docs.isEmpty) {
        throw Exception("User document not found");
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(query.docs.first.id)
          .update({
            "phone": newPhoneController.text.trim(),
            "countryCode": selectedCountry!.countryCode,
          });

      await FirebaseAuth.instance.signOut();
      await SharedPrefServices.clearUserFromSharedPrefs();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mobile number updated. Please login again."),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _startOtpValidityTimer() {
    _otpTimer?.cancel();

    setState(() {
      _secondsLeft = 40;
      _canGenerateOtp = false;
      _isOtpExpired = false;
      _otpVerified = false;
    });

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
        setState(() {
          _isOtpExpired = true;
          _canGenerateOtp = true;
          _otpVerified = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP expired. Please try again.")),
        );
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: kwhiteColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
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
                text: localizations.updateMobileNumber,
                textcolor: KblackColor,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),

      body:
          selectedCountry == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),

                        PhoneNumberInputField(
                          readOnly: true,
                          controller: phoneController,
                          selectedCountry: selectedCountry!,
                          onCountryChanged: (_) {},
                        ),

                        const SizedBox(height: 15),

                        CustomText(
                          text: localizations.generateOtpInfo,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          textcolor: KblackColor,
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap:
                                (!_canGenerateOtp || _isLoading)
                                    ? null
                                    : () async {
                                      setState(() => _isLoading = true);

                                      String phoneNumberWithCode =
                                          "+${selectedCountry!.phoneCode}${phoneController.text.trim()}";

                                      await FirebaseAuth.instance
                                          .verifyPhoneNumber(
                                            phoneNumber: phoneNumberWithCode,
                                            timeout: const Duration(
                                              seconds: 40,
                                            ),

                                            verificationCompleted: (_) {},

                                            verificationFailed: (e) {
                                              setState(
                                                () => _isLoading = false,
                                              );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    e.message ?? "OTP failed",
                                                  ),
                                                ),
                                              );
                                            },

                                            codeSent: (
                                              verificationId,
                                              resendToken,
                                            ) {
                                              setState(() {
                                                _verificationId =
                                                    verificationId;
                                                _isLoading = false;
                                              });

                                              _startOtpValidityTimer();

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text("OTP sent"),
                                                ),
                                              );
                                            },

                                            codeAutoRetrievalTimeout: (
                                              verificationId,
                                            ) {
                                              _verificationId = verificationId;
                                            },
                                          );
                                    },
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: korangeColor,
                                      ),
                                    )
                                    : CustomText(
                                      text:
                                          !_canGenerateOtp
                                              ? "${localizations.generateOtpIn} 00:${_secondsLeft.toString().padLeft(2, '0')}"
                                              : localizations.generateOtp,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      textcolor:
                                          !_canGenerateOtp
                                              ? Colors.grey
                                              : korangeColor,
                                    ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Pinput(
                          controller: otpController,
                          length: 6,
                          keyboardType: TextInputType.number,
                          defaultPinTheme: _pinTheme(),
                          focusedPinTheme: _focusedPinTheme(),

                          onCompleted: (pin) async {
                            if (_isOtpExpired) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "OTP expired. Please generate a new OTP.",
                                  ),
                                ),
                              );
                              return;
                            }

                            try {
                              final credential = PhoneAuthProvider.credential(
                                verificationId: _verificationId!,
                                smsCode: pin,
                              );

                              await FirebaseAuth.instance.signInWithCredential(
                                credential,
                              );

                              setState(() {
                                _otpVerified = true;
                                _canGenerateOtp = false;
                                _secondsLeft = 0;
                              });

                              _otpTimer?.cancel();
                            } catch (_) {
                              setState(() => _otpVerified = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Invalid OTP")),
                              );
                            }
                          },
                        ),

                        if (_otpVerified) ...[
                          const SizedBox(height: 20),

                          CustomText(
                            text: localizations.enterNewMobileNumber,
                            textcolor: KblackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),

                          const SizedBox(height: 10),

                          PhoneNumberInputField(
                            readOnly: false,
                            controller: newPhoneController,
                            selectedCountry: selectedCountry!,
                            onCountryChanged: (_) {},
                          ),
                          const SizedBox(height: 10),

                          GestureDetector(
                            onTap:
                                newPhoneController.text.trim().isEmpty ||
                                        _isGeneratingNewOtp
                                    ? null
                                    : () async {
                                      print("NEW OTP BUTTON CLICKED");

                                      setState(
                                        () => _isGeneratingNewOtp = true,
                                      );

                                      await _sendNewOtpViaNotification(
                                        SharedPrefServices.getfcmToken()
                                            .toString(),
                                      );

                                      setState(
                                        () => _isGeneratingNewOtp = false,
                                      );
                                    },

                            child: Align(
                              alignment: Alignment.centerRight,
                              child:
                                  _isGeneratingNewOtp
                                      ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: korangeColor,
                                        ),
                                      )
                                      : CustomText(
                                        text:
                                            !_canGenerateNewOtp
                                                ? "${localizations.generateOtpIn} 00:${_newOtpSecondsLeft.toString().padLeft(2, '0')}"
                                                : localizations
                                                    .generateOtpVerifyNew,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        textcolor:
                                            !_canGenerateNewOtp
                                                ? Colors.grey
                                                : korangeColor,
                                      ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Pinput(
                            controller: newOTPController,
                            length: 6,
                            keyboardType: TextInputType.number,
                            defaultPinTheme: _pinTheme(),
                            focusedPinTheme: _focusedPinTheme(),

                            onCompleted: (pin) {
                              if (_isNewOtpExpired) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "OTP expired. Generate again.",
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (pin == _newGeneratedOtp) {
                                setState(() => _newOtpVerified = true);
                              } else {
                                setState(() => _newOtpVerified = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Invalid OTP")),
                                );
                              }
                            },
                          ),
                        ],

                        const SizedBox(height: 30),

                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                child: CustomCancelButton(
                                  text: localizations.cancel,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                child: CustomButton(
                                  text: localizations.update,

                                  onPressed:
                                      !_newOtpVerified || _isUpdating
                                          ? null
                                          : () async {
                                            setState(() => _isUpdating = true);
                                            await _updateMobileAndLogout();
                                            setState(() => _isUpdating = false);
                                          },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (_isUpdating)
                    const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(korangeColor),
                      ),
                    ),
                ],
              ),
    );
  }

  PinTheme _pinTheme() {
    return PinTheme(
      width: 45,
      height: 50,
      textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5),
    );
  }

  PinTheme _focusedPinTheme() {
    return _pinTheme().copyDecorationWith(
      border: Border.all(color: korangeColor, width: 2),
    );
  }
}
