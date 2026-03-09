import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

import 'package:tournament_freefire/Me_Account/edite_acconut.dart';
import 'package:tournament_freefire/controllers/accoutn_controller.dart';
import 'package:tournament_freefire/log_sign/login_page.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/notification/notification_service.dart';
import 'package:tournament_freefire/wallet/refer.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("👤 My Profile", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {

              Navigator.push(context, MaterialPageRoute(builder: (_) => EditeAcconut()));
            },
            icon: const Icon(Icons.edit, color: Colors.white, size: 28),
          )
        ],
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: controller.refreshWidrawallData,

        child: ListView(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage("assets/avatars/avatar${controller.avatar.value}.png"),
                      backgroundColor: Colors.grey.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  '💰 Balance: ৳${controller.balance}',
                  style: TextStyle(fontSize: 20, color: Colors.greenAccent.shade200),
                ),
                const SizedBox(height: 20),

                buildInfoRow('👤 Username:', controller.username.value),
                buildInfoRow('📧 Email:', controller.email.value),
                buildInfoRow('📞 Phone:', controller.phone.value),
                buildInfoRow('🎮 Gareena Matches:', '${controller.gareenaMatches}'),
                buildInfoRow('🎯 Ludo Matches:', '${controller.ludoMatches}'),
                buildInfoRow('🏏 Carrum Matches:', '${controller.carrumMatches}'),

                const SizedBox(height: 70),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    elevateButton(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Refer()));
                      },
                      icon: Icons.send_time_extension_outlined,
                      title: "Refer",
                      color: Colors.pinkAccent.withOpacity(0.8),
                    ),
                    elevateButton(
                      onTap: () {

                        Share.share(
                          "Use this link https://t.me/bdhunter473 and earn rewards! 🚀",
                          subject: "Join me on the app!",
                        );

                      },
                      icon: Icons.share,
                      title: "Share",
                      color: Colors.lightBlue,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                elevateButton(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                    );
                  },
                  icon: Icons.logout,
                  title: "Logout",
                  color: Colors.redAccent,
                ),
              ],
            ),
          )),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
          Expanded(
            flex: 5,
            child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
