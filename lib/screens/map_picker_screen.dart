import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? selectedLocation;
  GoogleMapController? mapController;

  final TextEditingController _searchController = TextEditingController();

  /// LOKASI DEFAULT TELKOM
  static const LatLng initialPosition = LatLng(-6.9730, 107.6300);

  /// CARI LOKASI
  Future<void> _searchLocation() async {
    try {
      List<Location> locations =
          await locationFromAddress(_searchController.text);

      if (locations.isNotEmpty) {
        final loc = locations.first;

        LatLng newPosition = LatLng(loc.latitude, loc.longitude);

        setState(() {
          selectedLocation = newPosition;
        });

        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newPosition, 16),
        );
      }
    } catch (e) {
      debugPrint("Search error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lokasi tidak ditemukan")),
      );
    }
  }

  /// AMBIL LOKASI USER
  Future<void> _goToCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission lokasi ditolak")),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      final LatLng currentLatLng =
          LatLng(position.latitude, position.longitude);

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng, 16),
      );

      setState(() {
        selectedLocation = currentLatLng;
      });
    } catch (e) {
      debugPrint("Error lokasi: $e");
    }
  }

  /// ZOOM IN
  void _zoomIn() {
    mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  /// ZOOM OUT
  void _zoomOut() {
    mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  /// CONFIRM LOCATION
  void _confirmLocation() {
    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih lokasi dulu")),
      );
      return;
    }

    Navigator.pop(context, selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Pilih Lokasi Belajar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6A0DAD),
      ),

      body: Stack(
        children: [

          /// MAP
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: initialPosition,
              zoom: 16,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },
            onTap: (LatLng position) {
              setState(() {
                selectedLocation = position;
              });
            },
            markers: selectedLocation == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId("selected"),
                      position: selectedLocation!,
                    )
                  },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),

          /// SEARCH BAR
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Cari lokasi...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _searchLocation,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ),

          /// INFO KOORDINAT
          if (selectedLocation != null)
            Positioned(
              top: 75,
              left: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6)
                  ],
                ),
                child: Text(
                  "Lat: ${selectedLocation!.latitude.toStringAsFixed(5)}, "
                  "Lng: ${selectedLocation!.longitude.toStringAsFixed(5)}",
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),

          /// TOMBOL LOKASI SEKARANG
          Positioned(
            bottom: 110,
            right: 15,
            child: FloatingActionButton(
              heroTag: "current_location",
              mini: true,
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),

          /// ZOOM BUTTON
          Positioned(
            right: 15,
            bottom: 180,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "zoom_in",
                  mini: true,
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "zoom_out",
                  mini: true,
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),

          /// BUTTON CONFIRM
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _confirmLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0DAD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Pilih Lokasi Ini",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}