import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/controllers/signUpController.dart';

class SignUPScreen extends StatelessWidget {
  SignUPScreen({super.key});
  final controller = Get.put(SignUpController());

  Widget _buildAvatarSelector() {
    final avatarCount = 5;
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(avatarCount, (index) {
            final avatarPath = 'assets/avatars/avatar${index + 1}.png';
            final isSelected = controller.selectedAvatarIndex.value == index;

            return GestureDetector(
              onTap: () => controller.selectedAvatarIndex.value = index,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.lightBlue : Colors.white10,
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: isSelected ? 50 : 30,
                  child: CircleAvatar(
                    radius: 300,
                    backgroundImage: AssetImage(avatarPath),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text("Select Your Avatar", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            _buildAvatarSelector(),
            const SizedBox(height: 20),
            textfiled(Controller: controller.nameController, hintText: "Name", title: "Name"),
            textfiled(Controller: controller.emailController, hintText: "Email", title: "Email"),
            textfiled(Controller: controller.phoneController, hintText: "Phone", title: "Phone"),
            textfiled(Controller: controller.newPasswordController, hintText: "Password", title: "Password", obscureText: true),
            textfiled(Controller: controller.confirmPasswordController, hintText: "Confirm Password", title: "Confirm Password", obscureText: true),
            textfiled(Controller: controller.referralCodeController, hintText: "Referral Code (optional)", title: "Referral Code"),
            const SizedBox(height: 20),
            Obx(() => Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Colors.lightBlue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: GestureDetector(
                onTap: controller.signUpUser,
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : const Center(child: Text("Sign Up", style: TextStyle(fontSize: 25, color: Colors.white))),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
