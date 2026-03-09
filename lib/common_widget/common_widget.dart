import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

Widget passwordtextField({controller, title}) {
  return TextField(
    controller: controller,
    style: const TextStyle(color: Colors.white),
    obscureText: true,
    decoration: InputDecoration(
      hintText: title,
      hintStyle: TextStyle(color: Colors.white54),
      labelText: title,
      labelStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white), // color when not focused
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Colors.white, width: 2), // color when focused
      ),
      prefixIcon: const Icon(
        Icons.lock_outline,
        color: Colors.white70,
      ),
    ),
  );
}

Widget textfiled({Controller, hintText, title, obscureText = false}) {
  return Container(
    margin: EdgeInsets.all(10.0),
    child: TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      controller: Controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        labelText: title,
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.white70,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white), // color when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.white, width: 2), // color when focused
        ),
      ),
    ),
  );
}

Widget elebetWithIconButton({onTap, icon, title, color}) {
  return ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, color: Colors.white),
    label: Text(title),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      minimumSize: Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

Widget LogsignButton({onTap, title}) {
  return ElevatedButton(
    onPressed: onTap,
    child: Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: 22),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey.shade900,
      minimumSize: Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

Widget MatchOvervewBox({image, gameType, number, color, onTap}) {
  return Container(
    width: double.infinity,
    height: 250,
    margin: EdgeInsets.only(top: 10, bottom: 10),
    decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white12, // 👈 white border
          width: 3, // 👈 border thickness
        ),
        color: color,
        borderRadius: BorderRadius.circular(20.0)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity, // slightly bigger to show border
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            image: DecorationImage(
              image: AssetImage(image), // 👈 your image path
              fit: BoxFit.fill, // 👈 makes image cover the circle
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gameType,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  number == 0 ? "No Match found" : number + " Match Found",
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 140,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "View Matches",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    ),
  );
}

Widget ZoneBox({ontap, image}) {
  return GestureDetector(
    onTap: ontap,
    child: Container(
      margin: EdgeInsets.all(5),
      width: 160,
      height: 140,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 3, color: Colors.white54),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill)),
    ),
  );
}

Widget Diamond(
    {image, title, number, color, OnTapForBuyingDiamonds, BuyPendingTitle}) {
  return Container(
    width: double.infinity,
    height: 250,
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white12, // 👈 white border
          width: 3, // 👈 border thickness
        ),
        color: color,
        borderRadius: BorderRadius.circular(20.0)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity, // slightly bigger to show border
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            image: DecorationImage(
              image: AssetImage(image), // 👈 your image path
              fit: BoxFit.fill, // 👈 makes image cover the circle
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  number == 0 ? "No Diamonds found" : number + " Diamonds",
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ],
            ),
            GestureDetector(
              onTap: OnTapForBuyingDiamonds,
              child: Container(
                width: 140,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      BuyPendingTitle,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.backup_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    ),
  );
}

Widget ZoneBoxDiamond({ontap, image}) {
  return GestureDetector(
    onTap: ontap,
    child: Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 3, color: Colors.white54),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill)),
    ),
  );
}

Widget showVideofromyoutub(String videoUrl) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black12,
          image: DecorationImage(
            image: NetworkImage(
              'https://img.youtube.com/vi/${_getYoutubeVideoId(videoUrl)}/0.jpg',
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      GestureDetector(
        onTap: () async {
          final Uri url = Uri.parse(videoUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(
              url,
              mode: LaunchMode.platformDefault, // আগে ছিল externalApplication
            );
          } else {
            debugPrint("Could not launch $videoUrl");
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(16),
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 48,
          ),
        ),
      ),
    ],
  );
}

String? _getYoutubeVideoId(String url) {
  final uri = Uri.parse(url);
  if (uri.host.contains('youtu.be')) {
    return uri.pathSegments.first;
  } else if (uri.host.contains('youtube.com')) {
    return uri.queryParameters['v'];
  }
  return null;
}

class VideoLecture extends StatelessWidget {
  final String? url;
  final String? image;

  const VideoLecture({super.key, this.url, this.image});

  // Function to safely extract the YouTube video ID from the URL
  String _getYoutubeVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return "";

    // Handle both formats (regular and shortened URL)
    if (uri.host.contains("youtu.be")) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : "";
    } else if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }

    return "";
  }

  // Function to launch the video URL in the external application
  Future<void> _launchVideo(BuildContext context) async {
    final Uri uri = Uri.parse(url!);
    if (await canLaunchUrl(uri)) {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open video.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid video link.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchVideo(context),
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.white54),
          image: DecorationImage(
            image: NetworkImage(
              // Generate the YouTube thumbnail from the video ID
              'https://img.youtube.com/vi/${_getYoutubeVideoId(url!)}/0.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.6),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white),
            ),
            child: const Icon(Icons.play_circle_filled_sharp,
                color: Colors.red, size: 40),
          ),
        ),
      ),
    );
  }
}

Widget infoCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
}) {
  return Container(
    padding: EdgeInsets.all(5),
    height: 100,
    width: 110,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.black54, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        )
      ],
    ),
  );
}

Widget elevateButton({onTap, icon, title, color}) {
  return ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(
      icon,
      color: Colors.white,
    ),
    label: Text(
      title,
      style: TextStyle(color: Colors.white),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

Widget MatchPrizeBox({title, value}) {
  return Container(
    width: 110,
    height: 90,
    padding: EdgeInsets.all(5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
        )),
        Expanded(
            child: Text(
          value,
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
        )),
      ],
    ),
  );
}

Widget listBox({boxColor, icon, title}) {
  return ListTile(
    tileColor: boxColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: Text(title, style: TextStyle(color: Colors.white)),
    trailing: Icon(icon, color: Colors.white),
    onTap: () {
      // navigate to history page
    },
  );
}

