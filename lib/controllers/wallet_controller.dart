import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tournament_freefire/firebase/firebase_service.dart';
import 'package:tournament_freefire/models/user_model.dart';

class WalletController extends GetxController {
  var user = Rxn<AppUser>();
  var isLoading = true.obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> refreshWidrawallData() async {
    // Put all refresh-related logic here.
    fetchUserData();
    // Add any other data-fetching logic if needed
    await Future.delayed(Duration(milliseconds: 500)); // simulate loading
  }

  void fetchUserData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final data = await FirebaseService().getUserData(uid);
        user.value = data;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
