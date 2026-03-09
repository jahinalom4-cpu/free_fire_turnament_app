import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/controllers/edit_account_controller.dart';
class EditeAcconut extends StatelessWidget {
  const EditeAcconut({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditAccountController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text("Edit Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Obx(() => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Obx(() => CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/avatars/avatar${controller.selectedAvatarIndex.value}.png'),
                    )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showAvatarPicker(context, controller),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          child: Icon(Icons.edit, size: 20, color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: controller.resetAvatar,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text("Remove Avatar", style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 30),
              textfiled(Controller: controller.nameController, hintText: "Name", title: "Name"),
              const SizedBox(height: 16),
              textfiled(Controller: controller.phoneController, hintText: "Phone Number", title: "Phone Number"),
              const SizedBox(height: 30),
              const Divider(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Change Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16),
              passwordtextField(controller: controller.oldPasswordController, title: "Old Password"),
              const SizedBox(height: 16),
              passwordtextField(controller: controller.newPasswordController, title: "New Password"),
              const SizedBox(height: 16),
              passwordtextField(controller: controller.confirmPasswordController, title: "Confirm Password"),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.saveChanges(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Save Changes", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  void _showAvatarPicker(BuildContext context, EditAccountController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => controller.selectAvatar(index),
                child: Obx(() => CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/avatars/avatar$index.png'),
                  backgroundColor: controller.selectedAvatarIndex.value == index ? Colors.blue : Colors.grey,
                )),
              );
            }),
          ),
        );
      },
    );
  }
}
