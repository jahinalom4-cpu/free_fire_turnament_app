import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_freefire/common_widget/common_widget.dart';
import 'package:tournament_freefire/controllers/wallet_controller.dart';
import 'package:tournament_freefire/wallet/diposite.dart';
import 'package:tournament_freefire/wallet/paymenthistory.dart';
import 'package:tournament_freefire/wallet/refer.dart';
import 'package:tournament_freefire/wallet/widrawall.dart';
import 'package:url_launcher/url_launcher.dart';

class MyWallet extends StatelessWidget {
  const MyWallet({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not open the link.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.put(WalletController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, size: 30, color: Colors.white)),
        title: Row(
          children: [
            const Text("My Wallet", style: TextStyle(color: Colors.white)),
            SizedBox(width: 10),
            Image.asset("assets/images/wallet.png", scale: 19)
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }

        if (controller.hasError.value || controller.user.value == null) {
          return Center(child: Text("Something went wrong!", style: TextStyle(color: Colors.white)));
        }

        final user = controller.user.value!;

        return RefreshIndicator(
          onRefresh: controller.refreshWidrawallData,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Total Balance",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${user.totalBalance.toStringAsFixed(2)} TK",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        elevateButton(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Widrawall()));
                            },
                            icon: Icons.money_off,
                            title: "Withdrawal",
                            color: Colors.green),
                        elevateButton(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Diposite()));
                            },
                            icon: Icons.add_card,
                            title: "Deposit",
                            color: Colors.blue),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: infoCard(
                      title: "Winning Balance",
                      value: "${user.winningBalance.toStringAsFixed(2)} TK",
                      icon: Icons.military_tech,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: infoCard(
                      title: "Deposit Balance",
                      value: "${user.depositBalance.toStringAsFixed(2)} TK",
                      icon: Icons.wallet,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Refer()));
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.deepPurple),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.card_giftcard, color: Colors.deepPurple),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Refer & Earn 10TK per friend",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Paymenthistory()));
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.payment, color: Colors.yellow),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Payment History",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "If you got any problem, please connect with us",
                  style: TextStyle(color: Colors.deepOrange, fontSize: 15),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // WhatsApp Button
                  ElevatedButton(
                    onPressed: () => _launchUrl('https://whatsapp.com/channel/0029VbAdPqa11ulGNoZJv22R'), // <-- Replace with your number
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/whatsapp.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text("WhatsApp", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Telegram Button
                  ElevatedButton(
                    onPressed: () => _launchUrl('https://t.me/bdhunter473'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/telegram.png',
                          height: 34,
                          width: 30,
                        ),
                        const SizedBox(width: 8),
                        const Text("Telegram", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
