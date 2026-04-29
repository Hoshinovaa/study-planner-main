import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Beranda",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: "Tugas",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: "Jadwal",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Pengaturan",
        ),
      ],
    );
  }
}