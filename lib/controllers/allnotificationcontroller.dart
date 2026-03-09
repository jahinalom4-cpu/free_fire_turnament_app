import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final userDeviceToken = RxnString();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadDeviceToken();
  }

  Future<void> loadDeviceToken() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      userDeviceToken.value = userDoc.data()?['deviceToken'];
    }
    isLoading.value = false;
  }

  Stream<List<Map<String, dynamic>>> getFilteredNotifications() {
    return FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((data) {
        final targetToken = data['deviceToken'];
        return targetToken == null ||
            targetToken.isEmpty ||
            targetToken == userDeviceToken.value;
      })
          .toList();
    });
  }
}
