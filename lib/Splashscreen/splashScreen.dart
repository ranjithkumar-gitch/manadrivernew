import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/Login/selectLanguage.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';  
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mana_driver/notifications/firebase_api.dart';
import 'package:mana_driver/notifications/service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final fcmService = FCMService();
  final FirebaseApi _firebaseApi = FirebaseApi();
  @override
  void initState() {
    super.initState();
    _navigateNext();
    print('DOCID ${SharedPrefServices.getDocId().toString()}');
    print('USER ID ${SharedPrefServices.getUserId().toString()}');
  }

  Future<void> runApp() async {
    await _firebaseApi.initNotifications();

    final token = await FirebaseMessaging.instance.getToken();
    print('FCM Token on Splash: $token');

    if (token != null && token.isNotEmpty) {
      String? userId = SharedPrefServices.getUserId();
      String? docId = SharedPrefServices.getDocId();

      print("DOCID from SharedPref: $docId");
      print("USER ID from SharedPref: $userId");

      if (userId != null &&
          userId.isNotEmpty &&
          docId != null &&
          docId.isNotEmpty) {
        try {
          final docSnapshot =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(docId)
                  .get();
          if (docSnapshot.exists) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(docId)
                .update({'fcmToken': token});
            print("FCM Token saved to Firestore for docId: $docId");
          } else {
            print(" Document with docId: $docId does not exist");
          }
        } catch (error) {
          print("Failed to save FCM Token: $error");
        }
      } else {
        print(" userId or docId is null/empty. Cannot update FCM token.");
      }
    } else {
      print(' Failed to get device FCM token');
    }

    await Future.delayed(const Duration(seconds: 3));
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
