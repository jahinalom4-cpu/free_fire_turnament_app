import 'package:flutter/material.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/shop/topup.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset("assets/images/freefireicon.png",width: 200,height: 50,),
        centerTitle: true,


      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            ZoneBoxDiamond(
              image: "assets/images/dimond.jpg",
              ontap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TopUp(type:"TopUp",)));
              }
            ),


            ZoneBoxDiamond(
                image: "assets/images/weakly_mounthly.png",
                ontap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TopUp(type:"WeaklyMonth",)));
                }
            ),



            ZoneBoxDiamond(
                image: "assets/images/weaklight.png",
                ontap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TopUp(type:"WeaklyLight",)));
                }
            ),



          ],
        ),
      ),
    );
  }
}
