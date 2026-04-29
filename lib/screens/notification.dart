import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        "title": "Tugas Hampir Deadline!",
        "desc": "Progres Tubes - Aplikasi Perangkat Bergerak",
        "time": "Hari ini, 23:59"
      },
      {
        "title": "Reminder Belajar",
        "desc": "Jangan lupa lanjut Sistem Cerdas ya!",
        "time": "Hari ini, 10:00"
      },
      {
        "title": "Tugas Selesai 🎉",
        "desc": "Penetrasi dan Pengujian Etika Peretasan",
        "time": "Kemarin"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),

      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "Belum ada notifikasi",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/schedule');
                  },
                  child: Container(
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
                        _buildIcon(notif["title"]!),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notif["title"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),

                              Text(
                                notif["desc"]!,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 6),

                              Text(
                                notif["time"]!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  //ICON
  Widget _buildIcon(String title) {
    if (title.contains("Deadline")) {
      return const Icon(Icons.warning_amber_rounded,
          color: Colors.red, size: 28);
    } else if (title.contains("Reminder")) {
      return const Icon(Icons.notifications_active,
          color: Colors.orange, size: 28);
    } else {
      return const Icon(Icons.check_circle,
          color: Colors.green, size: 28);
    }
  }
}