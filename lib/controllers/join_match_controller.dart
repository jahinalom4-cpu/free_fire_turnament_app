import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tournament_freefire/notification/notification_service.dart';

class JoinMatchController extends GetxController {
  final String matchId;
  final Map<String, dynamic> matchData;

  JoinMatchController({
    required this.matchId,
    required this.matchData,
  });

  var isJoining = false.obs;
  var isExpanded = false.obs;
  var joinedPeople = <dynamic>[].obs;
  var selectedOption = 1.obs; // 1 = Solo, 2 = Duo
  var enteredNames = <String>[].obs;
  var userData = Rxn<Map<String, dynamic>>();
  var userName = RxnString();

  final String brMatchRules = """
ম্যাচ জয়েন হওয়ার পর এপ এ যে স্লট এ জয়েন করেছেন (২/৩/৪) কাস্টম রুমে ঢুকে আপনি সে স্থানেই থাকবেন নয়ত রুম থেকে কিক দিলে এডমিন দায়ি নয়।

* আবশ্যিক (MUST) "BD Hunter" এর REGULAR ম্যাচে এ প্রতি KILL এর 10 সেকেন্ডের মধ্যে একটি করে SCREENSHOT নিতে হবে। প্রতি KILL এর SCREENSHOT SUPPORT (টেলিগ্রাম) এ SUBMIT করতে হবে ম্যাচ শেষে, না করলে কোন REWARD পাবেন না।

* REGULAR ম্যাচে যারা TOP 5 স্থান (POSITION) অর্জন করবে, তাদের MATCH REPLY অপশন থেকে VIDEO RECORD করে SUPPORT এ SUBMIT করতে হবে। আশা করছি সবাই সহযোগিতা করবেন। এভাবে সবার 'GAMEPLAY\" FAIR হবে।

* রেগুলার ম্যাচে Room Id Pass Collect থেকে শুরু করে প্লেন পর্যন্ত ভিডিও রেকর্ড করতে হবে। (ভিডিও চাইলে আপনাকে দিতে হবে)

কারো কোনো SERVER PROBLEM/NETWORK ISSUE
* কারো কোনো SERVER PROBLEM / NETWORK ISSUE জন্য কোন প্রকার REFUND দেওয়া হবে না।

* কোনো কারন বসত রুম থেকে কিক দেওয়া হলে সেই ক্ষেত্রে RECORDING বা SCREENSHOT ছাড়া কোন REFUND দেওয়া হবে না।

* সঠিক সময়ে রুমে জয়েন করতে না পারলে টাকা রিফান্ড করা হবে না।

* আপনার FREE FIRE আইডি 45 লেভেলের কম হলে খেলতে পারবেন না। রুম থেকে কিক দেওয়া হলে কোন প্রকার REFUND দেওয়া হবে না।

* রুম আইডি এবং পাসওয়ার্ড ম্যাচ টাইমের ৪-৫ মিনিট আগে দেওয়া হবে।

সঠিক সময়ে রুমে জয়েন করতে না পারলে টাকা রিফান্ড করা হবে না আর রুম যদি ফুল দেখায় তাহলে অবজারভ এ গিয়ে স্ক্রিন শট দিতে।

* রুম আইডি এবং পাসওয়ার্ড "UN-REGISTERED' প্লেয়ার দের সাথে শেয়ার করবেন না।

* DOU অথবা SOLO ম্যাচ এ "UN-REGISTERED' টিম-মেইটস নিয়ে খেলা যাবে না এবং মনস্টার ট্রাক চালানো যাবে না।

* প্রতি কিল এবং "WINNINGS" এর টাকা ম্যাচ শেষ হওয়ার ৩০-৪০ মিনিটের মধ্যে দয়ে দেওয়া হবে
কোনো কারনবসত ম্যাচ এর RESULTS না পাওয়া গেলে আমারা "NOTIFICATION" এর মাধ্যমে জানিয়ে দিব সেক্ষেত্রে আপনাদের গেম হিস্টরি থেকে স্ক্রীনশট নিয়ে আমাদের সাপোর্টে জমা দিতে হবে।

* যদি হ্যাক ইউজ এবং টিমিং করার সময় ধরা পরে তাহলে "KHELO LEGEND" থেকে বিনা নোটিশে ব্যান করে দেওয়া হবে।

★ HACK/FF TOOLS/ANY TYPE OF CHEAT ব্যাবহার করা থেকে বিরত থাকুন!

★ "WITHDRAW" REQUEST এর টাকা প্রতিদিন দিন 11.00am এর সময় দেওয়া হয়।

* যেকোন সমস্যা বা সহযোগিতার ক্ষেত্রে আমাদের SUPPORT এ যোগাযোগ করতে হবে।

"ADMIN" এর সিদ্ধান্তই চূড়ান্ত সিদ্ধান্ত।

#FAILURE DOESN'T MEAN GAME OVER #IT MEANS TRY AGAIN WITH EXPERIENCE

""";

