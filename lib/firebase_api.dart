import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel _androidChannel =
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Used for important notifications',
        importance: Importance.high,
      );

  Future<void> initNotifications() async {
    final token = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $token");

    await _initLocalNotifications();
    _initFCMListeners();
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(settings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  void _initFCMListeners() {
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("Opened from background");
    });
  }

  Future<void> iosNotifications() async {
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);
  }
}






// imp code //
// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:mana_driver/main.dart';

// Future<void> backgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
//   print("title: ${message.notification?.title}");
//   print("body: ${message.notification?.body}");
// }

// Future<void> foregroundHandler(RemoteMessage message) async {
//   print("Handling a foreground message: ${message.messageId}");
//   print("title: ${message.notification?.title}");
//   print("body: ${message.notification?.body}");
// }

// class FirebaseApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   final _androidChannel = const AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications.',
//     importance: Importance.high,
//   );

//   final _localNotifications = FlutterLocalNotificationsPlugin();

//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();

//     final fCMtoken = await _firebaseMessaging.getToken();
//     print("FCM Token: $fCMtoken");
//     FirebaseMessaging.onBackgroundMessage(backgroundHandler);
//     // FirebaseMessaging.foregroundMessageStream.listen((message) {
//     //   foregroundHandler(message);
//     // });
//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification == null) return;
//       _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,

//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             _androidChannel.id,
//             _androidChannel.name,
//             channelDescription: _androidChannel.description,
//             importance: _androidChannel.importance,
//             icon: '@mipmap/ic_launcher',
//             color: Colors.orange,
//           ),
//         ),
//         payload: jsonEncode(message.toMap()),
//       );
//       foregroundHandler(message);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print("Tapped notification (background)!");
//       _handleNotificationTap(message);
//     });

//     final initialMessage = await _firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       print("Tapped notification (terminated)!");
//       _handleNotificationTap(initialMessage);
//     }
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       foregroundHandler(message);
//     });
//     FirebaseMessaging.onBackgroundMessage(backgroundHandler);
//     FirebaseMessaging.onMessage.listen((message) {
//       foregroundHandler(message);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       foregroundHandler(message);
//     });
//   }

//   void _handleNotificationTap(RemoteMessage message) {
//     final route = message.data['route'] ?? '/dashboard';
//     print('Navigating to route: $route');

//     navigatorKey.currentState?.pushNamed(route);
//   }

// Future<void> iosNotifications() async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   const DarwinInitializationSettings iosSettings =
//       DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//       );

//   const InitializationSettings initSettings = InitializationSettings(
//     iOS: iosSettings,
//   );

//   await flutterLocalNotificationsPlugin.initialize(initSettings);
//   // await FirebaseMessaging.instance
//   //     .setForegroundNotificationPresentationOptions(
//   //   alert: true,
//   //   badge: true,
//   //   sound: true,
//   // );
// }
// }