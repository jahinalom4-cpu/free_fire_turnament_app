// controllers/freefire_zone_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FreefireZoneController extends GetxController {
  var matchCounts = <String, int>{}.obs;
  var isLoading = true.obs;

  final gameTypes = [
    'BR MATCH',
    'Clash Squad',
    'Lone Wolf',
    'CS2 VS 2',
    'Ludo(Single vs Single)',
    'Ludo Squad',
    'Ludo(Single4)',
    '(Single vs Single)',
    'Carrum Squad'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMatchCounts();
  }

  Future<void> fetchMatchCounts() async {
    try {
      final counts = <String, int>{};
      for (var type in gameTypes) {
        final snapshot = await FirebaseFirestore.instance
            .collection('matches')
            .where('gameType', isEqualTo: type)
            .get();
        counts[type] = snapshot.docs.length;
      }
      matchCounts.value = counts;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch match counts');
    } finally {
      isLoading.value = false;
    }
  }
}
