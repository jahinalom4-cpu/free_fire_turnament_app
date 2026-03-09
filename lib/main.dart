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

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB-9kmPXfz1qyII54eeJDZAtwI6Zz_BG3E",
      appId: "1:909961959511:android:b0b3c81bf2c23ea0af2b12",
      messagingSenderId: "909961959511",
      projectId: "tournamentapp-ea980",
      storageBucket: "tournamentapp-ea980.firebasestorage.app",
    ),
  );
  FirebaseMessaging.onBackgroundMessage(notiService.firebaseMessagingBackgroundHandler);

  notiService.initializeNotification();

  FirebaseMessaging.instance
      .subscribeToTopic("all_users")
      .then((_) {
    print("✅ Successfully subscribed to topic: all_users");
  })
      .catchError((error) {
    print("❌ Failed to subscribe to topic: $error");
  });

  runApp( MyApp());
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

