import 'package:flutter/material.dart';
import 'package:mana_driver/Driver/D_Models/Driver_ViewModel.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customTextField.dart';
import 'package:mana_driver/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController licenceController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();

  final TextEditingController holderController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  String? profileUrl;
  String? licenceFrontUrl;
  String? licenceBackUrl;

  @override
  void initState() {
    super.initState();
    _loadDriverDetails();
  }

  Future<void> _loadDriverDetails() async {
    final vm = Provider.of<DriverViewModel>(context, listen: false);
    final driver = vm.driver;

    firstnameController.text = driver.firstName ?? '';
    lastnameController.text = driver.lastName ?? '';
    emailController.text = driver.email ?? '';
    phoneController.text = driver.phone ?? '';
    dobController.text = driver.dob ?? '';
    licenceController.text = driver.licenceNumber ?? '';
    vehicleController.text = driver.vehicleType ?? '';

    profileUrl = driver.profileUrl;
    licenceFrontUrl = driver.licenceFrontUrl;
    licenceBackUrl = driver.licenceBackUrl;

    if (driver.bankAccount != null) {
      holderController.text = driver.bankAccount!.holderName ?? '';
      accountController.text = driver.bankAccount!.accountNumber ?? '';
      ifscController.text = driver.bankAccount!.ifsc ?? '';
      bankController.text = driver.bankAccount!.bankName ?? '';
      branchController.text = driver.bankAccount!.branch ?? '';
    }

    setState(() {}); // refresh UI
  }

  String _getUserInitials() {
    final first = SharedPrefServices.getFirstName() ?? '';
    final last = SharedPrefServices.getLastName() ?? '';

    String firstInitial = first.isNotEmpty ? first[0].toUpperCase() : '';
    String lastInitial = last.isNotEmpty ? last[0].toUpperCase() : '';

    return firstInitial + lastInitial;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1, color: Colors.grey),
        ),
        title: Center(
          child: Text(
            localizations.profile,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: KlightgreyColor,
                    backgroundImage:
                        (SharedPrefServices.getProfileImage() ?? '').isNotEmpty
                            ? NetworkImage(
                              SharedPrefServices.getProfileImage()!,
                            )
                            : null,
                    child:
                        (SharedPrefServices.getProfileImage() ?? '').isEmpty
                            ? Text(
                              _getUserInitials(),
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFC7D5E7),
                              ),
                            )
                            : null,
                  ),

                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: korangeColor,
                      child: Image.asset("images/camera.png"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Basic Info
            CustomTextField(
              controller: firstnameController,
              labelText: localizations.p_firstName,
              readOnly: true,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: lastnameController,
              labelText: localizations.p_lastName,
              readOnly: true,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              labelText: localizations.p_email,
              readOnly: true,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: phoneController,
              labelText: localizations.p_phoneNumner,
              readOnly: true,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: dobController,
              labelText: "Date of Birth",
              readOnly: true,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: vehicleController,
              labelText: "Vehicle Type",
              readOnly: true,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: licenceController,
              labelText: "Licence Number",
              readOnly: true,
            ),
            const SizedBox(height: 20),

            // Licence images
            Row(
              children: [
                Expanded(
                  child:
                      licenceFrontUrl != null
                          ? Image.network(licenceFrontUrl!, height: 120)
                          : Container(height: 120, color: Colors.grey.shade200),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child:
                      licenceBackUrl != null
                          ? Image.network(licenceBackUrl!, height: 120)
                          : Container(height: 120, color: Colors.grey.shade200),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Bank Details
            const Text(
              "Bank Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: holderController,
              labelText: "Account Holder Name",
              readOnly: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: accountController,
              labelText: "Account Number",
              readOnly: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: ifscController,
              labelText: "IFSC",
              readOnly: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: bankController,
              labelText: "Bank Name",
              readOnly: true,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: branchController,
              labelText: "Branch",
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
