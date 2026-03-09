import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tournament_freefire/controllers/refercontroller.dart';

class Refer extends StatelessWidget {
  const Refer({super.key});

  @override
  Widget build(BuildContext context) {
    final ReferController controller = Get.put(ReferController());

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Refer & Earn", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F1B24),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Invite your friends and earn rewards!",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Referral Code Box
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white54),
              ),
              child: Column(
                children: [
                  const Text("Your Referral Code", style: TextStyle(color: Colors.white54)),
                  const SizedBox(height: 10),
                  Text(
                    controller.referralCode.value.isNotEmpty
                        ? controller.referralCode.value
                        : "N/A",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (controller.referralCode.value.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: controller.referralCode.value));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Referral code copied!")),
                            );
                          }
                        },
                        icon: const Icon(Icons.copy, size: 20),
                        label: const Text("Copy"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (controller.referralCode.value.isNotEmpty) {
                            Share.share("Use my referral code ${controller.referralCode.value} and earn rewards! 🚀");
                          }
                        },
                        icon: const Icon(Icons.share, size: 20),
                        label: const Text("Share"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1B24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How it works:",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "• Share your code with friends.\n"
                        "• They use your code while signing up.\n"
                        "• You both earn bonus when they deposit!\n",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Earnings (Optional)
            if (controller.totalEarned.value.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Earned:", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    Text(
                      "৳ ${controller.totalEarned.value}",
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      )),
    );
  }
}
