import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Login/loginScreen.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Sidemenu/aboutManaDriver.dart';
import 'package:mana_driver/Sidemenu/cancellationPolicyScreen.dart';
import 'package:mana_driver/Sidemenu/favoriteDriverScreen.dart';
import 'package:mana_driver/Sidemenu/helpAndSupportScreen.dart';
import 'package:mana_driver/Sidemenu/myAddressScreen.dart';
import 'package:mana_driver/Sidemenu/offersScreen.dart';
import 'package:mana_driver/Sidemenu/privacy_policy.dart';
import 'package:mana_driver/Sidemenu/profilePage.dart';
import 'package:mana_driver/Sidemenu/referScreen.dart';
import 'package:mana_driver/Sidemenu/termsAndConditions.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customButton.dart';
import 'package:mana_driver/Widgets/customText.dart';

import 'package:mana_driver/Widgets/customoutlinedbutton.dart';
import 'package:mana_driver/Widgets/mobileNumberInputField.dart';
import 'package:mana_driver/l10n/app_localizations.dart';

import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:mana_driver/services/locale_provider.dart';

class MenuScreen_copy extends StatefulWidget {
  const MenuScreen_copy({super.key});

  @override
  State<MenuScreen_copy> createState() => _MenuScreen_copyState();
}

class _MenuScreen_copyState extends State<MenuScreen_copy> {
  String selectedLanguage = 'English';

  final List<Map<String, dynamic>> menuItems = [
    {'image': 'images/address.png', 'title': 'My Address'},
    {'image': 'images/favorite.png', 'title': 'Favourite Drivers'},
    {'image': 'images/update.png', 'title': 'Update Mobile Number'},
    {'image': 'images/language.png', 'title': 'App language'},
    {'image': 'images/offers.png', 'title': 'Offers'},
    {'image': 'images/refer.png', 'title': 'Refer a Friend'},
    {'image': 'images/info.png', 'title': 'Terms & Conditions'},
    {'image': 'images/support.png', 'title': 'Help & Support'},
    {'image': 'images/policy.png', 'title': 'Cancellation policy'},
    {'image': 'images/aboutMD.png', 'title': 'About Rydyn'},
    {'image': 'images/delete_acnt.png', 'title': 'Delete Account'},
    {'image': 'images/logout.png', 'title': 'Logout'},
  ];

  // @override
  // void instate() {
  //   super.initState();
  //   //  getProfileData();
  // }

