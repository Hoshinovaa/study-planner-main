import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_picker_screen.dart';

class EditTargetScreen extends StatefulWidget {
  final String taskId;
  final String title;
  final String matkul;
  final String deadline;
  final String lokasi;

  const EditTargetScreen({
    super.key,
    required this.taskId,
    required this.title,
    required this.matkul,
    required this.deadline,
    required this.lokasi,
  });

  @override
  State<EditTargetScreen> createState() => _EditTargetScreenState();
}

class _EditTargetScreenState extends State<EditTargetScreen> {
  late TextEditingController titleC;
  late TextEditingController deadlineC;
  late TextEditingController lokasiC;

  String selectedCourse = "Mata Kuliah";

  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();

    titleC = TextEditingController(text: widget.title);
    deadlineC = TextEditingController(text: widget.deadline);
    lokasiC = TextEditingController(text: widget.lokasi);

    selectedCourse = widget.matkul.isEmpty
        ? "Mata Kuliah"
        : widget.matkul;
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    deadlineC.text =
        "${pickedDate.day.toString().padLeft(2, '0')}/"
        "${pickedDate.month.toString().padLeft(2, '0')}/"
        "${pickedDate.year} "
        "${pickedTime.hour.toString().padLeft(2, '0')}:"
        "${pickedTime.minute.toString().padLeft(2, '0')}";
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MapPickerScreen(),
      ),
    );

    if (result != null && result is LatLng) {
      setState(() {
        selectedLocation = result;
      });
    }
  }

  Future<void> updateTask() async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .update({
      'title': titleC.text,
      'course': selectedCourse,
      'deadline': deadlineC.text,
      'locationName': lokasiC.text,
      'lat': selectedLocation?.latitude,
      'lng': selectedLocation?.longitude,
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    titleC.dispose();
    deadlineC.dispose();
    lokasiC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1F3),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Tugas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// NAMA TUGAS
            const Text(
              "Nama Tugas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: titleC,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// MATA KULIAH
            const Text(
              "Mata Kuliah",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton<String>(
                value: selectedCourse,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  "Mata Kuliah",
                  "APB",
                  "IoT",
                  "AI",
                ].map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCourse = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            /// DEADLINE
            const Text(
              "Deadline",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: deadlineC,
              readOnly: true,
              onTap: _pickDate,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LOKASI BELAJAR
            const Text(
              "Lokasi Belajar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: lokasiC,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText:
                    "Contoh: Perpustakaan, Kafe, Rumah",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// MAP
            GestureDetector(
              onTap: _pickLocation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        lokasiC.text.isEmpty
                            ? "Pilih lokasi belajar"
                            : lokasiC.text,
                        style: TextStyle(
                          color: lokasiC.text.isEmpty
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF6A0DAD),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF6A0DAD),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: updateTask,
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}