import 'package:flutter/material.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Sidemenu/edit_Profilescreen.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/Widgets/customTextField.dart';
import 'package:mana_driver/l10n/app_localizations.dart';

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

  // @override
  // void initState() {
  //   super.initState();
  //   final vm = context.read<LoginViewModel>();
  //   final user = vm.loggedInUser;
  //   if (user != null) {
  //     firstnameController.text = user['firstName'] ?? '';
  //     lastnameController.text = user['lastName'] ?? '';

  //     emailController.text = user['email'] ?? '';
  //     phoneController.text = user['phone'] ?? '';
  //   }
  // }
  @override
  void initState() {
    super.initState();
    _loadUserFromPrefs();
    // final vm = context.read<LoginViewModel>();
    // final user = vm.loggedInUser;
    // if (user != null) {
    //   firstnameController.text = user['firstName'] ?? '';
    //   lastnameController.text = user['lastName'] ?? '';

    //   emailController.text = user['email'] ?? '';
    //   phoneController.text = user['phone'] ?? '';
    // }
  }

  Future<void> _loadUserFromPrefs() async {
    firstnameController.text = await SharedPrefServices.getFirstName() ?? '';
    lastnameController.text = await SharedPrefServices.getLastName() ?? '';
    emailController.text = await SharedPrefServices.getEmail() ?? '';
    phoneController.text = await SharedPrefServices.getNumber() ?? '';

    setState(() {}); // update UI after assigning
  }

  String _getUserInitials() {
    final first = SharedPrefServices.getFirstName();
    final last = SharedPrefServices.getLastName();

    String firstInitial = first!.isNotEmpty ? first[0].toUpperCase() : '';
    String lastInitial = last!.isNotEmpty ? last[0].toUpperCase() : '';

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
                  child: Image.asset(
                    "images/chevronLeft.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: localizations.profile,
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: KlightgreyColor,
                    backgroundImage:
                        SharedPrefServices.getProfileImage() != null &&
                                SharedPrefServices.getProfileImage()!.isNotEmpty
                            ? NetworkImage(
                              SharedPrefServices.getProfileImage()!,
                            )
                            : null,
                    child:
                        (SharedPrefServices.getProfileImage() == null ||
                                SharedPrefServices.getProfileImage()!.isEmpty)
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

                  // Positioned(
                  //   right: 0,
                  //   bottom: 0,
                  //   child: CircleAvatar(
                  //     backgroundColor: korangeColor,
                  //     radius: 18,
                  //     child: Image.asset("images/camera.png"),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            CustomTextField(
              controller: firstnameController,
              readOnly: true,
              labelText: localizations.p_firstName,
            ),

            const SizedBox(height: 20),
            CustomTextField(
              controller: lastnameController,
              readOnly: true,
              labelText: localizations.p_lastName,
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
              suffix: Text(
                localizations.p_verified,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            const Spacer(),
            Center(
              child: CustomButton(
                text: localizations.p_editProfile,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => EditProfileScreen(
                            firstName: firstnameController.text,
                            lastName: lastnameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          ),
                    ),
                  );
                },
                width: 220,
                height: 53,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
