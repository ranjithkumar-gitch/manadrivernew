// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:mana_driver/Driver/DriverLogin/addBankAccount.dart';
// import 'package:mana_driver/Driver/Widgets/D_customTextfield.dart';

// import 'package:mana_driver/Widgets/colors.dart';
// import 'package:mana_driver/Widgets/customButton.dart';
// import 'package:mana_driver/Widgets/customText.dart';

// import 'package:mana_driver/l10n/app_localizations.dart';

// class DriverRegistrationPage extends StatefulWidget {
//   const DriverRegistrationPage({super.key});

//   @override
//   State<DriverRegistrationPage> createState() => _DriverRegistrationPageState();
// }

// class _DriverRegistrationPageState extends State<DriverRegistrationPage> {
//   bool isSaving = false;

//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context)!;
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0),
//           child: Container(color: Colors.grey.shade300, height: 1.0),
//         ),
//         title: Padding(
//           padding: const EdgeInsets.only(bottom: 10.0, top: 5),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: Image.asset(
//                     "images/chevronLeft.png",
//                     width: 24,
//                     height: 24,
//                   ),
//                 ),
//               ),
//               Center(
//                 child: CustomText(
//                   text: "Basic Information",
//                   textcolor: KblackColor,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 22,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),

//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         CircleAvatar(
//                           radius: 55,
//                           backgroundColor: KlightgreyColor,
//                           backgroundImage: null,
//                         ),
//                         Positioned(
//                           right: 0,
//                           bottom: 0,
//                           child: CircleAvatar(
//                             backgroundColor: korangeColor,
//                             radius: 18,
//                             child: Image.asset("images/camera.png"),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   D_CustomTextField(labelText: localizations.p_firstName),
//                   const SizedBox(height: 10),

//                   D_CustomTextField(labelText: localizations.p_lastName),
//                   const SizedBox(height: 10),

//                   D_CustomTextField(labelText: localizations.p_email),
//                   const SizedBox(height: 10),

//                   D_CustomTextField(
//                     labelText: localizations.p_phoneNumner,
//                     readOnly: true,
//                     suffix: Text(
//                       localizations.p_verified,
//                       style: const TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // D_CustomTextField(
//                   //   labelText: "Date of Birth",
//                   //   // controller: dobController,
//                   // ),
//                   // 1. Create a controller at the top of your state class

//                   // 2. Use the controller in your DOB field
//                   SizedBox(
//                     height: 75,
//                     child: D_CustomTextField(
//                       // controller: dobController, // connect controller
//                       labelText: "Date of Birth",
//                       readOnly: false,
//                       suffix: IconButton(
//                         icon: const Icon(
//                           Icons.calendar_today,
//                           color: Colors.grey,
//                           size: 20,
//                         ),
//                         onPressed: () async {
//                           final DateTime? picked = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime(1900),
//                             lastDate: DateTime.now(),
//                           );
//                           if (picked != null) {
//                             // dobController.text =
//                             //     "${picked.day}/${picked.month}/${picked.year}";
//                           }
//                         },
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),
//                   Divider(color: Colors.grey.shade400, thickness: 1),

//                   const SizedBox(height: 10),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const CustomText(
//                         text: "Preferences",
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         textcolor: korangeColor,
//                       ),
//                       const SizedBox(height: 10),

//                       DropdownButtonFormField<String>(
//                         decoration: InputDecoration(
//                           labelText: "Vehicle Type",
//                           contentPadding: const EdgeInsets.symmetric(
//                             vertical: 14,
//                             horizontal: 12,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide(color: kseegreyColor),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide(color: kseegreyColor),
//                           ),
//                         ),
//                         items:
//                             ["Light", "Medium", "Heavy"].map((String type) {
//                               return DropdownMenuItem<String>(
//                                 value: type,
//                                 child: Text(type),
//                               );
//                             }).toList(),
//                         onChanged: (value) {},
//                       ),

//                       const SizedBox(height: 10),

//                       D_CustomTextField(labelText: "Driving Licence Number"),
//                     ],
//                   ),

//                   const SizedBox(height: 20),
//                   const CustomText(
//                     text: "Upload Documents",
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     textcolor: korangeColor,
//                   ),

//                   const SizedBox(height: 15),
//                   DottedBorder(
//                     options: RoundedRectDottedBorderOptions(
//                       dashPattern: [6, 3],
//                       strokeWidth: 0.5,
//                       color: kgreyColor,
//                       padding: EdgeInsets.all(8),
//                       radius: const Radius.circular(12),
//                     ),
//                     child: Container(
//                       height: 120,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(
//                         child: CircleAvatar(
//                           radius: 30,
//                           backgroundColor: kseegreyColor,
//                           child: Icon(
//                             Icons.upload_file,
//                             size: 30,
//                             color: kwhiteColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 40),
//                   Center(
//                     child: CustomButton(
//                       text: "Continue",
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => AddBankAccount()),
//                         );
//                       },
//                       width: double.infinity,
//                       height: 50,
//                     ),
//                   ),

//                   const SizedBox(height: 100),
//                 ],
//               ),
//             ),
//           ),
//           if (isSaving)
//             Center(child: CircularProgressIndicator(color: korangeColor)),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mana_driver/Driver/D_Models/Driver_ViewModel.dart';
import 'package:mana_driver/Driver/DriverLogin/addBankAccount.dart';

import 'package:mana_driver/Driver/Widgets/D_customTextfield.dart';
import 'package:mana_driver/Widgets/colors.dart';

import 'package:intl/intl.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class DriverRegistrationPage extends StatefulWidget {
  const DriverRegistrationPage({super.key});

  @override
  State<DriverRegistrationPage> createState() => _DriverRegistrationPageState();
}