  final String otherRules = """
1. Be respectful to all participants.
2. Ensure you have a stable internet connection.
3. Always follow game-specific guidelines.
4. Disconnections may lead to disqualification.
""";


  final String ClashSquadRulls = """
Match Instructions and Rules

➤ "BD Hunter" অ্যাপ এ"CLASH SQUAD" খেলার নিয়মাবলি

DEFAULT COIN: 1500

ROUND: 13

CHARACTER SKILL: NO

GUN ABILITY: NO

LIMITED AΜΜΟ: ΝΟ

GRENADE/FLASH: NO

CLASH SQUAD ম্যাচের প্রতি ROUND এ ২-৩ টি করে SCREENSHOT দিতে হবে ম্যাচ শেষে।

★ SCREENSHOT SUPPORT এ SUBMIT না করলে কোন REWARDS দেওয়া হবে না।

★ CLASH SQUAD ম্যাচে প্লেয়ার লিস্ট এর প্রথম চার জনকে এক টিম এবং দ্বিতীয় চারজনকে অন্য টিম হিসেবে গণ্য করা হবে।

CLASH SQUAD ম্যাচে PC প্লেয়াররা ALLOW না।
ক্ল্যাশ স্কোয়াড ম্যাচটিতে আনলিমিটেড 'গ্রুওয়াল' দিয়ে খেলা হবে।

* বোম ও ফ্ল্যাশবোম ব্যবহার করা যাবে না। Charge Boster & Double victor Use Kora Jabe Na "করলে বিপক্ষ টিম কে উইন' করে দেয়া হবে।

* নেট সমস্যার কারণে কাস্টম থেকে বের করে দিলে অথবা গেম এ না ঢুকালে কোনো ধরনের রিফান্ড দেওয়া হবেনা।

* ক্ল্যাশ স্কোয়াড ম্যাচ এ জয়েন করার পর কোনো ধরনের রিফান্ড হবে না।

* প্লেয়ারের নাম পরিবর্তন করতে হলে কমপক্ষে ২০-৩০ মিনিট আগে আগে আমাদের সাপোর্ট এ জানাতে হবে এবং প্লেয়ার লিস্ট দিতে হবে। নাহলে রুম থেকে কিক দেয়া হবে। (বাধ্যতামূলক)

* আপনার FREE FIRE আইডি ৪৫ লেভেলের কম হলে খেলতে পারবেন না।

* রুম আইডি এবং পাসওয়ার্ড ম্যাচ টাইমের ৫-৮ মিনিট আগে দেওয়া হবে।

* সঠিক সময়ে রুমে জয়েন করতে না পারলে টাকা রিফান্ড করা হবে না।

রুম আইডি এবং পাসওয়ার্ড "UN-REGISTERED" দের সাথেশেয়ার করবেন না।
কোনো ম্যাচ এ যদি ৮ জন এর অধিক প্লেয়ার অর্থাৎ ৯-১০ জন জয়েন করে তাহলে শেষের স্লটের প্লেয়ারদের টাকা রিফান্ড দেয়া হবে। এক্ষেত্রে ১ম ৮ জন খেলবে।

* কোনো ম্যাচ এ ৭ জন প্লেয়ার হলে এক্ষেত্রে "3V3' করানো হবে। ১জনকে রিফাল্ড দেয়া হবে।

* কোনো ম্যাচ এ বিপরীত দলের একজনকে ম্যাচের ভিতর না নিলে আপনাদের একজন ELIMINATE হতে হবে। (সেক্ষেত্রে WINNER হলে সবাইকেই REWARDS দেওয়া হবে)

* যদি হ্যাক ইউজ করার সময় ধরা পরে তাহলে "BD Hunter" থেকে ব্যান করে দেওয়া হবে।

* ম্যাচ এ জয়েন করা ১,৩,৫,৭ এক টিমে এবং ২,৪,৬,৮ এক টিমে থাকবে। & SOLO অথবা SQUAD ম্যাচ এ "UN-REGISTERED" টিম মেইটস নিয়ে খেলা যাবে না।

* ম্যাচ "WINNING" এর টাকা ম্যাচ শেষ হওয়ার ৩০-৪০ মিনিটের মধ্যে দিয়ে দেওয়া হবে।

* কোনো কারনবসত ম্যাচ এর RESULTS না পাওয়া গেলে আমরা "NOTIFICATION" দিবো। সেই ক্ষেত্রে ম্যাচ RESULTS এর "SCREENSHOT" দিতে হবে আপনাদের। দিয়ে টাকা এড করতে হবে।

"WITHDRAW" প্রতিদিন রাত ১২.০০ এর সময় দেওয়া হয়।

* "ADMIN" এর সিদ্ধান্তই হলো চুরান্ত সিদ্ধান্ত।



""";


