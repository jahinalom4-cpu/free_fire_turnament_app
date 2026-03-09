import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tournament_freefire/Request&notifications/allRequest&Notifications.dart';

import '../main.dart';
class notiService{
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Handle the notification view while app on kill or background mode
  }



  static Future<void> initializeNotification() async{
    await _firebaseMessaging.requestPermission(announcement: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      await _showFlutterNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // handle notification tap route (Background)
    });
    await updateDeviceTokenToFirestore();
    await _initializeLocalNotification();
    await _getInitialNotification();
    // When user taps the notification while the app is in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (_) =>  AllNotificationRequest()),
        );
      }
    });
  }

  // Call this in main.dart after user is logged in
  static Future<void> updateDeviceTokenToFirestore() async {
    try {
      String? token = await _firebaseMessaging.getToken();

      if (token != null) {
        print('FCM Token ⇒ $token');

        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // Update Firestore with new device token
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .update({'deviceToken': token});

          print('✅ Device token updated to Firestore');
        } else {
          print('⚠️ User not signed in');
        }
      } else {
        print('❌ FCM token is null');
      }
    } catch (e) {
      print('🔥 Error updating device token: $e');
    }
  }

  static Future<void> _getInitialNotification() async{
    await FirebaseMessaging.instance.getInitialMessage().then((remoteMessage) {
      // handle notification tap route (Kill mode)
    });
  }


  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotificationDetails android = AndroidNotificationDetails(
        'CHANNEL ID',
        'CHANNEL NAME',
        priority: Priority.high,
        importance: Importance.high
    );
    DarwinNotificationDetails? iOS = DarwinNotificationDetails(
        presentSound: true,
        presentBanner: true,
        presentBadge: true,
        presentAlert: true
    );
    NotificationDetails notificationDetails = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
      0,
      notification?.title,
      notification?.body,
      notificationDetails,
    );
  }




  static Future<void> _initializeLocalNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('@drawable/ic_launcher');
    DarwinInitializationSettings initializationSettingsIOS = const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (details) {
// handle notification tap route (Foreground)
      },
    );
  }




}