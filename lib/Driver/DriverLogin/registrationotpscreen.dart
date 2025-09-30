import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mana_driver/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:mana_driver/Driver/D_Models/Driver_Model.dart';
import 'package:mana_driver/Driver/D_Models/Driver_ViewModel.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../SharedPreferences/shared_preferences.dart';

class DriverOtpScreen extends StatefulWidget {
  final String firstName,
      lastName,
      email,
      phoneNumber,
      dob,
      vehicleType,
      licenceNumber;
  final File? profileImage, licenceFront, licenceBack;
  final String holderName, accountNumber, ifsc, bankName, branchName;

  const DriverOtpScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.vehicleType,
    required this.licenceNumber,
    this.profileImage,
    this.licenceFront,
    this.licenceBack,
    required this.holderName,
    required this.accountNumber,
    required this.ifsc,
    required this.bankName,
    required this.branchName,
  });

  @override
  State<DriverOtpScreen> createState() => _DriverOtpScreenState();
}

class _DriverOtpScreenState extends State<DriverOtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  Future<void> _verifyOtp() async {
    if (otpController.text.trim() != "1234") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
      return;
    }

    setState(() => isLoading = true);

    try {
      final vm = Provider.of<DriverViewModel>(context, listen: false);

      final now = DateTime.now();
      final formattedId = "Driver_${DateFormat('yyyyMMddHHmmss').format(now)}";
      vm.driver.userId = formattedId;

      vm.driver.firstName = widget.firstName;
      vm.driver.lastName = widget.lastName;
      vm.driver.email = widget.email;
      vm.driver.phone = widget.phoneNumber;
      vm.driver.dob = widget.dob;
      vm.driver.vehicleType = widget.vehicleType;
      vm.driver.licenceNumber = widget.licenceNumber;
      vm.driver.roleCode = "Driver";

      if (widget.profileImage != null) {
        vm.driver.profileUrl = await vm.uploadImage(
          widget.profileImage!,
          "drivers/${vm.driver.phone}_profile.jpg",
        );
      }
      if (widget.licenceFront != null) {
        vm.driver.licenceFrontUrl = await vm.uploadImage(
          widget.licenceFront!,
          "drivers/${vm.driver.phone}_licence_front.jpg",
        );
      }
      if (widget.licenceBack != null) {
        vm.driver.licenceBackUrl = await vm.uploadImage(
          widget.licenceBack!,
          "drivers/${vm.driver.phone}_licence_back.jpg",
        );
      }

      vm.driver.bankAccount = BankAccount(
        holderName: widget.holderName,
        accountNumber: widget.accountNumber,
        ifsc: widget.ifsc,
        bankName: widget.bankName,
        branch: widget.branchName,
      );

      final docRef = await vm.saveDriver();

      await SharedPrefServices.setRoleCode("Driver");
      await SharedPrefServices.setUserId(vm.driver.userId ?? "");
      await SharedPrefServices.setProfileImage(vm.driver.profileUrl ?? "");
      await SharedPrefServices.setFirstName(widget.firstName);
      await SharedPrefServices.setLastName(widget.lastName);
      await SharedPrefServices.setEmail(widget.email);
      await SharedPrefServices.setNumber(widget.phoneNumber);
      await SharedPrefServices.setCountryCode("+91"); // fixed India code
      await SharedPrefServices.setDOB(widget.dob);
      await SharedPrefServices.setvehicleType(widget.vehicleType);
      await SharedPrefServices.setdrivingLicence(widget.licenceNumber);
      await SharedPrefServices.setlicenceFront(vm.driver.licenceFrontUrl ?? "");
      await SharedPrefServices.setlicenceBack(vm.driver.licenceBackUrl ?? "");

      await SharedPrefServices.setbankNmae(widget.bankName);
      await SharedPrefServices.setaccountNumber(widget.accountNumber);
      await SharedPrefServices.setaccountHolderName(widget.holderName);
      await SharedPrefServices.setbranchName(widget.branchName);
      await SharedPrefServices.setifscCode(widget.ifsc);

      await SharedPrefServices.setislogged(true);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => D_BottomNavigation()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
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
                    isLoading
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
