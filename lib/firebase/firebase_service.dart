import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tournament_freefire/models/user_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔐 Sign In with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Email SignIn Error: $e");
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
          image: imageUrl ?? '',
        );

// Now save all fields of the AppUser object
//         await _firestore.collection('users').doc(user.uid).set(appUser.toJson());
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'totalBalance': 0,
          'winningBalance': 0,
          'depositBalance': 0,
          'referBalance': 0,
          'garenaPlayed': 0,
          'ludoPlayed': 0,
          'carromPlayed': 0,
          'Request&notifications': [],
          'createdAt': FieldValue.serverTimestamp(),
          // ...add other defaults you want
        });

      }

      return user;
    } catch (e) {
      print("Email SignUp Error: $e");
      return null;
    }
  }

  // 🔐 Sign In with Google and save to Firestore (if new)
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          final appUser = AppUser(
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            phone: '', // Google sign-in won't provide this
            password: '', // Google sign-in doesn't need this
            image: user.photoURL ?? '',
          );

          await _firestore.collection('users').doc(user.uid).set(appUser.toJson());
        }
      }

      return user;
    } catch (e) {
      print("Google SignIn Error: $e");
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
        print("User document not found in Firestore.");
        return null;
      }
    } catch (e) {
      print("Get User Data Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<void> updateDeviceToken(String userId, String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'deviceToken': token});
  }



  // 👤 Get Current User
  User? get currentUser => _auth.currentUser;
}

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
      _showMessage(context, "User not found.");
      return;
    }

    final userData = userDoc.data()!;
    final userBalance = userData['totalBalance'] ?? 0;
    final deviceToken = userData['deviceToken'] ?? '';

    if (userBalance < price) {
      _showMessage(context, "Insufficient balance.");
      return;
    }

    // Create the request
    await FirebaseFirestore.instance.collection("requests").add({
      "userId": uid,
      "ffId": ffId,
      "packageCount": count,
      "price": price,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
      "deviceToken": deviceToken,
    });

    // Deduct the user's balance
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "totalBalance": userBalance - price,
    });

    Navigator.of(context).pop();
    _showMessage(context, "Request submitted successfully.");
  } catch (e) {
    _showMessage(context, "Something went wrong: $e");
  }
}


void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
