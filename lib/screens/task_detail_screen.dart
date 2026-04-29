import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskDetailScreen({super.key, required this.task});

  /// ALIGNMENT
  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(" : "),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double? lat = task["lat"];
    final double? lng = task["lng"];
    final String? address = task["address"];

    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),

      /// APPBAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Detail Riwayat Belajar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      /// BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TITLE
              const Text(
                "Detail Sesi Belajar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              /// DETAIL BOX
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow("Mata Kuliah", task["title"] ?? "-"),
                    buildDetailRow("Materi", task["subtitle"] ?? "-"),
                    buildDetailRow("Tanggal", task["deadline"] ?? "-"),
                    buildDetailRow("Waktu", "14:00 - 17:00"),
                    buildDetailRow("Durasi", "3 jam"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// LOKASI
              const Text(
                "Lokasi Belajar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if (lat != null && lng != null) ...[

                      Text(
                        (address != null && address.isNotEmpty)
                            ? address
                            : "Lat: $lat\nLng: $lng",
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(lat, lng),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId("task_location"),
                              position: LatLng(lat, lng),
                            ),
                          },
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                        ),
                      ),
                    ] else ...[

                      const Text(
                        "Lokasi belum ditentukan",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],

                    const SizedBox(height: 10),

                    const Text(
                      "Lokasi dipilih dari map saat menambahkan tugas",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}