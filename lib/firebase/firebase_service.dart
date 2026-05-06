import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// FIX 1: Corrected the hide clause to ensure GoogleSignIn comes from the right package
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tournament_freefire/models/user_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // FIX 2: Create a single instance of GoogleSignIn for the class
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 🔐 Sign In with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      debugPrint("Email SignIn Error: $e");
      return null;
    }
  }

  // 📝 Sign Up with Email & Password and save to Firestore
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String imageUrl,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = result.user;
      if (user != null) {
        final appUser = AppUser(
          uid: user.uid,
          name: name,
          email: email,
          phone: phone,
          password: password,
          image: imageUrl,
        );

        await _firestore.collection('users').doc(user.uid).set({
          ...appUser.toJson(), // Use your model's toJson
          'totalBalance': 0,
          'winningBalance': 0,
          'depositBalance': 0,
          'referBalance': 0,
          'garenaPlayed': 0,
          'ludoPlayed': 0,
          'carromPlayed': 0,
          'Request_Notifications':
              [], // Fixed potential special character issue
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      debugPrint("Email SignUp Error: $e");
      return null;
    }
  }

  // 🔐 Sign In with Google and save to Firestore (if new)
  Future<User?> signInWithGoogle() async {
    try {
      // FIX 3: Use the class-level instance
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result =
          await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          final appUser = AppUser(
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            phone: '',
            password: '',
            image: user.photoURL ?? '',
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(appUser.toJson());
        }
      }

      return user;
    } catch (e) {
      debugPrint("Google SignIn Error: $e");
      return null;
    }
  }

  // 📥 Get User Data by UID from Firestore
  Future<AppUser?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromJson(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Get User Data Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<void> updateDeviceToken(String userId, String token) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({'deviceToken': token});
  }

  User? get currentUser => _auth.currentUser;
}

// Global functions (consider moving these to a controller)
Future<void> createPurchaseRequest({
  required BuildContext context,
  required String uid,
  required String ffId,
  required int price,
  required int count,
}) async {
  try {
    final userDoc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (!userDoc.exists) {
      if (context.mounted) _showMessage(context, "User not found.");
      return;
    }

    final userData = userDoc.data()!;
    final userBalance = userData['totalBalance'] ?? 0;
    final deviceToken = userData['deviceToken'] ?? '';

    if (userBalance < price) {
      if (context.mounted) _showMessage(context, "Insufficient balance.");
      return;
    }

    await FirebaseFirestore.instance.collection("requests").add({
      "userId": uid,
      "ffId": ffId,
      "packageCount": count,
      "price": price,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
      "deviceToken": deviceToken,
    });

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "totalBalance": userBalance - price,
    });

    if (context.mounted) {
      Navigator.of(context).pop();
      _showMessage(context, "Request submitted successfully.");
    }
  } catch (e) {
    if (context.mounted) _showMessage(context, "Something went wrong: $e");
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
