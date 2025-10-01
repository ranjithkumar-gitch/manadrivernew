import 'package:flutter/material.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:mana_driver/Login/selectLanguage.dart';

import 'package:mana_driver/OnBoardingScreens/onboarding_screens.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    } else if (isLoggedIn && role == "Driver") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => D_BottomNavigation()),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),

          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Mana Driver',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                    textAlign: TextAlign.center,
                  ),
                ],
                isRepeatingAnimation: true,
                pause: const Duration(milliseconds: 200),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'Made in India',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
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



// Previous SplashScreen code
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateNext();
//   }

//   Future<void> _navigateNext() async {

//     await Future.delayed(const Duration(seconds: 3));

//     await SharedPrefServices.init();

//     bool isLoggedIn = SharedPrefServices.getislogged();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusManager.instance.primaryFocus?.unfocus();
//     });

//     if (isLoggedIn) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => BottomNavigation()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LanguageSelectionScreen()),
//       );
//     }
//   }

//   double dynamicHeight(BuildContext context, double figmaHeight) {
//     const baseHeight = 812;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return (figmaHeight / baseHeight) * screenHeight;
//   }

//   // @override
//   // void dispose() {
//   //   FocusScope.of(context).unfocus();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: korangeColor,
//         body: Column(
//           children: [
//             SizedBox(height: dynamicHeight(context, 296)),

//             Center(
//               child: Image.asset(
//                 'images/app_logo.png',
//                 width: 260,
//                 height: 260,
//                 fit: BoxFit.contain,
//               ),
//             ),

//             SizedBox(height: dynamicHeight(context, 470 - 296)),

//             Center(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CustomText(
//                     text: 'Made in India',
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     textcolor: kwhiteColor,
//                   ),
//                   SizedBox(width: 5),
//                   Image.asset(
//                     'images/flag.png',
//                     width: 21,
//                     height: 17,
//                     fit: BoxFit.contain,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }