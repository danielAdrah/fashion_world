// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final firebaseMessaging = FirebaseMessaging.instance;

  // initialize notifications for this app or device
  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    // get device token
    String? deviceToken = await firebaseMessaging.getToken();
    print(
        "===================Device FirebaseMessaging Token====================");
    print(deviceToken);
  }

  //====GET THE TOKEN TO BE ABLE TO SEND NOTIFICATIONS
  Future<String?> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "fashionuniverse",
      "private_key_id": "3806ebd61ea4d02a7ab61f720bd1332a85b09180",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC9FuH5qF9mpiun\naZUKkPaEXgVVn7TXpat4LejRLvz7neIyuKqJQ2acljWQjvcnYrPcBJr8nBqWATLd\n2x56ZZX8vuznZIrGQWpMs5HBTbzZulHZbQ4/2RPW7ih94GZu96FzKDAO1y2HERgO\nsUOR+9EB0HzEPgyiVfUNFC1MTurbf+vyinRmM13H8bMrwENts9kan9YoVWxgYCGR\nu65G/oQVWvr2imqZIxNjFaCpN2v2R5RPaDnYAuwP8iY12pARAiguAnTSZh9TZx/Q\n94R4OVGOS9YFSTcYKZAVnFb3FxQC5a1pmJq/bzavuCQML4mstbP+57UIy6BKT9v/\nVcnXxYnHAgMBAAECggEAGmiUvOqAEHUKycHcN/KRC2GaOyAoAKo5rXoz9usqF/Yv\n/kd+QddxAFOWPY9KA20sk4DtKHSg3exi70tIEW4YqYj8y0BmhVPjhbzakXXK91mn\nTseFYvNtauouK45on/zjxpKJS7lPuXpwsrSdLElQIoG8uyezWgTJSb9UqECpWmhg\nZf/9WROqoa3xUR7gXYOisCrEI+lT0S75yK46e5t8L9aXX0txBISeIcST/ygEBnf7\n+cLxdibnbpowr1JmABWUcRFVdSAQnOa9fN1JZJ0atJLzFtQ0K2NdfzUQkus8ZySN\nMU/ZcX8BF3Dm7DS/cM5vW2Olk2AcQKK5gPaSi5TQQQKBgQD329C9Ucw4N042wBSb\n9yyiHnuxtGBJ1zRmjVSJf4LHMKPbqS4MydDXWQ0hhC/v3La4m3naz/Dt+Vud+/vp\nChYhRUhlSgvzUTEAI2IqsMZncbOs1gf2kWbF6GGXkoI/8j5q2rgmODnvNWb0kT9B\nvrFiU5MkprCAXWtnXimxIG32JwKBgQDDTOP3bze/W1BOcBWPHntZrAZ8l5rb0OOZ\ndsuwA2v4GD2JBzEeIClo3Nfrz8Bh73G+ic/oIfy/bG9zkhTgEftBX8TetsQgLb/N\n2hadt/CumkvtR//OAUACkvcDTVEFyIXMuokAyGtTqOniyUn1mgBmF24oFhhWlXZI\nKurUqdKzYQKBgHGvlXMAzdcLJwjd2ZYgLYy+xqWfwnqcByDyuk/G+Mk8eiwK0WB0\nQSJFakxxQTuX1Qef6KiAsFW3BlrUdZtSUQw5pxcue4TDPOJ/WEuUgax47pzcHxLt\nZmJoUDshrDSAfDiu0cBWEdyydeK/rHAPc3VSOC+bdWGrd9QV0LG52jYJAoGAD0K1\n2YLOR1yaRNbLSHioSNSBWUD7b8u9zSMUPXe2+xbh0BBIzULUGYaQNLPyI3TzXWEl\nZs0pE8gkWVKD4RJmoLAcEQ8U+jK49xvggoh5/Rq/bhYfLfi5CLp1JMPo3dvSYLH+\nvJnskQf05qy148QZ3eBc0jMPycw6Bt+bo+x1M2ECgYEA8SaR/WIGvXRTlmcpBend\nYp2vfieC27i/8M2x6epa57lTFDdjqeqJE1/1AW8cJgb7IYdb4NkuRWOdD9lKRNfV\nVuVVqJBqW6JZvIJp39JUBWhVu/1pb7gqr+Kgc4b9F6ZLEnmUkU2Od/tDpvFAUgGw\ntd5faDMe+WdDZiLMr8eCxkg=\n-----END PRIVATE KEY-----\n",
      "client_email": "fashionworld@fashionuniverse.iam.gserviceaccount.com",
      "client_id": "111422310894022321856",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/fashionworld%40fashionuniverse.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    print("1");

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    print("2");

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);
      print("4");

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);
      print("5");

      client.close();
      print(
          "Access Token: ${credentials.accessToken.data}"); // Print Access Token
      return credentials.accessToken.data;
    } catch (e) {
      print("Error getting access token: $e");
      return null;
    }
  }

//========SEND NOTIFICATIONS WHEN THE APP IS CLOSED
  Future<void> sendNotifications(
      String body, String title, String token) async {
    try {
      Future.delayed(const Duration(seconds: 30));
      var serverKeyAuthorization = await getAccessToken();
      const String urlEndPoint =
          "https://fcm.googleapis.com/v1/projects/fashionuniverse/messages:send";

      print(token);

//this is the data we want to send in the notification
      final payload = {
        "message": {
          "token": token,
          "notification": {
            "body": body,
            "title": title,
          },
        }
      };
      print("before post");

      final response = await http.post(
        Uri.parse(urlEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKeyAuthorization',
        },
        body: jsonEncode(payload),
      );

      print("after post");
      if (response.statusCode == 200) {
        print("================Notification sent successfully!");
      } else {
        print("==========Error sending notification: ${response.statusCode}");
        print("==========Error sending notification: ${response.body}");
      }
    } catch (e) {
      print("===============Error sending notification: $e");
    }
  }
}
