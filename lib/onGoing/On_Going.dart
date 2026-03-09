import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnGoing extends StatelessWidget {
  const OnGoing({super.key});

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
      appBar: AppBar(
        title: const Text(
          "Booyah Masters Channel Zone",
          style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        leading: const BackButton(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('YoutubeVideos')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No videos available.", style: TextStyle(color: Colors.white)),
            );
          }

          final videos = snapshot.data!.docs;

          return ListView.builder(

            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              final title = video['title'];
              final url = video['url'];
              final videoId = Uri.parse(url).queryParameters['v'] ??
                  Uri.parse(url).pathSegments.last.split('?').first;

              return GestureDetector(
                onTap: () => _launchVideo(context, url),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.white54),
                    image: DecorationImage(
                      image: NetworkImage('https://img.youtube.com/vi/$videoId/0.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.black45,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                          ),
                          child: const Icon(Icons.play_circle_fill, color: Colors.red, size: 40),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
