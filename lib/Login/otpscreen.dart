import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/l10n/app_localizations.dart';
import 'package:mana_driver/viewmodels/register_viewmodel.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

// class OtpScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String countryCode;
//   final bool isTestOtp;

//   const OtpScreen({
//     super.key,
//     required this.phoneNumber,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.countryCode,
//     this.isTestOtp = true,
//   });

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final TextEditingController otpController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _verifyOtp() async {
//     final otp = otpController.text.trim();
//     setState(() => _isLoading = true);

//     try {
//       // if (otp == "1234") {
//       //   // ✅ fetch user details and save in SharedPreferences
//       //   final vm = context.read<LoginViewModel>();
//       //   await vm.fetchLoggedInUser(widget.phoneNumber);

//       //   await SharedPrefServices.setislogged(true);

//       //   // ✅ navigate to dashboard based on role
//       //   final role = await SharedPrefServices.getRoleCode();
//       //   if (role == "Driver") {
//       //     Navigator.pushReplacement(
//       //       context,
//       //       MaterialPageRoute(builder: (_) => D_BottomNavigation()),
//       //     );
//       //   } else {
//       //     Navigator.pushReplacement(
//       //       context,
//       //       MaterialPageRoute(builder: (_) => BottomNavigation()),
//       //     );
//       //   }
//       // }
//       if (otp == "1234") {
//         // ✅ Save to Firestore after OTP verified
//         await FirebaseFirestore.instance.collection('users').add({
//           "firstName": widget.firstName,
//           "lastName": widget.lastName,
//           "email": widget.email,
//           "phone": widget.phoneNumber,
//           "countryCode": widget.countryCode,
//           "createdAt": FieldValue.serverTimestamp(),
//         });

//         // ✅ Save to SharedPreferences
//         await SharedPrefServices.setFirstName(widget.firstName);
//         await SharedPrefServices.setLastName(widget.lastName);
//         await SharedPrefServices.setEmail(widget.email);
//         await SharedPrefServices.setNumber(widget.phoneNumber);
//         await SharedPrefServices.setCountryCode(widget.countryCode);
//         await SharedPrefServices.setislogged(true);

//         // ✅ Navigate to Dashboard
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => BottomNavigation()),
//         );
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final localizations = AppLocalizations.of(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 const Spacer(),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText(
//                         text: localizations?.otpTitle ?? "Enter Your OTP",
//                         fontSize: 32,
//                         fontWeight: FontWeight.w700,
//                         textcolor: korangeColor,
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         "OTP sent to ${widget.phoneNumber}",
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: kgreyColor,
//                         ),
//                       ),
//                       const SizedBox(height: 50),
//                       Pinput(
//                         controller: otpController,
//                         length: 4,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                         ],
//                         defaultPinTheme: PinTheme(
//                           width: 60,
//                           height: 60,
//                           textStyle: GoogleFonts.poppins(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: korangeColor,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: kbordergreyColor),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           margin: const EdgeInsets.symmetric(horizontal: 10),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Spacer(),
//                 CustomButton(
//                   text: localizations?.verifyOtp ?? 'Verify OTP',
//                   onPressed: _verifyOtp,
//                   width: 220,
//                   height: 53,
//                 ),
//                 const SizedBox(height: 32),
//               ],
//             ),
//             if (_isLoading)
//               const Center(
//                 child: CircularProgressIndicator(color: korangeColor),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final bool isTestOtp;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    this.isTestOtp = true,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp != "1234") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final vm = Provider.of<RegisterViewModel>(context, listen: false);

      // Save to Firebase using RegisterViewModel
      final success = await vm.register(
        fisrtName: widget.firstName,
        lastName: widget.lastName,
        email: widget.email,
        phone: widget.phoneNumber,
        countryCode: widget.countryCode,
      );

      if (success) {
        // Save to SharedPreferences
        await SharedPrefServices.setFirstName(widget.firstName);
        await SharedPrefServices.setLastName(widget.lastName);
        await SharedPrefServices.setEmail(widget.email);
        await SharedPrefServices.setNumber(widget.phoneNumber);
        await SharedPrefServices.setCountryCode(widget.countryCode);
        await SharedPrefServices.setislogged(true);

        // ✅ Check role code and navigate accordingly
        final role = await SharedPrefServices.getRoleCode();

        if (mounted) {
          if (role == "Driver") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => D_BottomNavigation()),
            );
          } else if (role == "Owner") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => BottomNavigation()),
            );
          } else {
            // fallback if role missing
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => BottomNavigation()),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.errorMessage ?? "Registration failed")),
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
}
