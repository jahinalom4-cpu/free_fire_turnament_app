import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/firebase/firebase_service.dart';
import 'package:tournament_freefire/notification/notification_service.dart';

class TopUp extends StatelessWidget {
  final String type;
  const TopUp({super.key, required this.type});

  void _handleBuyDiamonds(BuildContext context, Map<String, dynamic> data) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      _showMessage(context, "User not authenticated.");
      return;
    }

    final int price = int.tryParse(data['prize'].toString()) ?? 0;

    try {
      final userDoc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final userData = userDoc.data();

      if (userData == null) {
        _showMessage(context, "User data not found.");
        return;
      }

      final userBalance = _parseBalance(userData['totalBalance']);
      final userName = userData['name']?.toString() ?? 'Unknown';

      if (userBalance < price) {
        _showMessage(context, "Insufficient balance.");
        return;
      }

      _showIdDialog(context, data, userBalance, uid, userName);
    } catch (e) {
      print("Error in _handleBuyDiamonds: $e");
      _showMessage(context, "Something went wrong. Please try again.");
    }
  }

  int _parseBalance(dynamic raw) {
    if (raw is int) return raw;
    if (raw is double) return raw.toInt();
    return int.tryParse(raw.toString()) ?? 0;
  }

  void _showIdDialog(BuildContext context, Map<String, dynamic> data,
      int userBalance, String uid, String userName) {
    final TextEditingController ffIdController = TextEditingController();
    bool isProcessing = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text("Enter Free Fire ID", style: TextStyle(color: Colors.white)),
              content: TextField(
                controller: ffIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Your Free Fire ID",
                  hintStyle: TextStyle(color: Colors.white54),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: isProcessing
                      ? null
                      : () async {
                    setState(() => isProcessing = true);
                    final String ffId = ffIdController.text.trim();
                    final int price = int.tryParse(data['prize'].toString()) ?? 0;
                    final String count = data['count']?.toString() ?? '0';

                    if (ffId.isEmpty) {
                      _showMessage(context, "Free Fire ID is required.");
                      setState(() => isProcessing = false);
                      return;
                    }

                    try {
                      await createPurchaseRequest(
                        context: context,
                        uid: uid,
                        ffId: ffId,
                        price: price,
                        count: count,
                      );

                      await NotificationService.sendNotificationToAllAdmins(
                        title: "Diamond Purchase Request",
                        body: "$userName wants to buy a diamond package. Please confirm it.",
                      );
                    } catch (e) {
                      _showMessage(context, "Something went wrong. Please try again.");
                      setState(() => isProcessing = false);
                    }
                  },
                  child: isProcessing
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.greenAccent),
                  )
                      : const Text("Buy", style: TextStyle(color: Colors.greenAccent)),
                ),
                TextButton(
                  onPressed: isProcessing ? null : () => Navigator.of(context).pop(),
                  child: const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(msg, style: const TextStyle(color: Colors.white)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset("assets/images/freefireicon.png", width: 200, height: 50),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 30),
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Diamonds_packeges")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No TopUp packages found.",
                  style: TextStyle(color: Colors.white)),
            );
          }

          final topUpItems = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['type'] == type;
          }).toList();

          if (topUpItems.isEmpty) {
            return const Center(
              child: Text("No TopUp packages found.",
                  style: TextStyle(color: Colors.white)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: topUpItems.length,
            itemBuilder: (context, index) {
              final data = topUpItems[index].data() as Map<String, dynamic>;
              final count = data['count'] ?? 'N/A';
              final prize = data['prize'] ?? 'N/A';

              return Diamond(
                OnTapForBuyingDiamonds: () => _handleBuyDiamonds(context, data),
                BuyPendingTitle: "Buy",
                image: "assets/images/dimond.jpg",
                title: "$prize TK",
                number: count,
                color: Colors.white,
              );
            },
          );
        },
      ),
    );
  }

  Future<void> createPurchaseRequest({
    required BuildContext context,
    required String uid,
    required String ffId,
    required int price,
    required String count,
  }) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final requestRef = FirebaseFirestore.instance.collection('requests');

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);
        final userData = userSnapshot.data();
        if (userData == null) throw Exception("User data not found.");

        final int currentBalance = _parseBalance(userData['totalBalance']);

        if (currentBalance < price) {
          throw Exception("Insufficient balance");
        }

        final updatedBalance = currentBalance - price;

        transaction.update(userRef, {'totalBalance': updatedBalance});

        transaction.set(requestRef.doc(), {
          'uid': uid,
          'ffId': ffId,
          'price': price,
          'count': count,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Request submitted successfully!",
            style: TextStyle(color: Colors.white)),
      ));
    } catch (e) {
      print('Error in createPurchaseRequest: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Something went wrong. Please try again.",
            style: TextStyle(color: Colors.white)),
      ));
      rethrow;
    }
  }
}
