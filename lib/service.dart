import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:mana_driver/SharedPreferences/shared_preferences.dart';

class FCMService {
  Future<String> _getAccessToken() async {
    try {
      String scope = 'https://www.googleapis.com/auth/firebase.messaging';
      String rawKey = SharedPrefServices.getPrivateKey() ?? "";
      // String cleanedPrivateKey = rawKey.replaceAll("\\\\n", "\n");
      String cleanedPrivateKey = rawKey.replaceAll(r'\n', '\n');
      Map<String, dynamic> serviceAccountJson = {
        "type": "service_account",
        "project_id": "nyzoride-69ab6",
        "private_key_id": SharedPrefServices.getPrimaryKey(),
        "private_key": cleanedPrivateKey,
        "client_email": SharedPrefServices.getClientEmail(),
        "client_id": SharedPrefServices.getClientId(),
        "auth_uri": SharedPrefServices.getAuthUri(),
        "token_uri": SharedPrefServices.getTokenUri(),
        "auth_provider_x509_cert_url": SharedPrefServices.getAuthProvider(),
        "client_x509_cert_url": SharedPrefServices.getClientUrl(),
        "universe_domain": SharedPrefServices.getUniverseDomain(),
      };
      // final serviceAccount = json.decode(_serviceAccountJson);
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccountJson),
        [scope],
      );
      return client.credentials.accessToken.data;
    } catch (e) {
      throw Exception('Failed to get access token: $e');
    }
  }

  Future<bool> sendNotification({
    required String recipientFCMToken,
    required String title,
    required String body,
  }) async {
    final String accessToken = await _getAccessToken();
    const String projectId = 'nyzoride-69ab6';
    final Uri url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
    );

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final requestBody = jsonEncode({
      "message": {
        "token": recipientFCMToken,
        "notification": {"title": title, "body": body},

        // "data": {
        //   "route": "/dashboard",
        //   "click_action": "FLUTTER_NOTIFICATION_CLICK",
        // },
        "data": {},

        // "android": {
        //   "notification": {"click_action": "FLUTTER_NOTIFICATION_CLICK"},
        // },
        "android": {
          "priority": "HIGH",
          "notification": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "channel_id": "high_importance_channel",
          },
        },
        "apns": {
          "payload": {
            "aps": {"category": "NEW_NOTIFICATION"},
          },
        },
      },
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: requestBody,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('FCM error: $e');
      return false;
    }
  }
}


  //   static String _serviceAccountJson = '''
  // {
  //   "type": "service_account",
  //   "project_id": "mana-driver",
  //   "private_key_id": "${SharedPrefServices.getPrimaryKey()}",
  //   "private_key": "${SharedPrefServices.getPrivateKey()}",
  //   "client_email": "${SharedPrefServices.getClientEmail()}",
  //   "client_id": "${SharedPrefServices.getClientId()}",
  //   "auth_uri": "${SharedPrefServices.getAuthUri()}",
  //   "token_uri": "${SharedPrefServices.getTokenUri()}",
  //   "auth_provider_x509_cert_url": "${SharedPrefServices.getAuthProvider()}",
  //   "client_x509_cert_url": "${SharedPrefServices.getClientUrl()}",
  //   "universe_domain": "${SharedPrefServices.getUniverseDomain()}"
  // }
  // ''';