import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  var currentNaIndex = 2.obs;
  var rulesShown = false.obs; // Add this line
}

// controllers/homepage_controller.dart

class HomepageController extends GetxController {
  final pageController = PageController(viewportFraction: 0.9);
  Timer? _timer;
  var currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (pageController.hasClients && sliders.isNotEmpty) {
        currentPage.value = (currentPage.value + 1) % sliders.length;
        pageController.animateToPage(
          currentPage.value,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  final sliders = <QueryDocumentSnapshot>[].obs;

  StreamSubscription? _sliderSubscription;

  void fetchSliders() {
    _sliderSubscription = FirebaseFirestore.instance
        .collection('sliders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      sliders.value = snapshot.docs;
    });
  }

  @override
  void onReady() {
    super.onReady();
    fetchSliders();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    _sliderSubscription?.cancel();
    super.onClose();
  }
}



class SliderWithAutoScroll extends StatelessWidget {
  final controller = Get.find<HomepageController>();

  _launchURL(BuildContext context, String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Could not launch URL")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: controller.sliders.length,
            onPageChanged: (index) => controller.currentPage.value = index,
            itemBuilder: (context, index) {
              final data = controller.sliders[index].data() as Map<String, dynamic>;
              final title = data['title'] ?? '';
              final url = data['url'] ?? '';
              final videoId = Uri.parse(url).queryParameters['v'] ?? Uri.parse(url).pathSegments.last;

              return GestureDetector(
                onTap: () => _launchURL(context, url),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70, width: 3),
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage('https://img.youtube.com/vi/$videoId/0.jpg'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 4)),
                    ],
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.black45,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(controller.sliders.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: controller.currentPage.value == i ? 12 : 8,
              height: controller.currentPage.value == i ? 12 : 8,
              decoration: BoxDecoration(
                color: controller.currentPage.value == i ? Colors.deepPurple : Colors.grey,
                shape: BoxShape.circle,
              ),
            );
          }),
        )),
      ],
    );
  }
}