class _DriverRegistrationPageState extends State<DriverRegistrationPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final licenceController = TextEditingController();
  final otpController = TextEditingController();

  String? vehicleType;
  File? profileImage;
  File? licenceFront;
  File? licenceBack;
  bool showOtpField = false;
  bool isPhoneVerified = false;
  Future<void> _pickImage(Function(File) onPicked) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) onPicked(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    return Scaffold(
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
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.chevron_left, size: 28),
                ),
              ),
              const Center(
                child: Text(
                  "Basic Information",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Profile Image
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage:
                              profileImage != null
                                  ? FileImage(profileImage!)
                                  : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: () async {
                              await _pickImage(
                                (f) => setState(() => profileImage = f),
                              );
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 18,
                              child: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  D_CustomTextField(
                    labelText: "First Name",
                    controller: firstNameController,
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 10),
                  D_CustomTextField(
                    labelText: "Last Name",
                    controller: lastNameController,
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 10),
                  D_CustomTextField(
                    labelText: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 10),
                  // D_CustomTextField(
                  //   labelText: "Phone Number",
                  //   controller: phoneController,
                  // ),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      suffixIcon:
                          isPhoneVerified
                              ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      final number = value;
                      if (number.length == 10 && !showOtpField) {
                        setState(() => showOtpField = true);
                      } else if (number.length < 10 && showOtpField) {
                        setState(() {
                          showOtpField = false;
                          isPhoneVerified = false;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 10),
                  if (showOtpField)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Pinput(
                        controller: otpController,
                        length: 4,
                        onCompleted: (pin) {
                          if (pin == "1234") {
                            setState(() => isPhoneVerified = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Phone Verified ✅")),
                            );
                          } else {
                            setState(() => isPhoneVerified = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Invalid OTP ❌")),
                            );
                          }
                        },
                      ),
                    ),

                  const SizedBox(height: 10),

                  /// Date Picker
                  TextField(
                    controller: dobController,
                    readOnly: true,
                    keyboardType: TextInputType.datetime,

                    decoration: InputDecoration(
                      labelText: "Date of Birth",

                      labelStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFD5D7DA)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFD5D7DA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: kbordergreyColor,
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            dobController.text = DateFormat(
                              "dd-MM-yyyy",
                            ).format(picked);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  const Text(
                    "Preferences",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Vehicle Type",
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFD5D7DA)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFD5D7DA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: kbordergreyColor,
                          width: 2,
                        ),
                      ),
                    ),
                    value: vehicleType,
                    items:
                        ["Light", "Medium", "Heavy"].map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (value) => setState(() => vehicleType = value),
                  ),

                  const SizedBox(height: 10),
                  D_CustomTextField(
                    labelText: "Driving Licence Number",
                    controller: licenceController,
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Upload Documents",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await _pickImage(
                              (f) => setState(() => licenceFront = f),
                            );
                          },
                          child: DottedBorder(
                            options: const RoundedRectDottedBorderOptions(
                              dashPattern: [6, 3],
                              strokeWidth: 0.5,
                              color: Colors.grey,
                              padding: EdgeInsets.all(8),
                              radius: Radius.circular(12),
                            ),
                            child: Container(
                              height: 120,
                              alignment: Alignment.center,
                              child:
                                  licenceFront != null
                                      ? Image.file(
                                        licenceFront!,
                                        fit: BoxFit.cover,
                                      )
                                      : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.upload_file,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Upload Front",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await _pickImage(
                              (f) => setState(() => licenceBack = f),
                            );
                          },
                          child: DottedBorder(
                            options: const RoundedRectDottedBorderOptions(
                              dashPattern: [6, 3],
                              strokeWidth: 0.5,
                              color: Colors.grey,
                              padding: EdgeInsets.all(8),
                              radius: Radius.circular(12),
                            ),
                            child: Container(
                              height: 120,
                              alignment: Alignment.center,
                              child:
                                  licenceBack != null
                                      ? Image.file(
                                        licenceBack!,
                                        fit: BoxFit.cover,
                                      )
                                      : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.upload_file,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Upload Back",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // D_CustomTextField(
                  //   labelText: "Enter OTP",
                  //   controller: otpController,
                  // ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!vm.verifyOtp(otpController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid OTP. Try 1234."),
                            ),
                          );
                          return;
                        }

                        vm.isLoading = true; // start loader
                        vm.notifyListeners();

                        try {
                          // Fill driver model
                          vm.driver.firstName = firstNameController.text;
                          vm.driver.lastName = lastNameController.text;
                          vm.driver.email = emailController.text;
                          vm.driver.phone = phoneController.text;
                          vm.driver.dob = dobController.text;
                          vm.driver.vehicleType = vehicleType;
                          vm.driver.licenceNumber = licenceController.text;
                          vm.driver.roleCode = "Driver";

                          // Upload images
                          if (profileImage != null) {
                            vm.driver.profileUrl = await vm.uploadImage(
                              profileImage!,
                              "drivers/${vm.driver.phone}_profile.jpg",
                            );
                          }
                          if (licenceFront != null) {
                            vm.driver.licenceFrontUrl = await vm.uploadImage(
                              licenceFront!,
                              "drivers/${vm.driver.phone}_licence_front.jpg",
                            );
                          }
                          if (licenceBack != null) {
                            vm.driver.licenceBackUrl = await vm.uploadImage(
                              licenceBack!,
                              "drivers/${vm.driver.phone}_licence_back.jpg",
                            );
                          }

                          // Navigate to bank account page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddBankAccount(),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
                        } finally {
                          vm.isLoading = false; // stop loader
                          vm.notifyListeners();
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: korangeColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          if (vm.isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
        ],
      ),
    );
  }
}
