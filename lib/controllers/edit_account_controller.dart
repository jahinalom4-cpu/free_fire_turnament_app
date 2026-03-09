import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditAccountController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var selectedAvatarIndex = 0.obs;
  var isLoading = false.obs;

  User? get user => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();
      final data = snapshot.data();
      if (data != null) {
        nameController.text = data['name'] ?? '';
        phoneController.text = data['phone'] ?? '';
        selectedAvatarIndex.value = data['avatar'] ?? 0;
      }
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null) return;

    isLoading.value = true;

    // Handle password change if fields are filled
    if (oldPasswordController.text.isNotEmpty ||
        newPasswordController.text.isNotEmpty ||
        confirmPasswordController.text.isNotEmpty) {
      if (newPasswordController.text != confirmPasswordController.text) {
        isLoading.value = false;
        Get.snackbar("Error", "New passwords do not match", snackPosition: SnackPosition.BOTTOM);
        return;
      }

      try {
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPasswordController.text,
        );
        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPasswordController.text);
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Password update failed", e.toString(), snackPosition: SnackPosition.BOTTOM);
        return;
      }
    }

    // Update Firestore profile info regardless of password change
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'name': nameController.text,
        'phone': phoneController.text,
        'avatar': selectedAvatarIndex.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Get.snackbar("Success", "Changes saved successfully", snackPosition: SnackPosition.BOTTOM);

      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Get.back();
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }

    isLoading.value = false;
  }

  void resetAvatar() {
    selectedAvatarIndex.value = 0;
    Get.snackbar("Info", "Avatar reset to default.", snackPosition: SnackPosition.BOTTOM);
  }

  void selectAvatar(int index) {
    selectedAvatarIndex.value = index;
    Get.back();
  }
}
