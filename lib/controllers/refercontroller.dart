import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ReferController extends GetxController {
  var referralCode = ''.obs;
  var totalEarned = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReferralData();
  }

  void fetchReferralData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          referralCode.value = userDoc['referralCode'] ?? '';
          totalEarned.value = userDoc['totalBalance'].toString();
        }
      }
    } catch (e) {
      print("Error fetching referral code: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
