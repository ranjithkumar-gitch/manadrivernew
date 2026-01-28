import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mana_driver/Login/loginScreen.dart';
import 'package:mana_driver/Login/otpscreen.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:country_picker/country_picker.dart';
import 'package:mana_driver/Widgets/customTextField.dart';
import 'package:mana_driver/Widgets/mobileNumberInputField.dart';
import 'package:mana_driver/l10n/app_localizations.dart';
import 'package:mana_driver/viewmodels/register_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:libphonenumber_plugin/libphonenumber_plugin.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "India",
    e164Key: "",
  );

  bool isValidName(String name) {
    final n = name.trim();
    return n.isNotEmpty;
  }

  bool _isLoading = false;

  bool isValidEmail(String email) {
    if (email.contains(' ')) return false;

    if (email != email.toLowerCase()) return false;

    final pattern = RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');

    return pattern.hasMatch(email);
  }

  Future<bool> isValidPhone(String phone, String countryCode) async {
    try {
      final bool? isValid = await PhoneNumberUtil.isValidPhoneNumber(
        phone,
        countryCode,
      );
      print("Phone validation result for $phone [$countryCode] → $isValid");
      return isValid ?? false;
    } catch (e) {
      print("Phone validation error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final vm = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: localizations.getStartedMinute,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      textcolor: korangeColor,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: localizations.quickSimpleRegistration,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textcolor: kgreyColor,
                    ),
                    const SizedBox(height: 50),

                    CustomTextField(
                      controller: firstnameController,
                      labelText: localizations.firstName,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: lastnameController,
                      labelText: localizations.lastName,
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: emailController,
                      labelText: localizations.emailId,
                    ),
                    const SizedBox(height: 20),

                    PhoneNumberInputField(
                      controller: phoneController,
                      selectedCountry: selectedCountry,
                      onCountryChanged: (Country country) {
                        setState(() {
                          selectedCountry = country;
                        });
                      },
                    ),
                    const SizedBox(height: 40),

                    // vm.isLoading
                    CustomButton(
                      text:
                          _isLoading
                              ? localizations.checking
                              : localizations.registerAsUser,
                      onPressed:
                          _isLoading
                              ? null
                              : () async {
                                final firstName = firstnameController.text;

                                final lastName = lastnameController.text.trim();
                                final email = emailController.text.trim();
                                final phone = phoneController.text.trim();

                                print("Entered first name: $firstName");
                                print("Entered last name: $lastName");
                                print("Entered email: $email");
                                print("Entered phone: $phone");
                                print(
                                  "Selected country: ${selectedCountry.name} (${selectedCountry.countryCode}) +${selectedCountry.phoneCode}",
                                );

                                if (!isValidName(firstName)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        localizations.validFirstName,
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (!isValidName(lastName)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        localizations.validLastName,
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                if (email.isNotEmpty && !isValidEmail(email)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please enter a valid email address",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final isValid = await isValidPhone(
                                  phone,
                                  selectedCountry.countryCode,
                                );
                                print("Phone validation result: $isValid");

                                if (!isValid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${localizations.validPhoneNumber} ${selectedCountry.name}",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                print(
                                  " All validations passed, proceeding with registration...",
                                );
                                setState(() => _isLoading = true);
                                try {
                                  final ownerSnap =
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .where('phone', isEqualTo: phone)
                                          .limit(1)
                                          .get();

                                  if (ownerSnap.docs.isNotEmpty) {
                                    setState(() => _isLoading = false);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          title: Center(
                                            child: Text(
                                              localizations.mobileNumberExists,
                                              style: GoogleFonts.poppins(
                                                color: korangeColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          content: Text(
                                            localizations.mobileRegisteredOwner,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
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
                                    return;
                                  }

                                  final driverSnap =
                                      await FirebaseFirestore.instance
                                          .collection('drivers')
                                          .where('phone', isEqualTo: phone)
                                          .limit(1)
                                          .get();

                                  if (driverSnap.docs.isNotEmpty) {
                                    setState(() => _isLoading = false);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          title: Center(
                                            child: Text(
                                              localizations.mobileNumberExists,
                                              style: GoogleFonts.poppins(
                                                color: korangeColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          content: Text(
                                            localizations
                                                .mobileRegisteredDriver,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
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
                                    return;
                                  }

                                  if (!mounted) return;

                                  final token =
                                      await FirebaseMessaging.instance
                                          .getToken();
                                  print('FCM Token on login: $token');
                                  final String? fcmToken = token;

                                  final String phoneNumberWithCode =
                                      "+${selectedCountry.phoneCode}${phoneController.text.trim()}";

                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: phoneNumberWithCode,
                                    timeout: const Duration(seconds: 40),

                                    verificationCompleted: (
                                      PhoneAuthCredential credential,
                                    ) async {
                                      // await FirebaseAuth.instance
                                      //     .signInWithCredential(credential);
                                    },

                                    verificationFailed: (
                                      FirebaseAuthException e,
                                    ) {
                                      setState(() => _isLoading = false);
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
                                      String verificationId,
                                      int? resendToken,
                                    ) async {
                                      setState(() => _isLoading = true);

                                      await Future.delayed(
                                        const Duration(milliseconds: 300),
                                      );

                                      if (!mounted) return;
                                      final String rawPhoneNumber =
                                          phoneController.text.trim();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => OtpScreen(
                                                verificationId: verificationId,
                                                fcmToken: fcmToken ?? "",
                                                phoneNumber: rawPhoneNumber,
                                                phoneNumberWithCode:
                                                    phoneNumberWithCode,
                                                firstName: firstName,
                                                lastName: lastName,
                                                email: email,
                                                countryCode:
                                                    selectedCountry.countryCode,
                                                isTestOtp: true,
                                              ),
                                        ),
                                      );

                                      setState(() => _isLoading = false);
                                    },

                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {},
                                  );
                                } catch (e) {
                                  setState(() => _isLoading = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: $e")),
                                  );
                                } finally {}
                              },

                      width: 220,
                      height: 53,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: localizations.haveAccount,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textcolor: kgreyColor,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: CustomText(
                            text: localizations.signIn,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            textcolor: korangeColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Center(child: CircularProgressIndicator(color: korangeColor)),
          ],
        ),
      ),
    );
  }
}
