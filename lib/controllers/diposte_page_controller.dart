import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/notification/notification_service.dart';

class DepositController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController senderNumberController = TextEditingController();
  final TextEditingController transactionIdController = TextEditingController();

  final RxString selectedMethod = ''.obs;
  final RxBool isLoading = false.obs;


  void setPaymentMethod(String method) {
    selectedMethod.value = method;
  }

  Future<void> submitPayment(BuildContext context) async {
    if (selectedMethod.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a payment method")),
      );
      return;
    }

    if (amountController.text.isEmpty ||
        senderNumberController.text.isEmpty ||
        transactionIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    isLoading.value = true; // start loading

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        isLoading.value = false;
        return;
      }

      await FirebaseFirestore.instance.collection('paymentTransactions').add({
        'type': 'deposit',
        'uid': currentUser.uid,
        'amount': amountController.text.trim(),
        'transactionId': transactionIdController.text.trim(),
        'paymentMethod': selectedMethod.value,
        'senderNumber': senderNumberController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      await NotificationService.sendNotificationToAllAdmins(
        title: "Deposit",
        body: "${currentUser.email} Deposit ${amountController.text.trim()} ",
      );
     Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment submitted successfully")),
      );

      // Clear fields
      amountController.clear();
      senderNumberController.clear();
      transactionIdController.clear();
      selectedMethod.value = '';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      isLoading.value = false; // stop loading
    }
  }

}
