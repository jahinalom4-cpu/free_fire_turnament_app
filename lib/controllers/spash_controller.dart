import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

class SplashController extends GetxController {
  var isLoading = true.obs;
  bool _hasNavigated = false;

  @override
  void onInit() {
    super.onInit();
    _initSplash();
  }

  Future<void> _initSplash() async {
    if (_hasNavigated) return;

    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        _finishSplash('/login');
        return;
      }

      final deviceToken = await FirebaseMessaging.instance.getToken();

      if (deviceToken != null) {
        // ✅ Update current user's Firestore document with deviceToken
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'deviceToken': deviceToken});
      }

      _finishSplash('/home');
    } catch (e) {
      print('Splash error: $e');
      Get.snackbar('Error', 'Something went wrong during splash logic');
      _finishSplash('/login');
    }
  }

  void _finishSplash(String route) {
    isLoading.value = false;
    _navigateSafely(route);
  }

  void _navigateSafely(String route) {
    if (!_hasNavigated) {
      _hasNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(route);
      });
    }
  }
}