class MatchesBox extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? RoomDetailsOnTap;
  final VoidCallback? TotalPrizeDetailsOnTap;

  final double progress;
  final String joinPlayerDetails;
  final String joinButtonTitle;
  final String gameType;
  final String timezone;
  final String totalPrize;
  final String perkill;
  final String entryfee;
  final String playerStatus;
  final String version;
  final String map;
  final String roomId;
  final String roomPin;
  final String first;
  final String second;
  final String third;
  final String fourth;

  const MatchesBox({
    Key? key,
    required this.onTap,
    required this.progress,
    required this.joinPlayerDetails,
    required this.joinButtonTitle,
    this.RoomDetailsOnTap,
    this.TotalPrizeDetailsOnTap,
    required this.gameType,
    required this.totalPrize,
    required this.perkill,
    required this.entryfee,
    required this.playerStatus,
    required this.version,
    required this.map,
    required this.roomId,
    required this.roomPin,
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.timezone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 395,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/free.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Time Zone",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text("${timezone}",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MatchPrizeBox(title: "Total Prize", value: '$totalPrize'),
              MatchPrizeBox(title: "PerKill", value: "$perkill"),
              MatchPrizeBox(title: "ENTRY FEE", value: "$entryfee"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MatchPrizeBox(title: "Type", value: "$playerStatus"),
              MatchPrizeBox(title: "Version", value: "$version"),
              MatchPrizeBox(title: "Map", value: "$map"),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Progress Loader
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 220,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 15,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation(
                                  Colors.pinkAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          joinPlayerDetails,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        joinButtonTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 8),
              // Room and Prize Details
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: RoomDetailsOnTap,
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.key, color: Colors.blue, size: 20),
                          SizedBox(width: 5),
                          Text("Room Details",
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: TotalPrizeDetailsOnTap,
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.attach_money,
                              color: Colors.blue, size: 20),
                          SizedBox(width: 5),
                          Text("Total Prize details",
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultBox extends StatelessWidget {
  final VoidCallback? watchMatchOntap;
  final String? timeZone;
  final String? game;
  final String? totalPrize;
  final String? matchNo;
  final String? firstWinner;
  final String? secondWinner;
  final String? thirdWinner;
  final String? fourthWinner;

  final VoidCallback? TotalPrizeDetailsOnTap;

  const ResultBox({
    Key? key,
    this.TotalPrizeDetailsOnTap,
    this.watchMatchOntap,
    this.game,
    this.totalPrize,
    this.matchNo,
    this.firstWinner,
    this.secondWinner,
    this.thirdWinner,
    this.fourthWinner,
    this.timeZone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/winner.png"), fit: BoxFit.fill),
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(left: 30),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/free.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Duo Time",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text("Time: $timeZone",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MatchPrizeBox(title: "Game", value: "$game"),
              MatchPrizeBox(title: "Total Prize", value: "$totalPrize"),
              MatchPrizeBox(title: "Match No.", value: "$matchNo"),
            ],
          ),
          const SizedBox(height: 80),
          Text(
            "First:👑 $firstWinner",
            style: TextStyle(
                fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MatchPrizeBox(title: "Second", value: "🥈 $secondWinner"),
              MatchPrizeBox(title: "Third", value: " 🥉 $thirdWinner"),
              MatchPrizeBox(title: "Fourth", value: " 🎖$fourthWinner"),
            ],
          ),
          const SizedBox(height: 10),
          elevateButton(
              onTap: watchMatchOntap,
              title: "Watch Match",
              icon: Icons.slideshow,
              color: Colors.green),
        ],
      ),
    );
  }
}

Widget textBox(title) {
  return Container(
    padding: EdgeInsets.all(5),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      title,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
    ),
  );
}

//ludo match box

class LudoMatchBox extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? RoomDetailsOnTap;
  final VoidCallback? HowCanYouPlayeDetailsOnTap;

  final double progress;
  final String joinPlayerDetails;
  final String joinButtonTitle;
  final String gameType;
  final String timezone;
  final String totalPrize;

  final String entryfee;

  final String version;
  final String BoardType;
  final String roomId;
  final String roomPin;
  final String winner;
  final String logo;

  const LudoMatchBox({
    Key? key,
    required this.onTap,
    required this.progress,
    required this.joinPlayerDetails,
    required this.joinButtonTitle,
    this.RoomDetailsOnTap,
    this.HowCanYouPlayeDetailsOnTap,
    required this.gameType,
    required this.totalPrize,
    required this.entryfee,
    required this.version,
    required this.BoardType,
    required this.roomId,
    required this.roomPin,
    required this.winner,
    required this.logo,
    required this.timezone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 395,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image:  DecorationImage(
                    image: AssetImage("$logo"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Start Time",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text("${timezone}",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MatchPrizeBox(title: "Total Prize", value: '$totalPrize'),
              MatchPrizeBox(title: "ENTRY FEE", value: "$entryfee"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MatchPrizeBox(title: "Version", value: "$version"),
              MatchPrizeBox(title: "Board Type", value: "$BoardType"),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Progress Loader
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 220,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 15,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation(
                                  Colors.pinkAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          joinPlayerDetails,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        joinButtonTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 8),
              // Room and Prize Details
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: RoomDetailsOnTap,
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.key, color: Colors.blue, size: 20),
                          SizedBox(width: 5),
                          Text("Room Details",
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: HowCanYouPlayeDetailsOnTap,
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.attach_money,
                              color: Colors.blue, size: 20),
                          SizedBox(width: 5),
                          Text("How to play?",
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


///
Widget buildPrizeRow(String title, dynamic amount) {
  return Text(
    "$title: ${amount ?? 'N/A'}",
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
}

