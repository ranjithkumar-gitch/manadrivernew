import 'package:cloud_firestore/cloud_firestore.dart';
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

  bool isValidEmail(String email) {
    final pattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return pattern.hasMatch(email.trim());
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
        child: Center(
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

                vm.isLoading
                    ? const CircularProgressIndicator(color: korangeColor)
                    : CustomButton(
                      text: localizations.registerAsUser,
                      onPressed: () async {
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
                              content: Text(localizations.validFirstName),
                            ),
                          );
                          return;
                        }

                        if (!isValidName(lastName)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.validLastName),
                            ),
                          );
                          return;
                        }

                        // if (!isValidEmail(email)) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text(
                        //         "Please enter a valid email address",
                        //       ),
                        //     ),
                        //   );
                        //   return;
                        // }

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

                        try {
                          final ownerSnap =
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .where('phone', isEqualTo: phone)
                                  .limit(1)
                                  .get();

                          if (ownerSnap.docs.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                                      onPressed: () => Navigator.pop(context),
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
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                                    localizations.mobileRegisteredDriver,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
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

                          if (mounted) {
                            final token =
                                await FirebaseMessaging.instance.getToken();
                            print('FCM Token on login: $token');
                            String? fcmToken = token;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => OtpScreen(
                                      fcmToken: fcmToken ?? "",
                                      phoneNumber: phoneController.text.trim(),
                                      firstName: firstName,
                                      lastName: lastName,
                                      email: email,
                                      countryCode: selectedCountry.countryCode,
                                      isTestOtp: true,
                                    ),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
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
      ),
    );
  }
}
