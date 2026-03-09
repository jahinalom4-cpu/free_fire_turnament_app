import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/notification/notification_service.dart';
import 'package:uuid/uuid.dart';

class WidrawallController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController senderNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var selectedMethod = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  Future<void> submitWidrawal(BuildContext context) async {
    isLoading.value = true; // Start loading spinner

    try {
      final amountText = amountController.text.trim();
      final sender = senderNumberController.text.trim();
      final password = passwordController.text.trim();
      final method = selectedMethod.value;

      if (amountText.isEmpty || sender.isEmpty || password.isEmpty || method.isEmpty) {
        showError("Please fill in all fields and select a payment method");
        return;
      }

      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        showError("User not logged in");
        return;
      }

      final double? amount = double.tryParse(amountText);
      if (amount == null || amount <= 0) {
        showError("Please enter a valid withdrawal amount");
        return;
      }

      // Re-authenticate
      final credential = EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);

      // Get user balance
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists || !userDoc.data()!.containsKey('totalBalance')) {
        showError("User balance data not found");
        return;
      }

      final currentBalance = userDoc['totalBalance'];
      if (amount > currentBalance) {
        showError("Insufficient balance");
        return;
      }

      final transactionId = const Uuid().v4();
      final batch = FirebaseFirestore.instance.batch();

      batch.update(userDocRef, {
        'totalBalance': FieldValue.increment(-amount),
      });

      final transactionRef = FirebaseFirestore.instance.collection('paymentTransactions').doc();
      batch.set(transactionRef, {
        'amount': amount,
        'paymentMethod': method,
        'senderNumber': sender,
        'timestamp': Timestamp.now(),
        'transactionId': transactionId,
        'type': 'widrawall',
        'uid': user.uid,
        'status': 'pending',
      });

      await batch.commit();

      await NotificationService.sendNotificationToAllAdmins(
        title: "Withdrawal",
        body: "${user.displayName ?? user.email} sent a withdrawal request",
      );

      Get.snackbar("Success", "Withdrawal request submitted (Pending)",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      clearFields();
    } catch (e) {
      showError("Authentication Failed: Incorrect password or an error occurred");
    } finally {
      isLoading.value = false;
      Navigator.pop(context);// Stop loading spinner regardless of success/failure
    }
  }

  void clearFields() {
    amountController.clear();
    senderNumberController.clear();
    passwordController.clear();
    selectedMethod.value = '';
  }

  void showError(String message) {
    isLoading.value = false;
    Get.snackbar("Error", message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
  }
}
