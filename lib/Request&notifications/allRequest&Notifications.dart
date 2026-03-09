import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tournament_freefire/Home/Home.dart';
import 'package:tournament_freefire/controllers/allnotificationcontroller.dart';
import 'package:tournament_freefire/freefire_zone/Game_zone.dart';

class AllNotificationRequest extends StatelessWidget {
  AllNotificationRequest({super.key});

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value || controller.userDeviceToken.value == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(

        appBar: AppBar(
          title: const Text("Notifications"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: controller.getFilteredNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final notifications = snapshot.data ?? [];

            if (notifications.isEmpty) {
              return const Center(child: Text("No notifications for you."));
            }

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final data = notifications[index];
                final title = data['title'] ?? '';
                final body = data['body'] ?? '';
                final timestamp = (data['timestamp'] as Timestamp).toDate();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Silver color
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ListTile(
                        leading: const Icon(Icons.notifications, color: Colors.deepOrange),
                        title: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(body),
                        trailing: Text(
                          timeago.format(timestamp),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  )

                );
              },
            );
          },
        ),
      );
    });
  }
}