  String maskEmail(String email) {
    if (email.isEmpty) return "";

    final parts = email.split("@");
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 3) {
      return username + "*****@" + domain;
    } else {
      return username.substring(0, 3) + "*****@" + domain;
    }
  }

  String _getUserInitials() {
    final first = SharedPrefServices.getFirstName();
    final last = SharedPrefServices.getLastName();

    String firstInitial = first!.isNotEmpty ? first[0].toUpperCase() : '';
    String lastInitial = last!.isNotEmpty ? last[0].toUpperCase() : '';

    return firstInitial + lastInitial;
  }

  Widget _buildProfileTile() {
    return InkWell(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: KlightgreyColor,
            backgroundImage:
                SharedPrefServices.getProfileImage() != null &&
                        SharedPrefServices.getProfileImage()!.isNotEmpty
                    ? NetworkImage(SharedPrefServices.getProfileImage()!)
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

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  SharedPrefServices.getEmail().toString().isEmpty
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.start,
              mainAxisAlignment:
                  SharedPrefServices.getEmail().toString().isEmpty
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.start,
              children: [
                CustomText(
                  text:
                      "${SharedPrefServices.getFirstName()} ${SharedPrefServices.getLastName()}",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textcolor: korangeColor,
                ),

                if (SharedPrefServices.getEmail().toString().isNotEmpty) ...[
                  SizedBox(height: 4),
                  CustomText(
                    text: maskEmail(SharedPrefServices.getEmail().toString()),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    textcolor: kseegreyColor,
                  ),
                ],
              ],
            ),
          ),

          Image.asset("images/chevronRight.png", width: 20),
        ],
      ),
    );
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // final vm = context.watch<LoginViewModel>();
    // final userName =
    //     "${vm.loggedInUser?['firstName'] ?? ''} ${vm.loggedInUser?['lastName'] ?? ''}"
    //         .trim();

    // final userEmail = vm.loggedInUser?['email'] ?? "";
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // double screenWidth = constraints.maxWidth;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildProfileTile(),
                      const Divider(color: KdeviderColor),

                      const Divider(color: KdeviderColor),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MyAddressScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/address.png",
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  text: localizations.menumyAddress,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ),
                              Image.asset("images/chevronRight.png", width: 20),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: KdeviderColor),

                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => FavouriteDriversScreen(),
                      //       ),
                      //     );
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(3),
                      //     child: Row(
                      //       children: [
                      //         Image.asset(
                      //           "images/favorite.png",
                      //           width: 24,
                      //           height: 24,
                      //         ),
                      //         const SizedBox(width: 12),
                      //         Expanded(
                      //           child: CustomText(
                      //             text: localizations.menuFavDrivers,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.w400,
                      //             textcolor: KblackColor,
                      //           ),
                      //         ),
                      //         Image.asset("images/chevronRight.png", width: 20),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const Divider(color: KdeviderColor),
                      InkWell(
                        onTap:
                            () => _showUpdateMobileDialog(
                              uMN: localizations.menuUpdateMobileNumber,
                              eM: localizations.menuEnterMobile,
                              eOTP: localizations.menuEnterOTP,
                              dR: localizations.menuDontRecieved,
                              rS: localizations.menuResend,
                              c: localizations.menuCancel,
                              u: localizations.menuUpdate,
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/update.png",
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  text: localizations.menuUpdateMobileNumber,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ),
                              Image.asset("images/chevronRight.png", width: 20),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: KdeviderColor),
                      InkWell(
                        onTap: () => _showLanguageDialog(),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/language.png",
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  text: localizations.menuAppLanguage,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ),
                              Image.asset("images/chevronRight.png", width: 20),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: KdeviderColor),

                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (_) => OffersScreen()),
                      //     );
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(3),
                      //     child: Row(
                      //       children: [
                      //         Image.asset(
                      //           "images/offers.png",
                      //           width: 24,
                      //           height: 24,
                      //         ),
                      //         const SizedBox(width: 12),
                      //         Expanded(
                      //           child: CustomText(
                      //             text: localizations.menuOffers,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.w400,
                      //             textcolor: KblackColor,
                      //           ),
                      //         ),
                      //         Image.asset("images/chevronRight.png", width: 20),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      // const Divider(color: KdeviderColor),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => ReferFriendScreen(),
                      //       ),
                      //     );
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(3),
                      //     child: Row(
                      //       children: [
                      //         Image.asset(
                      //           "images/refer.png",
                      //           width: 24,
                      //           height: 24,
                      //         ),
                      //         const SizedBox(width: 12),
                      //         Expanded(
                      //           child: CustomText(
                      //             text: localizations.menuReferaFriend,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.w400,
                      //             textcolor: KblackColor,
                      //           ),
                      //         ),
                      //         Image.asset("images/chevronRight.png", width: 20),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const Divider(color: KdeviderColor),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PrivacyPolicy()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/privacy.png",
                                color: korangeColor,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  text: localizations.privacyPolicy,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ),
                              Image.asset("images/chevronRight.png", width: 20),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: KdeviderColor),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TermsAndConditions(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/info.png",
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  text: localizations.menuTC,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ),
                              Image.asset("images/chevronRight.png", width: 20),
                            ],
                          ),
                        ),
                      ),

                      // const Divider(color: KdeviderColor),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (_) => HelpAndSupport()),
                      //     );
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(3),
                      //     child: Row(
                      //       children: [
                      //         Image.asset(
                      //           "images/support.png",
                      //           width: 24,
                      //           height: 24,
                      //         ),
                      //         const SizedBox(width: 12),
                      //         Expanded(
                      //           child: CustomText(
                      //             text: localizations.menuHelpSupport,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.w400,
                      //             textcolor: KblackColor,
                      //           ),
                      //         ),
                      //         Image.asset("images/chevronRight.png", width: 20),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const Divider(color: KdeviderColor),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CancellationPolicyScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/policy.png",
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  text: localizations.menuCancelPolicy,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ),
                              Image.asset("images/chevronRight.png", width: 20),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: KdeviderColor),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AboutManaDriverScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/aboutMD.png",
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  text: localizations.menuAbtMD,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ),
                              Image.asset("images/chevronRight.png", width: 20),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: KdeviderColor),
                      InkWell(
                        onTap:
                            () => _showDeleteAccountDialog(
                              txt1: localizations.dA_t1,
                              txt2: localizations.dA_t2,
                              c: localizations.menuCancel,
                              d: localizations.menuDelete,
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/delete_acnt.png",
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  text: localizations.menuDeleteAccount,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ),
                              Image.asset("images/chevronRight.png", width: 20),
                            ],
                          ),
                        ),
                      ),
                      const Divider(color: KdeviderColor),
                      InkWell(
                        onTap: () => _showLogoutDialog(context),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/logout.png",
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomText(
                                  text: localizations.menuLogout,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textcolor: KblackColor,
                                ),
                              ),
                              Image.asset("images/chevronRight.png", width: 20),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showUpdateMobileDialog({
    required String uMN,
    required String eM,
    required String eOTP,
    required String dR,
    required String rS,
    required String c,
    required String u,
  }) async {
    final otpController = TextEditingController();
    final phoneController = TextEditingController();

    String savedCountryCode = await SharedPrefServices.getCountryCode() ?? "IN";
    String savedNumber = await SharedPrefServices.getNumber() ?? "";

    Country selectedCountry = Country.parse(savedCountryCode);
    phoneController.text = savedNumber;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: kwhiteColor,
              title: CustomText(
                text: uMN,
                textcolor: KblackColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhoneNumberInputField(
                    controller: phoneController,
                    selectedCountry: selectedCountry,
                    onCountryChanged: (Country country) {
                      setStateDialog(() {
                        selectedCountry = country;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomText(
                    text: eOTP,
                    textcolor: KblackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 10),
                  Pinput(
                    controller: otpController,
                    length: 4,
                    keyboardType: TextInputType.number,
                    defaultPinTheme: _pinTheme(),
                    focusedPinTheme: _focusedPinTheme(),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                      TextSpan(
                        text: dR,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: kgreyColor,
                        ),
                        children: [
                          TextSpan(
                            text: rS,
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
              actions: _dialogActions(
                P: u,
                c: c,
                onConfirm: () async {
                  if (otpController.text.trim() != "1234") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid OTP, please try again"),
                      ),
                    );
                    return;
                  }

                  String? userId = await SharedPrefServices.getUserId();
                  if (userId != null && userId.isNotEmpty) {
                    final query =
                        await FirebaseFirestore.instance
                            .collection("users")
                            .where("userId", isEqualTo: userId)
                            .get();

                    if (query.docs.isNotEmpty) {
                      String docId = query.docs.first.id;
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(docId)
                          .update({
                            "phone": phoneController.text.trim(),
                            "countryCode": selectedCountry.countryCode,
                          });
                    }
                    await SharedPrefServices.clearUserFromSharedPrefs();
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showLanguageDialog() async {
    String? savedLang = await SharedPrefServices.getSaveLanguage();
    if (savedLang != null) {
      setState(() {
        selectedLanguage = savedLang;
      });
    }
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: kwhiteColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Change Your App Language',
                  textcolor: KblackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 16),
                DropdownButtonHideUnderline(
                  child: StatefulBuilder(
                    builder: (context, setStateSB) {
                      return DropdownButton2<String>(
                        isExpanded: true,
                        value: selectedLanguage,
                        items: [
                          DropdownMenuItem(
                            value: 'English',
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: 'Telugu',
                            child: Text('తెలుగు'),
                          ),
                          DropdownMenuItem(
                            value: 'Hindi',
                            child: Text('हिन्दी'),
                          ),
                        ],

                        onChanged: (newValue) {
                          if (newValue == null) return;

                          setStateSB(() {
                            selectedLanguage = newValue;
                          });
                        },
                        dropdownStyleData: DropdownStyleData(
                          direction: DropdownDirection.textDirection,
                          offset: const Offset(0, -5),
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                        ),
                        buttonStyleData: ButtonStyleData(
                          height: 58,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFFD5D7DA)),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // onChanged: (newValue) {
                //   if (newValue == null) return;
                //   setState(() {
                //     selectedLanguage = newValue;
                //   });

                //   final localeProvider = Provider.of<LocaleProvider>(
                //     context,
                //     listen: false,
                //   );

                //   if (newValue == 'English') {
                //     localeProvider.setLocale(const Locale('en'));
                //   } else if (newValue == 'Hindi') {
                //     localeProvider.setLocale(const Locale('hi'));
                //   } else if (newValue == 'Telugu') {
                //     localeProvider.setLocale(const Locale('te'));
                //   }
                // },
              ],
            ),
            actions: _dialogActions(
              P: "Update",
              c: "Cancel",
              onConfirm: () {
                final localeProvider = Provider.of<LocaleProvider>(
                  context,
                  listen: false,
                );

                if (selectedLanguage == 'English') {
                  localeProvider.setLocale(const Locale('en'));
                } else if (selectedLanguage == 'Hindi') {
                  localeProvider.setLocale(const Locale('hi'));
                } else if (selectedLanguage == 'Telugu') {
                  localeProvider.setLocale(const Locale('te'));
                }

                SharedPrefServices.setSaveLanguage(selectedLanguage);

                Navigator.pop(context);
              },
            ),
          ),
    );
  }

  // onConfirm: () {
  //   if (selectedLanguage != null) {
  //     final localeProvider = Provider.of<LocaleProvider>(
  //       context,
  //       listen: false,
  //     );
  //     if (selectedLanguage == 'English') {
  //       localeProvider.setLocale(const Locale('en'));
  //     } else if (selectedLanguage == 'Hindi') {
  //       localeProvider.setLocale(const Locale('hi'));
  //     } else if (selectedLanguage == 'Telugu') {
  //       localeProvider.setLocale(const Locale('te'));
  //     }
  //   }
  //   Navigator.pop(context);
  // },

  void _showDeleteAccountDialog({
    required String txt1,
    required String txt2,
    required String c,
    required String d,
  }) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: kwhiteColor,
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("images/deleteacnt.png", height: 100),
                  const SizedBox(height: 12),
                  CustomText(
                    text: txt1,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    textcolor: KblackColor,
                  ),
                  const SizedBox(height: 10),
                  CustomText(
                    text: txt2,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: kseegreyColor,
                  ),
                ],
              ),
            ),
            actions: _dialogActions(
              P: d,
              c: c,
              onConfirm: () async {
                try {
                  // final prefs = await SharedPreferences.getInstance();
                  final docId = SharedPrefServices.getDocId();

                  if (docId != null) {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(docId)
                        .delete();
                  }

                  SharedPrefServices.clearUserFromSharedPrefs();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Your account has been deleted successfully.",
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to delete account: $e")),
                  );
                }
              },

              confirmText: "Confirm",
            ),
          ),
    );
  }

  List<Widget> _dialogActions({
    required VoidCallback onConfirm,
    required String P,
    required String c,
    String confirmText = "Update",
  }) {
    return [
      Row(
        children: [
          Expanded(
            child: CustomCancelButton(
              text: c,
              onPressed: () {
                Navigator.pop(context);
              },
              height: 46,
              width: 140,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              onPressed: onConfirm, // update action
              text: P,
              height: 46,
              width: 140,
            ),
          ),
        ],
      ),
    ];
  }

  PinTheme _pinTheme() => PinTheme(
    width: 60,
    height: 50,
    textStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: KblackColor,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: kbordergreyColor),
      borderRadius: BorderRadius.circular(10),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 5),
  );

  PinTheme _focusedPinTheme() => _pinTheme().copyWith(
    textStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: korangeColor, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  InputDecoration _dropdownDecoration(String hint) => InputDecoration(
    hintText: hint,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: korangeColor),
    ),
  );

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              localizations.confirmLogout,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "inter",
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: korangeColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    localizations.cancel,
                    style: TextStyle(color: korangeColor, fontFamily: "inter"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(SharedPrefServices.getDocId().toString())
                        .update({'fcmToken': ''});

                    SharedPrefServices.clearUserFromSharedPrefs();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: korangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    localizations.menuLogout,
                    style: TextStyle(color: Colors.white, fontFamily: "inter"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
