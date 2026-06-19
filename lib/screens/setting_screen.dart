import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool deadline = true;
  bool harian = true;
  bool bunyikan = true;

  Widget buildSwitch(
      String title,
      bool value,
      Function(bool) onChanged,
      ) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        title: const Text(
          "Pengaturan",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildSwitch(
              "Peringatan Deadline",
              deadline,
              (val) => setState(() => deadline = val),
            ),
            buildSwitch(
              "Harian",
              harian,
              (val) => setState(() => harian = val),
            ),
            buildSwitch(
              "Bunyikan",
              bunyikan,
              (val) => setState(() => bunyikan = val),
            ),
          ],
        ),
      ),
    );
  }
}