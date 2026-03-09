// pages/freefire_zone.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/controllers/FreeFireZone_controller.dart';
import 'package:tournament_freefire/freefire_zone/match.dart';

class FreefireZone extends StatelessWidget {
  FreefireZone({super.key});
  final controller = Get.put(FreefireZoneController());

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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final counts = controller.matchCounts;

        return SingleChildScrollView(
          child: Column(
            children: [
              MatchOvervewBox(
                image: "assets/images/onevsone.jpg",
                gameType: "BR MATCH",
                number: counts['BR MATCH']?.toString() ?? "0",
                color: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Match(gameType: "BR MATCH")),
                  );
                },
              ),
              MatchOvervewBox(
                image: "assets/images/squadvssquad.jpg",
                gameType: "Clash Squad",
                number: counts['Clash Squad']?.toString() ?? "0",
                color: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Match(gameType: "Clash Squad")),
                  );
                },
              ),
              MatchOvervewBox(
                image: "assets/images/lonewolf.jpg",
                gameType: "Lone Wolf",
                number: counts['Lone Wolf']?.toString() ?? "0",
                color: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Match(gameType: "Lone Wolf")),
                  );
                },
              ),
              MatchOvervewBox(
                image: "assets/images/2vs2.jpg",
                gameType: "CS2 VS 2",
                number: counts['CS2 VS 2']?.toString() ?? "0",
                color: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Match(gameType: "CS2 VS 2")),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
