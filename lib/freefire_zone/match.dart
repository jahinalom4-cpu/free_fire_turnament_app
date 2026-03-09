import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/controllers/match_controller.dart';
import 'package:tournament_freefire/freefire_zone/join_match.dart';

class Match extends StatelessWidget {
  final String? gameType;
  Match({super.key, this.gameType});

  final MatchController controller = Get.put(MatchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text("Matches For You", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.fetchMatches(gameType),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading matches", style: TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final matchDocs = snapshot.data!.docs;

          if (matchDocs.isEmpty) {
            return const Center(child: Text("No matches found", style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            itemCount: matchDocs.length,
            itemBuilder: (context, index) {
              final match = matchDocs[index].data() as Map<String, dynamic>;

              // Safely extract joinedPeople list
              final rawJoinedPeople = match['joinedPeople'];
              List<Map<String, dynamic>> joinedPeople = [];

              if (rawJoinedPeople is List) {
                joinedPeople = rawJoinedPeople
                    .whereType<Map<String, dynamic>>() // ensure only maps
                    .toList();
              } else if (rawJoinedPeople is Map) {
                joinedPeople = rawJoinedPeople.values
                    .whereType<Map<String, dynamic>>() // ensure only maps
                    .toList();
              }

              final maxPlayers = int.tryParse(match['maxPlayers'].toString()) ?? 1;

              final totalJoined = joinedPeople.fold<int>(0, (sum, person) {
                final names = person['names'] as List?;
                return sum + (names?.length ?? 0);
              });

              final progress = totalJoined / maxPlayers;
              final matchDateTimeField = match['matchDateTime'];

              DateTime matchDateTime;
              if (matchDateTimeField is Timestamp) {
                matchDateTime = matchDateTimeField.toDate();
              } else if (matchDateTimeField is String) {
                matchDateTime = DateTime.tryParse(matchDateTimeField) ?? DateTime.now();
              } else {
                matchDateTime = DateTime.now();
              }

              final now = DateTime.now().toUtc();
              final matchUtc = matchDateTime.toUtc();

              final MainGameType = match['MainGameType'];
              final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

              final onRoomDetails = () {
                if (currentUserUid == null) {
                  controller.showDialogBox("Error", "User not logged in.");
                  return;
                }
                final joined = controller.hasUserJoined(joinedPeople);
                if (!joined) {
                  controller.showDialogBox("Not Joined", "You have not joined the match yet.");
                  return;
                }

                final roomId = match['roomId'] ?? '';
                final roomPin = match['roomPin'] ?? '';

                if (roomId.isEmpty || roomPin.isEmpty) {
                  controller.showDialogBox("Room Info", "Room details available 10 minutes before match.");
                } else {
                  controller.showRoomDetails(roomId, roomPin);
                }
              };

              final onTapJoin = () {
                final entryFee = double.tryParse(match['entryFee'].toString()) ?? 0;

                if (joinedPeople.length >= maxPlayers) {
                  controller.showDialogBox("Match Full", "All slots are filled.");
                  return;
                }

                if (now.isAfter(matchUtc)) {
                  controller.showDialogBox("Match Expired", "Match already started.");
                  return;
                }

                if (controller.userBalance.value < entryFee) {
                  controller.showDialogBox("Low Balance", "Insufficient balance.");
                  return;
                }

                Get.to(() => JoinMatch(
                  matchId: matchDocs[index].id,
                  matchData: match,
                ));
              };

              return MainGameType == 'FreeFire'
                  ? MatchesBox(
                RoomDetailsOnTap: onRoomDetails,
                TotalPrizeDetailsOnTap: () => controller.showPrizeDetails(match['prizes']),
                onTap: onTapJoin,
                progress: progress,
                joinPlayerDetails: "${totalJoined.toString().padLeft(2, '0')}/${maxPlayers.toString().padLeft(2, '0')}",
                joinButtonTitle: DateTime.now().isAfter(matchUtc)
                    ? "Match Expired"
                    : joinedPeople.length == maxPlayers
                    ? "Match Full"
                    : "Join",
                gameType: match['gameType'] ?? '',
                totalPrize: match['totalPrize'] ?? '',
                perkill: match['perKill'] ?? '',
                entryfee: match['entryFee'] ?? '',
                playerStatus: match['playerStatus'] ?? '',
                version: match['version'] ?? '',
                map: match['map'] ?? '',
                roomId: match['roomId'] ?? '',
                roomPin: match['roomPin'] ?? '',
                first: match['prizes']?['first'] ?? '',
                second: match['prizes']?['second'] ?? '',
                third: match['prizes']?['third'] ?? '',
                fourth: match['prizes']?['fourth'] ?? '',
                timezone: DateFormat('yyyy-MM-dd HH:mm').format(matchDateTime.toLocal()),
              )
                  : LudoMatchBox(
                HowCanYouPlayeDetailsOnTap:(){
                  controller.openUrl("https://www.youtube.com/watch?v=z3z1MjENJ-w");
                },
                RoomDetailsOnTap: onRoomDetails,
                onTap: onTapJoin,
                progress: progress,
                joinPlayerDetails: "${joinedPeople.length.toString().padLeft(2, '0')}/${maxPlayers.toString().padLeft(2, '0')}",
                joinButtonTitle: DateTime.now().isAfter(matchUtc)
                    ? "Match Expired"
                    : joinedPeople.length == maxPlayers
                    ? "Match Full"
                    : "Join",
                gameType: match['gameType'] ?? '',
                totalPrize: match['totalPrize'] ?? '',
                entryfee: match['entryFee'] ?? '',
                version: match['version'] ?? '',
                roomId: match['roomId'] ?? '',
                roomPin: match['roomPin'] ?? '',
                timezone: DateFormat('yyyy-MM-dd HH:mm').format(matchDateTime.toLocal()),
                BoardType: match['gameType'] ?? '',
                winner: '',
                logo: match['MainGameType'] == "Carrum"
                    ? "assets/images/carrum.png"
                    : match['MainGameType'] == "FreeFire"
                    ? "assets/images/freefire.jpg"
                    : "assets/images/luudoking.jpg",
              );
            },
          );
        },
      ),
    );
  }
}