  final String LoneWolfRulls = """
Match Instructions and Rules

➤ "KHELO LEGENDS" অ্যাপ এ"Lone Wolf" খেলার নিয়মাবলি

DEFAULT COIN: 1500

ROUND: 13

CHARACTER SKILL: NO

GUN ABILITY: NO

LIMITED AΜΜΟ: ΝΟ

GRENADE/FLASH: NO

CLASH SQUAD ম্যাচের প্রতি ROUND এ ২-৩ টি করে SCREENSHOT দিতে হবে ম্যাচ শেষে।

★ SCREENSHOT SUPPORT এ SUBMIT না করলে কোন REWARDS দেওয়া হবে না।

★ CLASH SQUAD ম্যাচে প্লেয়ার লিস্ট এর প্রথম চার জনকে এক টিম এবং দ্বিতীয় চারজনকে অন্য টিম হিসেবে গণ্য করা হবে।

CLASH SQUAD ম্যাচে PC প্লেয়াররা ALLOW না।
ক্ল্যাশ স্কোয়াড ম্যাচটিতে আনলিমিটেড 'গ্রুওয়াল' দিয়ে খেলা হবে।

* বোম ও ফ্ল্যাশবোম ব্যবহার করা যাবে না। Charge Boster & Double victor Use Kora Jabe Na "করলে বিপক্ষ টিম কে উইন' করে দেয়া হবে।

* নেট সমস্যার কারণে কাস্টম থেকে বের করে দিলে অথবা গেম এ না ঢুকালে কোনো ধরনের রিফান্ড দেওয়া হবেনা।

* ক্ল্যাশ স্কোয়াড ম্যাচ এ জয়েন করার পর কোনো ধরনের রিফান্ড হবে না।

* প্লেয়ারের নাম পরিবর্তন করতে হলে কমপক্ষে ২০-৩০ মিনিট আগে আগে আমাদের সাপোর্ট এ জানাতে হবে এবং প্লেয়ার লিস্ট দিতে হবে। নাহলে রুম থেকে কিক দেয়া হবে। (বাধ্যতামূলক)

* আপনার FREE FIRE আইডি ৪৫ লেভেলের কম হলে খেলতে পারবেন না।

* রুম আইডি এবং পাসওয়ার্ড ম্যাচ টাইমের ৫-৮ মিনিট আগে দেওয়া হবে।

* সঠিক সময়ে রুমে জয়েন করতে না পারলে টাকা রিফান্ড করা হবে না।

রুম আইডি এবং পাসওয়ার্ড "UN-REGISTERED" দের সাথেশেয়ার করবেন না।
কোনো ম্যাচ এ যদি ৮ জন এর অধিক প্লেয়ার অর্থাৎ ৯-১০ জন জয়েন করে তাহলে শেষের স্লটের প্লেয়ারদের টাকা রিফান্ড দেয়া হবে। এক্ষেত্রে ১ম ৮ জন খেলবে।

* কোনো ম্যাচ এ ৭ জন প্লেয়ার হলে এক্ষেত্রে "3V3' করানো হবে। ১জনকে রিফাল্ড দেয়া হবে।

* কোনো ম্যাচ এ বিপরীত দলের একজনকে ম্যাচের ভিতর না নিলে আপনাদের একজন ELIMINATE হতে হবে। (সেক্ষেত্রে WINNER হলে সবাইকেই REWARDS দেওয়া হবে)

* যদি হ্যাক ইউজ করার সময় ধরা পরে তাহলে "BD Hunter" থেকে ব্যান করে দেওয়া হবে।

* ম্যাচ এ জয়েন করা ১,৩,৫,৭ এক টিমে এবং ২,৪,৬,৮ এক টিমে থাকবে। & SOLO অথবা SQUAD ম্যাচ এ "UN-REGISTERED" টিম মেইটস নিয়ে খেলা যাবে না।

* ম্যাচ "WINNING" এর টাকা ম্যাচ শেষ হওয়ার ৩০-৪০ মিনিটের মধ্যে দিয়ে দেওয়া হবে।

* কোনো কারনবসত ম্যাচ এর RESULTS না পাওয়া গেলে আমরা "NOTIFICATION" দিবো। সেই ক্ষেত্রে ম্যাচ RESULTS এর "SCREENSHOT" দিতে হবে আপনাদের। দিয়ে টাকা এড করতে হবে।

"WITHDRAW" প্রতিদিন রাত ১২.০০ এর সময় দেওয়া হয়।

* "ADMIN" এর সিদ্ধান্তই হলো চুরান্ত সিদ্ধান্ত।


""";

