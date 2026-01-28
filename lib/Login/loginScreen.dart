import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Login/otp_login.dart';
import 'package:mana_driver/Login/registration.dart';
import 'package:mana_driver/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';
import '../services/repository.dart';
import '../viewmodels/login_viewmodel.dart';
import '../Widgets/colors.dart';
import '../Widgets/customButton.dart';
import '../Widgets/customText.dart';
import '../Widgets/mobileNumberInputField.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(RepositoryData()),
      child: const _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatefulWidget {
  const _LoginScreenBody();

  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<_LoginScreenBody> {
  final TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final vm = context.watch<LoginViewModel>();
    final state = vm.state;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        bool exitApp = await _showExitDialog(context);
        if (exitApp) {
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          Spacer(),

                          // const SizedBox(height: 40),
                          // Image.asset(
                          //   'images/nyzo_ride.png',
                          //   width: 200,
                          //   height: 200,
                          //   fit: BoxFit.contain,
                          // ),

                          // const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: localizations.loginTitle,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  textcolor: korangeColor,
                                ),

                                const SizedBox(height: 40),

                                PhoneNumberInputField(
                                  controller: phoneController,
                                  selectedCountry: vm.selectedCountry,
                                  onCountryChanged: (Country country) {
                                    vm.setCountry(country);
                                  },
                                ),

                                if (state.errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      state.errorMessage,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),
                          const Spacer(),

                          CustomButton(
                            text:
                                _isLoading
                                    ? localizations.checking
                                    : localizations.sendOtp,
                            width: 220,
                            height: 50,
                            onPressed:
                                _isLoading
                                    ? null
                                    : () async {
                                      final phoneNumber =
                                          phoneController.text.trim();
                                      final dialCode =
                                          vm.selectedCountry.phoneCode;
                                      final phoneWithCode =
                                          "+$dialCode$phoneNumber";

                                      if (phoneNumber.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Please enter mobile number",
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      setState(() => _isLoading = true);

                                      try {
                                        final exists = await _checkUserExists(
                                          phoneNumber,
                                        );

                                        if (exists) {
                                          await FirebaseAuth.instance
                                              .verifyPhoneNumber(
                                                phoneNumber: phoneWithCode,
                                                timeout: const Duration(
                                                  seconds: 60,
                                                ),
                                                verificationCompleted: (
                                                  credential,
                                                ) async {
                                                  await FirebaseAuth.instance
                                                      .signInWithCredential(
                                                        credential,
                                                      );
                                                },
                                                verificationFailed: (e) {
                                                  setState(
                                                    () => _isLoading = false,
                                                  );
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        e.message ??
                                                            "OTP failed",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                codeSent: (
                                                  verificationId,
                                                  _,
                                                ) async {
                                                  setState(
                                                    () => _isLoading = false,
                                                  );
                                                  if (!mounted) return;
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (_) => OtpLogin(
                                                            phoneNumber:
                                                                phoneNumber,
                                                            verificationId:
                                                                verificationId,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                codeAutoRetrievalTimeout:
                                                    (_) {},
                                              );
                                        } else {
                                          setState(() => _isLoading = false);
                                          showDialog(
                                            context: context,
                                            builder:
                                                (_) => AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  title: Center(
                                                    child: Text(
                                                      "New User",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: korangeColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "Please register before logging in.",
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: Text(
                                                        "OK",
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  korangeColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        }
                                      } catch (e) {
                                        setState(() => _isLoading = false);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text("Error: $e")),
                                        );
                                      }
                                    },
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: localizations.noAccount,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                textcolor: kgreyColor,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RegisterScreen(),
                                    ),
                                  );
                                },
                                child: CustomText(
                                  text: localizations.register,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textcolor: korangeColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Text(
                            'APK Release v1.0.5',
                            style: GoogleFonts.poppins(
                              color: kgreyColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              if (_isLoading)
                Center(child: CircularProgressIndicator(color: korangeColor)),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> _checkUserExists(String phoneNumber) async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();
  return snapshot.docs.isNotEmpty;
}

Future<bool> _showExitDialog(BuildContext context) async {
  return (await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Text(
                'Do you want to exit the app ?',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      color: korangeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    exit(0);
                  },
                  child: Text(
                    'Exit',
                    style: GoogleFonts.poppins(
                      color: korangeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
      )) ??
      false;
}
// SafeArea(
        //   child: Stack(
        //     children: [
        //       SingleChildScrollView(
        //         reverse: false,
        //         padding: EdgeInsets.only(
        //           bottom: MediaQuery.of(context).viewInsets.bottom,
        //         ),
        //         child: Column(
        //           children: [
        //             const SizedBox(height: 40),

        //             Image.asset(
        //               'images/nyzo_ride.png',
        //               width: 200,
        //               height: 200,
        //               fit: BoxFit.contain,
        //             ),

        //             const SizedBox(height: 40),

        //             Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 20),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   CustomText(
        //                     text: localizations.loginTitle,
        //                     fontSize: 32,
        //                     fontWeight: FontWeight.w700,
        //                     textcolor: korangeColor,
        //                   ),

        //                   const SizedBox(height: 40),

        //                   PhoneNumberInputField(
        //                     controller: phoneController,
        //                     selectedCountry: vm.selectedCountry,
        //                     onCountryChanged: (Country country) {
        //                       vm.setCountry(country);
        //                     },
        //                   ),

        //                   if (state.errorMessage.isNotEmpty)
        //                     Padding(
        //                       padding: const EdgeInsets.only(top: 8),
        //                       child: Text(
        //                         state.errorMessage,
        //                         style: const TextStyle(color: Colors.red),
        //                       ),
        //                     ),
        //                 ],
        //               ),
        //             ),

        //             const SizedBox(height: 150),

        //             CustomButton(
        //               text:
        //                   _isLoading
        //                       ? localizations.checking
        //                       : localizations.sendOtp,
        //               onPressed:
        //                   _isLoading
        //                       ? null
        //                       : () async {
        //                         final phoneNumber = phoneController.text.trim();
        //                         final dialCode = vm.selectedCountry.phoneCode;
        //                         final phoneWithCode = "+$dialCode$phoneNumber";

        //                         if (phoneNumber.isEmpty) {
        //                           ScaffoldMessenger.of(context).showSnackBar(
        //                             const SnackBar(
        //                               content: Text(
        //                                 "Please enter mobile number",
        //                               ),
        //                             ),
        //                           );
        //                           return;
        //                         }

        //                         setState(() => _isLoading = true);

        //                         try {
        //                           final exists = await _checkUserExists(
        //                             phoneNumber,
        //                           );

        //                           if (exists) {
        //                             await FirebaseAuth.instance
        //                                 .verifyPhoneNumber(
        //                                   phoneNumber: phoneWithCode,
        //                                   timeout: const Duration(seconds: 60),
        //                                   verificationCompleted: (
        //                                     credential,
        //                                   ) async {
        //                                     await FirebaseAuth.instance
        //                                         .signInWithCredential(
        //                                           credential,
        //                                         );
        //                                   },
        //                                   verificationFailed: (e) {
        //                                     setState(() => _isLoading = false);
        //                                     ScaffoldMessenger.of(
        //                                       context,
        //                                     ).showSnackBar(
        //                                       SnackBar(
        //                                         content: Text(
        //                                           e.message ?? "OTP failed",
        //                                         ),
        //                                       ),
        //                                     );
        //                                   },
        //                                   codeSent: (verificationId, _) async {
        //                                     setState(() => _isLoading = false);
        //                                     if (!mounted) return;
        //                                     Navigator.push(
        //                                       context,
        //                                       MaterialPageRoute(
        //                                         builder:
        //                                             (_) => OtpLogin(
        //                                               phoneNumber: phoneNumber,
        //                                               verificationId:
        //                                                   verificationId,
        //                                             ),
        //                                       ),
        //                                     );
        //                                   },
        //                                   codeAutoRetrievalTimeout: (_) {},
        //                                 );
        //                           } else {
        //                             setState(() => _isLoading = false);
        //                             showDialog(
        //                               context: context,
        //                               builder:
        //                                   (_) => AlertDialog(
        //                                     shape: RoundedRectangleBorder(
        //                                       borderRadius:
        //                                           BorderRadius.circular(10),
        //                                     ),
        //                                     title: Center(
        //                                       child: Text(
        //                                         "New User",
        //                                         style: GoogleFonts.poppins(
        //                                           color: korangeColor,
        //                                           fontWeight: FontWeight.w600,
        //                                         ),
        //                                       ),
        //                                     ),
        //                                     content: Text(
        //                                       "Please register before logging in.",
        //                                       style: GoogleFonts.poppins(),
        //                                     ),
        //                                     actions: [
        //                                       TextButton(
        //                                         onPressed:
        //                                             () =>
        //                                                 Navigator.pop(context),
        //                                         child: Text(
        //                                           "OK",
        //                                           style: GoogleFonts.poppins(
        //                                             color: korangeColor,
        //                                             fontWeight: FontWeight.w600,
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     ],
        //                                   ),
        //                             );
        //                           }
        //                         } catch (e) {
        //                           setState(() => _isLoading = false);
        //                           ScaffoldMessenger.of(context).showSnackBar(
        //                             SnackBar(content: Text("Error: $e")),
        //                           );
        //                         }
        //                       },
        //               width: 220,
        //               height: 50,
        //             ),

        //             const SizedBox(height: 20),

        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 CustomText(
        //                   text: localizations.noAccount,
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.w500,
        //                   textcolor: kgreyColor,
        //                 ),
        //                 GestureDetector(
        //                   onTap: () {
        //                     Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (_) => RegisterScreen(),
        //                       ),
        //                     );
        //                   },
        //                   child: CustomText(
        //                     text: localizations.register,
        //                     fontSize: 14,
        //                     fontWeight: FontWeight.w500,
        //                     textcolor: korangeColor,
        //                   ),
        //                 ),
        //               ],
        //             ),

        //             const SizedBox(height: 20),

        //             Text(
        //               'APK Release v1.0.5',
        //               style: GoogleFonts.poppins(
        //                 color: kgreyColor,
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //             ),

        //             const SizedBox(height: 10),
        //           ],
        //         ),
        //       ),

        //       if (_isLoading)
        //         Center(child: CircularProgressIndicator(color: korangeColor)),
        //     ],
        //   ),
        // ),