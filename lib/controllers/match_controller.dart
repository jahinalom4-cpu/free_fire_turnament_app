import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchController extends GetxController {
  final userBalance = 0.00.obs;
  final currentUserName = ''.obs;
  final isLoading = true.obs;
  final matchDocs = <QueryDocumentSnapshot>[].obs;
  final user = FirebaseAuth.instance.currentUser;

  String? get currentUserUid => user?.uid;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();
  }

  Future<void> fetchCurrentUser() async {
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (userDoc.exists) {
        currentUserName.value = userDoc['name'];
        if (userDoc.data()!.containsKey('totalBalance')) {
          userBalance.value = userDoc['totalBalance']?.toDouble() ?? 0.0;
        }
      }
    }
  }

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not open the link.");
    }
  }


  Stream<QuerySnapshot> fetchMatches(String? gameType) {
    return FirebaseFirestore.instance
        .collection('matches')
        .where('gameType', isEqualTo: gameType)
        .orderBy('matchDateTime', descending: true)
        .snapshots();
  }

  bool hasUserJoined(List joinedPeople) {
    return joinedPeople.any((player) => player['uid'] == currentUserUid);
  }

  void showDialogBox(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void showRoomDetails(String roomId, String roomPin) {
    Get.dialog(
      AlertDialog(
        title: const Text("Room Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Room ID: $roomId"),
            const SizedBox(height: 10),
            Text("Room Pin: $roomPin"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void showPrizeDetails(Map<String, dynamic> prizes) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.emoji_events, color: Colors.amber),
            SizedBox(width: 8),
            Text("Prize Details", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPrizeRow("👑 First Prize", prizes['first']),
            const SizedBox(height: 8),
            buildPrizeRow("🥈 Second Prize", prizes['second']),
            const SizedBox(height: 8),
            buildPrizeRow("🥉 Third Prize", prizes['third']),
            const SizedBox(height: 8),
            buildPrizeRow("🎖 Fourth Prize", prizes['fourth']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("CLOSE", style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  Widget buildPrizeRow(String title, dynamic prize) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Colors.white)),
        const SizedBox(width: 8),
        Text(prize?.toString() ?? '-', style: const TextStyle(color: Colors.amber)),
      ],
    );
  }
}
