// controllers/signup_controller.dart
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/notification/notification_service.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referralCodeController = TextEditingController();

  var selectedAvatarIndex = RxnInt(); // null by default
  var isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String? deviceToken;

  @override
  void onInit() {
    super.onInit();
    _getDeviceToken();
  }

  Future<void> _getDeviceToken() async {
    try {
      deviceToken = await _firebaseMessaging.getToken();
      print('Device Token: $deviceToken');
    } catch (e) {
      print('Error getting device token: $e');
    }
  }

  String generateReferralCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  void showSnackBar(String message) {
    Get.snackbar('Message', message,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> signUpUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final enteredReferralCode = referralCodeController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        selectedAvatarIndex.value == null) {
      showSnackBar('Please fill all fields and select an avatar');
      return;
    }

    if (password != confirmPassword) {
      showSnackBar('Passwords do not match');
      return;
    }

    if (deviceToken == null) {
      showSnackBar('Device token not available. Please try again.');
      return;
    }

    isLoading.value = true;

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        final myReferralCode = generateReferralCode();

        // Validate referral code if entered
        bool validReferral = false;
        if (enteredReferralCode.isNotEmpty) {
          final refSnapshot = await _firestore
              .collection('users')
              .where('referralCode', isEqualTo: enteredReferralCode)
              .limit(1)
              .get();

          if (refSnapshot.docs.isNotEmpty) {
            validReferral = true;
          } else {
            showSnackBar('Invalid referral code');
          }
        }

        // Save user data
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'phone': phone,
          'avatar': selectedAvatarIndex.value,
          'referralCode': myReferralCode,
          'deviceToken': deviceToken,
          'createdAt': Timestamp.now(),
          'totalBalance': 0,
          'winningBalance': 0,
          'depositBalance': 0,
          'referBalance': 0,
          'garenaPlayed': 0,
          'ludoPlayed': 0,
          'carromPlayed': 0,
          'Request&notifications': [],
          // 👉 Store used referral code and match status
          'usedReferralCode': validReferral ? enteredReferralCode : null,
          'hasJoinedGame': false,
        });

        // Notify Admin
        await NotificationService.sendNotificationToAllAdmins(
            title: "New user SignUp",
            body: "$name registered as a new student"
        );

        showSnackBar("Account Created Successfully 🎉");
        Get.offAllNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message ?? 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

}
