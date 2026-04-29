import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'map_picker_screen.dart';

class AddTargetScreen extends StatefulWidget {
  const AddTargetScreen({super.key});

  @override
  State<AddTargetScreen> createState() => _AddTargetScreenState();
}

class _AddTargetScreenState extends State<AddTargetScreen> {
  final _titleController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _locationNameController = TextEditingController();

  String selectedCourse = "Mata Kuliah";
  double _progress = 0;

  LatLng? selectedLocation;
  String? selectedAddress;

  /// TANGGAL
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _deadlineController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  /// PILIH LOKASI
  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapPickerScreen(),
      ),
    );

    if (result != null && result is LatLng) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(result.latitude, result.longitude);

        final place = placemarks.first;

        String address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea
        ].where((e) => e != null && e.isNotEmpty).join(", ");

        setState(() {
          selectedLocation = result;
          selectedAddress = address;
        });
      } catch (e) {
        setState(() {
          selectedLocation = result;
          selectedAddress = null;
        });
      }
    }
  }

  /// SIMPAN TASK
  void _saveTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama tugas wajib diisi")),
      );
      return;
    }

    Navigator.pop(context, {
      "title": _titleController.text,
      "subtitle": selectedCourse,
      "deadline":
          _deadlineController.text.isEmpty ? "-" : _deadlineController.text,

      "percent": "${(_progress * 100).toInt()}%",
      "value": _progress,
      "isDone": _progress == 1,
      "status": "BELUM DIKERJAKAN",

      "locationName": _locationNameController.text,
      "lat": selectedLocation?.latitude,
      "lng": selectedLocation?.longitude,
      "address": selectedAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1F3),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Tambah Tugas",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text("Nama Tugas",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Masukkan nama tugas",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Mata Kuliah",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedCourse,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ["Mata Kuliah", "APB", "IoT", "AI"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCourse = val!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              const Text("Deadline",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              TextField(
                controller: _deadlineController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.calendar_today),
                  hintText: "Pilih tanggal",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Lokasi Belajar",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              TextField(
                controller: _locationNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Contoh: Perpustakaan, Kafe, Rumah",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Titik Lokasi Belajar",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: _pickLocation,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedLocation == null
                              ? "Pilih lokasi belajar"
                              : (_locationNameController.text.isNotEmpty
                                  ? _locationNameController.text
                                  : (selectedAddress ??
                                      "Lat: ${selectedLocation!.latitude.toStringAsFixed(5)}, "
                                      "Lng: ${selectedLocation!.longitude.toStringAsFixed(5)}")),
                          style: TextStyle(
                            color: selectedLocation == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                      const Icon(Icons.location_on,
                          color: Color(0xFF6A0DAD)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Batal",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A0DAD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: _saveTask,
                        child: const Text(
                          "Simpan",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}