  final String LudoRulls = """
1. Be respectful to all participants.
2. Ensure you have a stable internet connection.
3. Always follow game-specific guidelines.
4. Disconnections may lead to disqualification.
""";


  final String CarrumRulls = """
1. Be respectful to all participants.
2. Ensure you have a stable internet connection.
3. Always follow game-specific guidelines.
4. Disconnections may lead to disqualification.
""";




  @override
  void onInit() {
    super.onInit();
    joinedPeople.value = List.from(matchData['joinedPeople'] ?? []);
    enteredNames.value = List.generate(selectedOption.value, (index) => '');
    fetchUserData();
  }

  /// Toggle expansion of match rules
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  /// Fetch logged-in user's Firestore data
  Future<void> fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Get.snackbar("Error", "No logged-in user found");
      Get.back();
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (userDoc.exists) {
      userData.value = userDoc.data();
      userName.value = userData.value?['name'];
    } else {
      Get.snackbar("Error", "User data not found");
      Get.back();
    }
  }

  /// Update selected option (solo/duo) and reset name fields
  void updateSelectedOption(int value) {
    selectedOption.value = value;
    enteredNames.value = List.generate(value, (index) => '');
  }

  /// Update a name at a given index
  void updateEnteredName(int index, String name) {
    if (index >= 0 && index < enteredNames.length) {
      enteredNames[index] = name;
    }
  }

  /// Join match logic
  Future<void> joinMatch() async {
    if (userData.value == null || userName.value == null) return;

    if (enteredNames.any((name) => name.trim().isEmpty)) {
      Get.snackbar("Error", "Please enter your in-game name(s)",backgroundColor: Colors.red);
      return;
    }

    isJoining.value = true;

    final matchRef = FirebaseFirestore.instance.collection('matches').doc(matchId);
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    final String currentUid = FirebaseAuth.instance.currentUser!.uid;
    final int currentBalance = (userData.value!['totalBalance'] as num).toInt();
    final int entryFee = num.tryParse(matchData['entryFee'].toString())?.toInt() ?? 0;
    final int requiredFee = entryFee * selectedOption.value;
    final int maxPlayers = num.tryParse(matchData['maxPlayers'].toString())?.toInt() ?? 100;

    bool alreadyJoined = joinedPeople.any((item) => item['uid'] == currentUid);
    if (alreadyJoined) {
      Get.snackbar("Error", "You have already joined this match",backgroundColor: Colors.red);
      isJoining.value = false;
      return;
    }

    if (currentBalance < requiredFee) {
      Get.snackbar("Error", "Not enough balance to join",backgroundColor: Colors.red);
      isJoining.value = false;
      return;
    }

    int totalPlayersAfterJoin = joinedPeople.fold<int>(
      0,
          (sum, item) => sum + ((item['names'] as List).length),
    ) +
        enteredNames.length;

    if (totalPlayersAfterJoin > maxPlayers) {
      Get.snackbar("Error", "Match is full");
      isJoining.value = false;
      return;
    }

    Map<String, dynamic> playerData = {
      'uid': currentUid,
      'names': enteredNames,
    };
    joinedPeople.add(playerData);

    await matchRef.update({'joinedPeople': joinedPeople});
    await userRef.update({'totalBalance': currentBalance - requiredFee});

    // Referral reward logic
    final userDoc = await userRef.get();
    final data = userDoc.data();
    final hasJoined = data?['hasJoinedGame'] ?? false;
    final usedReferralCode = data?['usedReferralCode'];

    if (!hasJoined && usedReferralCode != null) {
      await userRef.update({'hasJoinedGame': true});

      final refSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('referralCode', isEqualTo: usedReferralCode)
          .limit(1)
          .get();

      if (refSnapshot.docs.isNotEmpty) {
        final refUserDoc = refSnapshot.docs.first;
        final refBalance = refUserDoc['totalBalance'] ?? 0;
        await refUserDoc.reference.update({'totalBalance': refBalance + 10});
      }
    }

    // Game-type counter update
    String? gameTypeField;
    switch (matchData['MainGameType']) {
      case 'FreeFire':
        gameTypeField = 'garenaPlayed';
        break;
      case 'Ludo':
        gameTypeField = 'ludoPlayed';
        break;
      case '"Carrum"':
        gameTypeField = 'carromPlayed';
        break;
    }

    if (gameTypeField != null) {
      await userRef.update({
        gameTypeField: FieldValue.increment(1),
      });
    }

    // Send notification
    await NotificationService.sendNotificationToAllAdmins(
      title: "A user joined a match",
      body: "$enteredNames joined a ${matchData['MainGameType']} match",
    );
    Get.back();

    Get.snackbar("Success", "Successfully joined the match",backgroundColor: Colors.green,colorText: Colors.white);

    isJoining.value = false;

  }
}
