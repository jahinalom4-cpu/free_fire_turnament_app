// controllers/login_controller.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/firebase/firebase_service.dart';
import 'package:tournament_freefire/Home/Home.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

// ... other imports

  void loginWithEmail() async {
    isLoading.value = true;
    try {
      final user = await FirebaseService().signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        // ✅ Update device token
        await _updateDeviceToken(user.uid);
        Get.offAll(() => const Home());
      } else {
        showError("Login failed. Check your credentials.");
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void loginWithGoogle() async {
    isLoading.value = true;
    try {
      final user = await FirebaseService().signInWithGoogle();
      if (user != null) {
        // ✅ Update device token
        await _updateDeviceToken(user.uid);
        Get.offAll(() => const Home());
      } else {
        showError("Google sign-in failed.");
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateDeviceToken(String userId) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await FirebaseService().updateDeviceToken(userId, fcmToken);
    }
  }

  void showError(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
