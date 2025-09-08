import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Sidemenu/profilePage.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:mana_driver/Widgets/customTextField.dart';
import 'package:mana_driver/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:mana_driver/l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  const EditProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  bool isSaving = false;
  @override
  void initState() {
    super.initState();
    firstnameController = TextEditingController(text: widget.firstName);
    lastnameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    final vm = Provider.of<LoginViewModel>(context, listen: false);

    setState(() => isSaving = true);

    try {
      setState(() {
        isSaving = true;
      });
      // final userId = vm.loggedInUser?['id'];
      final userId = SharedPrefServices.getDocId();
      print("User ID: $userId");
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
              'firstName': firstnameController.text.trim(),
              'lastName': lastnameController.text.trim(),
              'email': emailController.text.trim(),
            });

        vm.updateUser({
          'firstName': firstnameController.text.trim(),
          'lastName': lastnameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BottomNavigation()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    } finally {
      setState(() {
        isSaving = false;
      });
    }
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
      resizeToAvoidBottomInset: true,
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
                  text: localizations.p_editProfile,
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
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
                                      SharedPrefServices.getProfileImage()!
                                          .isNotEmpty
                                  ? NetworkImage(
                                    SharedPrefServices.getProfileImage()!,
                                  )
                                  : null,
                          child:
                              (SharedPrefServices.getProfileImage() == null ||
                                      SharedPrefServices.getProfileImage()!
                                          .isEmpty)
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
                            backgroundColor: korangeColor,
                            radius: 18,
                            child: Image.asset("images/camera.png"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: firstnameController,
                    labelText: localizations.p_firstName,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: lastnameController,
                    labelText: localizations.p_lastName,
                  ),

                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: emailController,
                    labelText: localizations.p_email,
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

                  SizedBox(height: 100),
                  Center(
                    child: CustomButton(
                      text:
                          isSaving
                              ? localizations.menuSaving
                              : localizations.menuSave,
                      onPressed: isSaving ? null : saveProfile,
                      width: double.infinity,
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSaving)
            Center(child: CircularProgressIndicator(color: korangeColor)),
        ],
      ),
    );
  }
}
