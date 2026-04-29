import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        elevation: 0,
        centerTitle: true,
        title: const Text("Jadwal",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          ),
        ),  
      ),

      body: Column(
        children: [
          const SizedBox(height: 40),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications,
              size: 60,
              color: Colors.orange,
            ),
          ),

          const SizedBox(height: 20),

          const Text( "Pemberitahuan Notifikasi",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "KERJAIN WOY TUGAS NYA!!! MAU JADI ARTEFAK KAMPUS LU????",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ),

          const SizedBox(height: 30),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Metopen", style: TextStyle(fontSize: 16)),
                Text(
                  "10.00",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}