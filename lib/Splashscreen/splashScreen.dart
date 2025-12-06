import 'package:flutter/material.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/Login/selectLanguage.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

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
    String role = SharedPrefServices.getRoleCode().toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
    print("isLoggedIn: $isLoggedIn");
    print("role: $role");

    if (isLoggedIn && role == "Owner") {
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

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Colors.white38,
      Colors.grey,
      Colors.orange,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 42.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Horizon',
      letterSpacing: 1.5,
    );

    return Scaffold(
      backgroundColor: korangeColor,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'images/rydyn_user.png',
                height: 400,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'MADE IN INDIA',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  textcolor: kwhiteColor,
                ),
                const SizedBox(width: 5),
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
    );
  }
}
//  const SizedBox(),

//           Center(
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.8,
//               child: AnimatedTextKit(
//                 repeatForever: true,
//                 animatedTexts: [
//                   ColorizeAnimatedText(
//                     'rydyn',
//                     textStyle: colorizeTextStyle,
//                     colors: colorizeColors,
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//                 isRepeatingAnimation: true,
//                 pause: const Duration(milliseconds: 200),
//               ),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.only(bottom: 40),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CustomText(
//                   text: 'Made in India',
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   textcolor: kwhiteColor,
//                 ),
//                 const SizedBox(width: 5),
//                 Image.asset(
//                   'images/flag.png',
//                   width: 21,
//                   height: 17,
//                   fit: BoxFit.contain,
//                 ),
//               ],
//             ),
//           ),
