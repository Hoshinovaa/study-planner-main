import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/add_target_screen.dart';
import 'screens/schedule_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => MainScreen(),

        // detail
        '/add-target': (context) => AddTargetScreen(),
        '/schedule': (context) => ScheduleScreen(),

        '/login': (context) => LoginScreen(),
      },
    );
  }
}