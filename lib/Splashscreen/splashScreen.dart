import 'package:flutter/material.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/Login/selectLanguage.dart';

import 'package:mana_driver/OnBoardingScreens/onboarding_screens.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
   
    await Future.delayed(const Duration(seconds: 3));

    await SharedPrefServices.init();

    bool isLoggedIn = SharedPrefServices.getislogged();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavigation()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LanguageSelectionScreen()),
      );
    }
  }

  double dynamicHeight(BuildContext context, double figmaHeight) {
    const baseHeight = 812;
    final screenHeight = MediaQuery.of(context).size.height;
    return (figmaHeight / baseHeight) * screenHeight;
  }


  // @override
  // void dispose() {
  //   FocusScope.of(context).unfocus();
  //   super.dispose();
  // }

 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: korangeColor,
        body: Column(
          children: [
            SizedBox(height: dynamicHeight(context, 296)),

            Center(
              child: Image.asset(
                'images/app_logo.png',
                width: 260,
                height: 260,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: dynamicHeight(context, 470 - 296)),

            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Made in India',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    textcolor: kwhiteColor,
                  ),
                  SizedBox(width: 5),
                  Image.asset(
                    'images/flag.png',
                    width: 21,
                    height: 17,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
