import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Firestore import
import 'package:tournament_freefire/notification/get_serverkey.dart';

class NotificationService {
  static final String projectId = 'gen-lang-client-0922107247';

  /// This method fetches tokens and sends notifications
  static Future<void> sendNotificationToAllAdmins({
    required String title,
    required String body,
  }) async {
    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send');
    GetServerKey getServerKey = GetServerKey();
    String accessToken = await getServerKey.getServerKeyToken();

    // ✅ Fetch all admin tokens from Firestore
    final firestore = FirebaseFirestore.instance;
    final tokenDocs = await firestore.collection("adminDeviceTokens").get();

    List<String> adminDeviceTokens =
        tokenDocs.docs.map((doc) => doc['token'] as String).toList();

    for (String token in adminDeviceTokens) {
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({
            "message": {
              "token": token,
              "notification": {
                "title": title,
                "body": body,
              },
              "data": {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                "type": "admin_alert",
              }
            }
          }),
        );

        if (response.statusCode != 200) {
          print("❌ Failed to send to $token. Response: ${response.body}");
        } else {
          print("✅ Sent to $token");
        }
      } catch (e) {
        print('🔥 Error sending to $token: $e');
      }
    }
  }
}
