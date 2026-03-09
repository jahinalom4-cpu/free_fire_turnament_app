import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountController extends GetxController {
  var isLoading = true.obs;

  var username = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var balance = 0.obs;
  var gareenaMatches = 0.obs;
  var ludoMatches = 0.obs;
  var carrumMatches = 0.obs;
  var avatar = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> refreshWidrawallData() async {
    // Put all refresh-related logic here.
    fetchUserData();
    // Add any other data-fetching logic if needed
    await Future.delayed(Duration(milliseconds: 500)); // simulate loading
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        username.value = userDoc['name'] ?? '';
        email.value = userDoc['email'] ?? '';
        phone.value = userDoc['phone'] ?? '';
        balance.value = (userDoc['totalBalance'] ?? 0).toInt();
        gareenaMatches.value = (userDoc['garenaPlayed'] ?? 0).toInt();
        ludoMatches.value = (userDoc['ludoPlayed'] ?? 0).toInt();
        carrumMatches.value = (userDoc['carromPlayed'] ?? 0).toInt();
        avatar.value = (userDoc['avatar'] ?? 0).toInt();
      }
    } catch (e) {
      print("❌ Error fetching user data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
