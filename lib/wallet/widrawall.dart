import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/controllers/widrawall_controller.dart';

class Widrawall extends StatelessWidget {
  Widrawall({super.key});

  final controller = Get.put(WidrawallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1B24),
        title: const Text("Withdrawal", style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "withdraw your money with the following systems:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),

              const Text(
                "Note: Minimum Withdrawal amount is 100 TK",
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
                Controller: controller.passwordController,
                hintText: " Enter your Password",
                title: "Enter Your Password",
                obscureText: true,
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => controller.submitWidrawal(context),
                  icon: const Icon(Icons.verified, color: Colors.white),
                  label: const Text("Verify Payment", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget miniCheckbox(String method, String image, WidrawallController controller) {
    return Container(
      width: 90,
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
            onChanged: (val) {
              controller.selectedMethod.value = method;
            },
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
