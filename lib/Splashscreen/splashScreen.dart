import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Bottom_NavigationBar/bottomNavigationBar.dart';
import 'package:mana_driver/Login/selectLanguage.dart';
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';
import 'package:mana_driver/Widgets/colors.dart';
import 'package:mana_driver/Widgets/customText.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mana_driver/firebase_api.dart';
import 'package:mana_driver/service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final fcmService = FCMService();
  // final FirebaseApi _firebaseApi = FirebaseApi();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0, // start at normal size
      end: 1.0, // shrink to nothing (zoom out)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    startSplashFlow();

    print('DOCID ${SharedPrefServices.getDocId().toString()}');
    print('USER ID ${SharedPrefServices.getUserId().toString()}');
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> startSplashFlow() async {
    await fetchServiceKeys();
    await setupFCMToken();
    await _navigateNext();
  }

  Future<void> fetchServiceKeys() async {
    try {
      final snap =
          await FirebaseFirestore.instance
              .collection("serviceKeys")
              .doc('p5xZLhdsUezpgluOIzSY')
              .get();

      if (!snap.exists) {
        print("Service keys document not found");
        return;
      }

      final data = snap.data()!;

      await SharedPrefServices.setAuthProvider(data["authProvider"] ?? "");
      await SharedPrefServices.setAuthUri(data["authUri"] ?? "");
      await SharedPrefServices.setClientEmail(data["clientEmail"] ?? "");
      await SharedPrefServices.setClientId(data["clientId"] ?? "");
      await SharedPrefServices.setClientUrl(data["clientUrl"] ?? "");
      await SharedPrefServices.setPrimaryKey(data["primaryKey"] ?? "");
      await SharedPrefServices.setPrivateKey(data["privateKey"] ?? "");
      await SharedPrefServices.setTokenUri(data["tokenUri"] ?? "");
      await SharedPrefServices.setUniverseDomain(data["universeDomain"] ?? "");

      print("Service keys saved to SharedPreferences!");

      print("authProvider      : ${SharedPrefServices.getAuthProvider()}");
      print("authUri           : ${SharedPrefServices.getAuthUri()}");
      print("clientEmail       : ${SharedPrefServices.getClientEmail()}");
      print("clientId          : ${SharedPrefServices.getClientId()}");
      print("clientUrl         : ${SharedPrefServices.getClientUrl()}");
      print("primaryKey        : ${SharedPrefServices.getPrimaryKey()}");
      print("privateKey        : ${SharedPrefServices.getPrivateKey()}");
      print("tokenUri          : ${SharedPrefServices.getTokenUri()}");
      print("universeDomain    : ${SharedPrefServices.getUniverseDomain()}");
    } catch (e) {
      print("Error loading service keys: $e");
    }
  }

  Future<void> setupFCMToken() async {
    // await _firebaseApi.initNotifications();

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
  }

  Future<void> _navigateNext() async {
    // 🔔 Detect notification open (APP CLOSED STATE)
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      print("App opened via notification");
      // Later you can use: message.data['type']
    }

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

    final colorizeTextStyle = GoogleFonts.cabinSketch(
      fontSize: 52,
      fontWeight: FontWeight.w800,

      color: Colors.black,
    );

    return Scaffold(
      backgroundColor: korangeColor,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'rydyn',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //   Image.asset(
              //     'images/rydyn_captain.png',
              //     height: 400,
              //     fit: BoxFit.contain,
              //   ),
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







 // Expanded(
          //   child: Center(
          //     child: SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.8,
          //       child: AnimatedTextKit(
          //         repeatForever: true,
          //         animatedTexts: [
          //           ColorizeAnimatedText(
          //             'rydyn',
          //             textStyle: colorizeTextStyle,
          //             colors: colorizeColors,
          //             textAlign: TextAlign.center,
          //           ),
          //         ],
          //         isRepeatingAnimation: true,
          //         pause: const Duration(milliseconds: 200),
          //       ),
          //     ),
          //   ),

          //   // Center(
          //   //   child: Image.asset(
          //   //     'images/rydyn_user.png',
          //   //     height: 400,
          //   //     fit: BoxFit.contain,
          //   //   ),
          //   // ),
          // ),
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
