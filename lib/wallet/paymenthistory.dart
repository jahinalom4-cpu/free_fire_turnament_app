import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Paymenthistory extends StatelessWidget {
  const Paymenthistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment History"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = authSnapshot.data;
          if (user == null) {
            return const Center(child: Text("User not logged in."));
          }

          final uid = user.uid;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('paymentTransactions')
                .where('uid', isEqualTo: uid)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No transactions yet."));
              }

              final transactions = snapshot.data!.docs;

              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final doc = transactions[index];
                  final data = doc.data() as Map<String, dynamic>;

                  // Double-check that UID still matches, just in case
                  if (data['uid'] != uid) return const SizedBox.shrink();

                  final amount = data['amount'] ?? '';
                  final method = data['paymentMethod'] ?? '';
                  final sender = data['senderNumber'] ?? '';
                  final type = data['type'] ?? '';
                  final transactionId = data['transactionId'] ?? '';
                  final timestamp = (data['timestamp'] as Timestamp).toDate();

                  final rawStatus = data['status'];
                  final status = (rawStatus is String && rawStatus.isNotEmpty)
                      ? rawStatus.toLowerCase()
                      : 'pending';

                  Color? statusColor;
                  Color? statusTextColor;

                  switch (status) {
                    case 'success':
                      statusColor = Colors.green[100];
                      statusTextColor = Colors.green;
                      break;
                    case 'failed':
                      statusColor = Colors.red[100];
                      statusTextColor = Colors.red;
                      break;
                    default:
                      statusColor = Colors.orange[100];
                      statusTextColor = Colors.orange;
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.payments, color: Colors.deepPurple),
                              const SizedBox(width: 8),
                              Text(
                                '৳ $amount',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status[0].toUpperCase() + status.substring(1),
                                  style: TextStyle(
                                    color: statusTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Type: $type'),
                          Text('Method: $method'),
                          Text('Sender Number: $sender'),
                          Text('Transaction ID: $transactionId'),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              timeago.format(timestamp),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
