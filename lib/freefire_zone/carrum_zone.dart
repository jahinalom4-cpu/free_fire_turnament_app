import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/controllers/FreeFireZone_controller.dart';
import 'package:tournament_freefire/freefire_zone/match.dart';

class Carrum_zone extends StatelessWidget {
   Carrum_zone({super.key});
   final controller = Get.put(FreefireZoneController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:Text("Carrum King Zone",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,

        leading:IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,size: 30,),color: Colors.white,),
      ),
      body: Obx( () {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final counts = controller.matchCounts;
        return SingleChildScrollView(
          child: Column(
            children: [

              MatchOvervewBox(
                  image: "assets/images/carrum.png",
                  gameType: "(Single vs Single)",
                  number:  "For",
                  color: Colors.white,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            Match(gameType: "Carrum(Single vs Single)",)));
                  }
              ),

              MatchOvervewBox(
                  image: "assets/images/carrum.png",
                  gameType: "Carrum Squad",
                  number:  "For",
                  color: Colors.white,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            Match(gameType: "Carrum Squad",)));
                  }
              ),


            ],
          ),
        );
      }
      ),
    );
  }
}
