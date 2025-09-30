import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mana_driver/Driver/D_Models/Driver_ViewModel.dart';
import 'package:mana_driver/Driver/DriverLogin/registrationotpscreen.dart';
import 'package:mana_driver/Driver/Widgets/D_customTextfield.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/mobileNumberInputField.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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

  final holderController = TextEditingController();
  final accountController = TextEditingController();
  final ifscController = TextEditingController();
  final bankController = TextEditingController();
  final branchController = TextEditingController();

  String? vehicleType;
  File? profileImage;
  File? licenceFront;
  File? licenceBack;
  bool isAgreed = false;

  Future<void> _pickImage(Function(File) onPicked) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) onPicked(File(picked.path));
  }

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
        title: const Padding(
          padding: EdgeInsets.only(bottom: 10.0, top: 5),
          child: Text(
            "Basic Information",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
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
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    labelText: "Last Name",
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    labelText: "Email",
                    controller: emailController,
                  ),
                  const SizedBox(height: 10),
                  PhoneNumberInputField(
                    controller: phoneController,
                    selectedCountry: selectedCountry,
                    onCountryChanged: (Country country) {
                      setState(() {
                        selectedCountry = country;
                      });
                    },
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Date of Birth",
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today, size: 20),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const Text(
                    "Preferences",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: korangeColor,
                    ),
                  ),

                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: vehicleType,
                    items:
                        ["Light", "Medium", "Heavy"].map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (value) => setState(() => vehicleType = value),
                    decoration: InputDecoration(
                      labelText: "Vehicle Type",
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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
                      color: korangeColor,
                    ),
                  ),

                  const SizedBox(height: 15),
                  Card(
                    color: kwhiteColor,

                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Upload driver licence",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: korangeColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap:
                                      () async => await _pickImage(
                                        (f) => setState(() => licenceFront = f),
                                      ),
                                  child: DottedBorder(
                                    options:
                                        const RoundedRectDottedBorderOptions(
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
                                              : const Text("Upload Front"),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap:
                                      () async => await _pickImage(
                                        (f) => setState(() => licenceBack = f),
                                      ),
                                  child: DottedBorder(
                                    options:
                                        const RoundedRectDottedBorderOptions(
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
                                              : const Text("Upload Back"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const Text(
                    "Bank Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: korangeColor,
                    ),
                  ),

                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: holderController,
                    labelText: "Account Holder Name",
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: accountController,
                    labelText: "Account Number",
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: ifscController,
                    labelText: "IFSC Code",
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: bankController,
                    labelText: "Bank Name",
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: branchController,
                    labelText: "Branch Name",
                  ),

                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isAgreed,
                        onChanged:
                            (value) =>
                                setState(() => isAgreed = value ?? false),
                      ),
                      Expanded(
                        child: Text(
                          "I agree to the collection and use of my information as described in the Privacy Policy.",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_validateInputs()) return;

                        final phone = phoneController.text.trim();

                        try {
                          final driverSnap =
                              await FirebaseFirestore.instance
                                  .collection('drivers')
                                  .where('phone', isEqualTo: phone)
                                  .limit(1)
                                  .get();

                          if (driverSnap.docs.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Mobile number already exists as Driver",
                                ),
                              ),
                            );
                            return;
                          }

                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => DriverOtpScreen(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      email: emailController.text,
                                      phoneNumber: phone,
                                      countryCode: selectedCountry.countryCode,
                                      dob: dobController.text,
                                      vehicleType: vehicleType ?? "",
                                      licenceNumber: licenceController.text,
                                      profileImage: profileImage,
                                      licenceFront: licenceFront,
                                      licenceBack: licenceBack,
                                      holderName: holderController.text,
                                      accountNumber: accountController.text,
                                      ifsc: ifscController.text,
                                      bankName: bankController.text,
                                      branchName: branchController.text,
                                    ),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
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

  bool _validateInputs() {
    if (firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter first name")));
      return false;
    }
    if (lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter last name")));
      return false;
    }

    if (emailController.text.isEmpty ||
        !RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}',
        ).hasMatch(emailController.text)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter valid email")));
      return false;
    }
    if (phoneController.text.isEmpty ||
        phoneController.text.length < 10 ||
        phoneController.text.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid phone number")),
      );
      return false;
    }
    if (dobController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date of birth")),
      );
      return false;
    }
    if (vehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select vehicle type")),
      );
      return false;
    }
    if (licenceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter licence number")),
      );
      return false;
    }
    if (profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload profile image")),
      );
      return false;
    }
    if (licenceFront == null || licenceBack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload licence images")),
      );
      return false;
    }
    if (holderController.text.isEmpty ||
        accountController.text.isEmpty ||
        ifscController.text.isEmpty ||
        bankController.text.isEmpty ||
        branchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all bank details")),
      );
      return false;
    }
    if (!isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept privacy policy")),
      );
      return false;
    }
    return true;
  }
}
