import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FCMService {
  static const String _serviceAccountJson = '''
 {
  "type": "service_account",
  "project_id": "mana-driver",
  "private_key_id": "3eaa576b6807288a6ea5be9c898d9e0d3c322236",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCqa13DxAhHNDmu\nY6yQCUQkd+ctRCo8Zgm86YRHe9+HiLjxSPJFn84Ty42U3LyADifpToFI/vE+lV0c\npj5aRTwY3k6+DCeyW2h61LzMRkCpco83W19MW5+azBCkTdb7NUBRN1M1deIRtwmg\nDR8anlUEkaKJ0Y+uelfPGd7hwaISJJ81INFwOSxlNUgu4YL32T3AFv7ig4UTHiNS\n8SGq0TtLvDzaPBva92r9l2xzTJJKVhcZ10AlIQ9BqaFQK/lf7u2u1+JefGT5iEB+\nL3snuKmDI6dTRowvDBo/xFH1hi40F58etjh91d5AquhF/VLrhNRqVUk/Mi1ITsuN\ntJQrLRUZAgMBAAECggEACX7E8Sjley4mPpiwHzBc+xkxKL0BC292AHAUXjVBLZiJ\nEWyKjyWJwmGXiGFKIWpof9/PZUVLJL0GvJdopvfvksUkJwOfXJkqN5nN0SXi6W4I\nG8H8C9GZEXNoQ/dQUJvVcxD9kl94kpsbrq68emuy+fexUjN6aXLInLHo0LRMtuz7\nAmheCfO0wGTZDSNlwkSNuk0klNRmgrWoU+aT/RWLP+GVIDv6/qMgNBvT4MZ7bAC2\nbVPFzNCphJM3gFzuMG1+2XZj0uXVhkJp2CKWhzxB/1iOVwusN2608xVUZlttMWit\nyWo6Z9dPDKTavrwstYQb870GBOam+NhKyT4DhGuJAQKBgQDqJ+KV3kq1PLrwO+Ig\nBZqhUzF7vkmOBurWskcHh3TuZy2ZwC0q1HHxYeXEWDw8K4CWKEcAKjcRhvRE40WC\n3cL6KAk5GqpbvuPvGvRpWj3+D/Sasoz/hlDbAwzWpK5KJ205L3ue0+GZlmLbdya6\nXtz1oMW8N3r83ITXspIjFP3HQQKBgQC6UVOnjJ8ExQXB6y8jK9oBkQveonUcyw7g\nIZCgI3ajPHwO1fnSqQ8J1tzzC0ydmMcZ87AR8q3QohWCUDIbIeZ0Y2vA6ACy0G6t\nipnqGUf3FuHzzWr5kJWkawDr04mBoQ79XI/CW1kOcJbTCFUlI1S5ZTPdzNANKCap\nVB7HJipv2QKBgQDCS/hTnZHmU49W+onHQn8t8Gd2I87LIGhLYMFZuQfJLyqCkxmn\nmYM25aIPy5un3f0kHCXWODFbxNz6MJAkaDl69C+7B6pm2L4wUPCQXwZjw/+XQiOH\ngH+lTCGiFiJde9vBAOqWP4DKviQnsfYb3c2BsDeD15GhMqa0iQOEQs3WQQKBgAr3\nGFZHB2DPe5xDDB4kyYrID4vFweC07qYwM4PJMoU+3Qo+e5pzSqhIle5T3ulzgVw8\npEMaJjKeJ2fo8ln4b8ivxTqwLMJZU/owqwhE/qBDH38qur3/TV9E0OQQKgqQAQLW\nPLuyhpY7+BRpbCFoZ+cVVq0aDbCIiWXzxm/wBhVZAoGAJ/hX0pe9K+bSKlDyJhug\nhEeyJFUakU5eJR8SgaKW/bKmau42GosQJO74h8do+26pqYZP8+or3/trhz6ggJuy\nsX/f/DMZOVXLGROHC3Wt2dYq+/1Gncl0C7+vuorlBac60OhvBfJ6gk+3ruN3Glob\n5PPJM3JEu30Ja2Q8TcGLGN8=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-fbsvc@mana-driver.iam.gserviceaccount.com",
  "client_id": "107939278303708016514",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40mana-driver.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';

  Future<String> _getAccessToken() async {
    try {
      String scope = 'https://www.googleapis.com/auth/firebase.messaging';
      final serviceAccount = json.decode(_serviceAccountJson);
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccount),
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
    const String projectId = 'mana-driver';
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
        "android": {
          "notification": {"click_action": "FLUTTER_NOTIFICATION_CLICK"},
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
