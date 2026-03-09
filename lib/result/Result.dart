import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  Future<void> _launchVideo(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open the video.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error launching video: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('result_sheets')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No results found', style: TextStyle(color: Colors.white)));
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final prizes = data['prizes'] ?? {};

                return ResultBox(
                  timeZone: data['timeZone'] ?? '',
                  game: data['gameType'] ?? '',
                  totalPrize: "800tk", // You can fetch dynamically if available
                  matchNo: data['matchNumber'] ?? '',
                  firstWinner: prizes['first'] ?? '',
                  secondWinner: prizes['second'] ?? '',
                  thirdWinner: prizes['third'] ?? '',
                  fourthWinner: prizes['fourth'] ?? '',
                  watchMatchOntap: () => _launchVideo(context, data['videoUrl'] ?? ''),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
