import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/Home/Home.dart';

import 'package:tournament_freefire/Home/splash_screen.dart';
import 'package:tournament_freefire/log_sign/login_page.dart';
import 'package:tournament_freefire/log_sign/sign_Up.dart';
import 'package:tournament_freefire/notification/noti_service.dart';
import 'package:tournament_freefire/notification/notifation_handler.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBiEL7Uexumu-A1BuPqwzYk10ij9czWjRw",
      appId: "1:264690258883:web:3248f03f08de62521de376",
      messagingSenderId: "264690258883",
      projectId: "gen-lang-client-0922107247",
      storageBucket: "gen-lang-client-0922107247.firebasestorage.app",
    ),
  );
  FirebaseMessaging.onBackgroundMessage(
      notiService.firebaseMessagingBackgroundHandler);

  notiService.initializeNotification();

  FirebaseMessaging.instance.subscribeToTopic("all_users").then((_) {
    print("✅ Successfully subscribed to topic: all_users");
  }).catchError((error) {
    print("❌ Failed to subscribe to topic: $error");
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'My App',
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/home', page: () => Home()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignUPScreen()),
      ],
    );
  }
}
