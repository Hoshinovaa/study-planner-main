import 'package:flutter/material.dart';
import 'home.dart';
import 'task_list_screen.dart';
import 'schedule_screen.dart';
import 'setting_screen.dart';
import '../widgets/custom_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    TaskListScreen(),
    ScheduleScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}