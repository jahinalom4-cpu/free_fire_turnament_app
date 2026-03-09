import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/controllers/join_match_controller.dart';

class JoinMatch extends StatelessWidget {
  final String matchId;
  final Map<String, dynamic> matchData;

  const JoinMatch({
    Key? key,
    required this.matchId,
    required this.matchData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JoinMatchController(matchId: matchId, matchData: matchData));

    return Obx(() {
      if (controller.userData.value == null) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: const Center(
            child: CircularProgressIndicator(color: Colors.red),
          ),
        );
      }

      final data = matchData;
      final entryFee = int.tryParse(data['entryFee'].toString()) ?? 0;
      final gameType = data['gameType'] ?? 'Unknown';
      final maxPlayers = int.tryParse(data['maxPlayers'].toString()) ?? 100;
      final joinedCount = controller.joinedPeople.fold<int>(0, (sum, item) => sum + (item['names'] as List).length);
      final remainingSlots = maxPlayers - joinedCount;
      final startTime = data['startTime'] ?? 'Unknown';
      final rulesLines = (gameType == "BR MATCH" ? controller.brMatchRules :gameType == "Clash Squad" ?controller.ClashSquadRulls :gameType ==  "Lone Wolf" ?controller.LoneWolfRulls :controller.otherRules).trim().split('\n');

      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: const Text("Join Match", style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              infoBox(startTime, remainingSlots),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Match Rules:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    const SizedBox(height: 8),
                    ...List.generate(
                      controller.isExpanded.value ? rulesLines.length : (rulesLines.length < 3 ? rulesLines.length : 3),
                          (index) => Text(rulesLines[index], style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    if (rulesLines.length > 3)
                      TextButton(
                        onPressed: controller.toggleExpanded,
                        child: Text(
                          controller.isExpanded.value ? "Read Less" : "Read More",
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    const Divider(),
                    buildSelectionSection(controller, entryFee),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: controller.isJoining.value ? null : controller.joinMatch,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          controller.isJoining.value ? "Joining..." : "Join Now",
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text("Players Already Joined:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    ...controller.joinedPeople.map(
                          (player) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          (player['names'] as List).join(', '),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget infoBox(String startTime, int remainingSlots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 70,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Room details will be shared 8–10 minutes before match start time.",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            "Start Time: $startTime",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Text(
            "Remaining Slots: $remainingSlots",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget buildSelectionSection(JoinMatchController controller, int entryFee) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      controller.selectedOption.value ==1 ?  Text(
            "Entry Fee: Tk$entryFee", style: const TextStyle(color: Colors.white, fontSize: 16))
          : Text("Entry Fee: Tk${entryFee*2} ",style: TextStyle(color: Colors.white, fontSize: 16),),
        const SizedBox(height: 10),
        const Text("Select Team Type:", style: TextStyle(color: Colors.white, fontSize: 16)),
        ListTile(
          title: const Text("Solo", style: TextStyle(color: Colors.white)),
          leading: Radio<int>(
            value: 1,
            groupValue: controller.selectedOption.value,
            onChanged: (value) => controller.updateSelectedOption(value!),
          ),
        ),
        ListTile(
          title: const Text("Duo", style: TextStyle(color: Colors.white)),
          leading: Radio<int>(
            value: 2,
            groupValue: controller.selectedOption.value,
            onChanged: (value) => controller.updateSelectedOption(value!),
          ),
        ),
        ...List.generate(controller.selectedOption.value, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: TextField(
              onChanged: (value) => controller.updateEnteredName(index, value),
              decoration: InputDecoration(
                labelText: "Player ${index + 1} Name",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          );
        }),
      ],
    ));
  }
}
