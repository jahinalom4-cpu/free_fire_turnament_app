import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/controllers/spash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(() => controller.isLoading.value
            ? Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(image: AssetImage("assets/images/bdhunter.png"),fit: BoxFit.fitHeight)
          ),
        )
            : Center(
              child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),

                image: DecorationImage(image: AssetImage("assets/images/bdhunter.png"),fit: BoxFit.fitHeight)
                        ),
                      ),
            )), // Show nothing once done
      ),
    );
  }
}
