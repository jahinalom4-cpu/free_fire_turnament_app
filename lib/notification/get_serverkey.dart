import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    // Load service account credentials from a local JSON file
    final jsonString = await rootBundle.loadString('assets/service_account.json');
    final jsonCredentials = jsonDecode(jsonString);

    final credentials = ServiceAccountCredentials.fromJson(jsonCredentials);

    // Create the authenticated HTTP client
    final client = await clientViaServiceAccount(credentials, scopes);

    // Get the access token
    final accessToken = client.credentials.accessToken.data;

    client.close(); // Always close the client after use
    return accessToken;
  }
}
