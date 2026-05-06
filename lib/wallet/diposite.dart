import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/controllers/diposte_page_controller.dart';

class Diposite extends StatelessWidget {
  const Diposite({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DepositController());

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1B24),
        title: const Text("Deposit", style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Send money to the following number:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            paymentInfoTile("assets/images/bikash.png", "Bkash: 01907158352"),
            const SizedBox(height: 10),
            paymentInfoTile("assets/images/nogod.png", "Nagad: 01907158352"),
            const SizedBox(height: 10),
            paymentInfoTile("assets/images/rocket.jpeg", "Rocket: 01907158352"),
            const SizedBox(height: 20),
            const Text(
              "Note1: Pay first and then verify please     "
               "Note2:Minimum deposit amount is 10 TK",
              style: TextStyle(color: Colors.redAccent),
            ),
            const SizedBox(height: 20),

            textfiled(
              Controller: controller.amountController,
              hintText: "Sent Amount (TK)",
              title: "Enter Amount",
            ),
            const SizedBox(height: 16),

            textfiled(
              Controller: controller.senderNumberController,
              hintText: "Your Payment Number",
              title: "Enter Your Number",
            ),
            const SizedBox(height: 16),

            textfiled(
              Controller: controller.transactionIdController,
              hintText: "Transaction ID",
              title: "Enter Transaction ID",
            ),

            const SizedBox(height: 30),
            const Text(
              "Select Payment Method:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                miniCheckbox("Bkash", "assets/images/bikash.png", controller),
                miniCheckbox("Nagad", "assets/images/nogod.png", controller),
                miniCheckbox("Rocket", "assets/images/rocket.jpeg", controller),
              ],
            ),


            const SizedBox(height: 30),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isLoading.value ? null : () => controller.submitPayment(context),
                icon: controller.isLoading.value
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.verified, color: Colors.white),
                label: Text(
                  controller.isLoading.value ? "Processing..." : "Verify Payment",
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ))

          ],
        ),
      ),
    );
  }

  Widget paymentInfoTile(String imagePath, String text) {
    return Row(
      children: [
        Image.asset(imagePath, width: 40, height: 40),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }

  Widget miniCheckbox(String method, String image, DepositController controller) {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Checkbox(
            value: controller.selectedMethod.value == method,
            onChanged: (_) => controller.setPaymentMethod(method),
            side: const BorderSide(color: Colors.black),
            checkColor: Colors.black,
            activeColor: Colors.purpleAccent,
          )),
          Image.asset(image, height: 30, width: 30),
        ],
      ),
    );
  }
}
