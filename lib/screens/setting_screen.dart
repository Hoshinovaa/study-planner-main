import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool deadline = true;
  bool harian = true;
  bool bunyikan = true;

  Widget buildSwitch(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
      child: SwitchListTile(
        activeColor: const Color(0xFF6A0DAD),
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  /// LOGOUT FUNCTION
  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login', // pastikan route ini ada di main.dart
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Pengaturan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// 🔧 SWITCHES
            buildSwitch("Peringatan Deadline", deadline,
                (val) => setState(() => deadline = val)),
            buildSwitch("Harian", harian,
                (val) => setState(() => harian = val)),
            buildSwitch("Bunyikan", bunyikan,
                (val) => setState(() => bunyikan = val)),

            const Spacer(),

            /// LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0DAD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}