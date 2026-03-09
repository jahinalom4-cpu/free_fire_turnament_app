import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/Home/HomePage.dart';
import 'package:tournament_freefire/Home/home_controller.dart';
import 'package:tournament_freefire/Me_Account/Me.dart';
import 'package:tournament_freefire/onGoing/On_Going.dart';
import 'package:tournament_freefire/result/Result.dart';
import 'package:tournament_freefire/shop/shop.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(HomeController());

  final navbarItem = [
    BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory_rounded, size: 22), label: "Shop"),
    BottomNavigationBarItem(icon: Icon(Icons.timer), label: "OnGoing"),
    BottomNavigationBarItem(icon: Icon(Icons.videogame_asset, size: 22), label: "Play"),
    BottomNavigationBarItem(icon: Icon(Icons.history_edu, size: 22), label: "Result"),
    BottomNavigationBarItem(icon: Icon(Icons.manage_accounts_rounded, size: 22), label: "Me"),
  ];

  final navbody = [
    Shop(),
    OnGoing(),
    Homepage(),
    Result(),
    Account(),
  ];

  @override
  void initState() {
    super.initState();

    // Show rules popup only once after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.rulesShown.value) {
        controller.rulesShown.value = true;
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: "Rules",
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) {
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.6),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon or Game Banner
                      Icon(Icons.warning_rounded, size: 50, color: Colors.redAccent),

                      SizedBox(height: 10),

                      // Title
                      Text(
                        "RULES",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          shadows: [
                            Shadow(
                              blurRadius: 5,
                              color: Colors.black45,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      // Rules text
                      Text(
                        "1. Unregistered প্লোয়ার যে ইনভাইট দিবে তাকে সহ গেম থেকে কিক দেয়া হবে।\n"
                            "2. অবশ্যই কাস্টম রুম এ আপনি যে প্লট এ জয়েন করেছেন সেই স্লট এই থাকবেন!\n"
                            "3. সন্দেহজনক user কে কোন নোটিস ছাড়াই BAN করা হবে। (মন্সটার ট্রাক চালানো নিষেধ)",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: 20),

                      // OK Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          elevation: 5,
                        ),
                        onPressed: () => Get.back(),
                        child: Text(
                          "OK",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          transitionBuilder: (_, anim, __, child) {
            return ScaleTransition(
              scale: CurvedAnimation(parent: anim, curve: Curves.elasticOut),
              child: child,
            );
          },
        );
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Obx(() => navbody[controller.currentNaIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentNaIndex.value,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        backgroundColor: Colors.black12,
        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(fontFamily: 'DMSerifText-Italic'),
        onTap: (value) {
          controller.currentNaIndex.value = value;
        },
        items: navbarItem,
      )),
    );
  }
}
