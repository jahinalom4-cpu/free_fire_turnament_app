import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tournament_freefire/Home/home_controller.dart';

import 'package:tournament_freefire/freefire_zone/Game_zone.dart';
import 'package:tournament_freefire/freefire_zone/carrum_zone.dart';
import 'package:tournament_freefire/freefire_zone/ludo_zone.dart';
import 'package:tournament_freefire/Request&notifications/allRequest&Notifications.dart';
import 'package:tournament_freefire/wallet/My_wallet.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomepageController());

    return Scaffold(
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("BD Hunter", style: TextStyle(color: Colors.white, fontSize: 22)),
                  const SizedBox(width: 50),
                  IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AllNotificationRequest())),
                    icon: const Icon(Icons.notifications_active, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyWallet())),
                    child: Image.asset("assets/images/wallet.png", width: 30, height: 30),
                  ),
                ],
              ),
            ),

            Obx(() {
              if (controller.sliders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return SliderWithAutoScroll();
            }),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FreefireZone())),
              child: Container(
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 3, color: Colors.white54),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/freefireon.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZoneBox(
                    ontap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LudoZone())),
                    image: "assets/images/luudoking.jpg"),
                ZoneBox(
                    ontap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Carrum_zone())),
                    image: "assets/images/carrum.png"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
