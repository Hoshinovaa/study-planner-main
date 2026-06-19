import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/notification_service.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: uid == null
          ? const Center(
              child: Text(
                "Silakan login terlebih dahulu.",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("notifications")
                  .where("uid", isEqualTo: uid)
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada notifikasi",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final notifications = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final data =
                        notifications[index].data() as Map<String, dynamic>;

                    final title = data["title"]?.toString() ?? "";
                    final desc = data["desc"]?.toString() ?? "";

                    String time = "";
                    if (data["createdAt"] != null &&
                        data["createdAt"] is Timestamp) {
                      final ts = data["createdAt"] as Timestamp;
                      time = ts.toDate().toString();
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildIcon(title),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),

                                Text(
                                  desc,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 6),

                                Text(
                                  time,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

      // TEST NOTIF BUTTON
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6A0DAD),
        onPressed: () async {
          await NotificationService.showInstantNotification(
            title: "Tes Notifikasi",
            body: "Ini adalah notifikasi percobaan dari Study Planner 🎉",
          );
        },
        icon: const Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        label: const Text(
          "Tes Notif",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildIcon(String title) {
    if (title.contains("Deadline")) {
      return const Icon(
        Icons.warning_amber_rounded,
        color: Colors.red,
        size: 28,
      );
    } else if (title.contains("Reminder")) {
      return const Icon(
        Icons.notifications_active,
        color: Colors.orange,
        size: 28,
      );
    } else {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 28,
      );
    }
  }
}