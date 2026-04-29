import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// LOGO & TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("📖", style: TextStyle(fontSize: 28)),
                  SizedBox(width: 10),
                  Text(
                    "STUDY PLANNER",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A0DAD),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "SELAMAT DATANG KEMBALI",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const Text("Login Untuk Melanjutkan"),

              const SizedBox(height: 30),

              /// USERNAME
              TextField(
                decoration: InputDecoration(
                  hintText: "Nama Pengguna",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// PASSWORD
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Kata sandi",
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.visibility_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// BUTTON LOGIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A0DAD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text("Or continue with"),

              const SizedBox(height: 15),

              /// SOCIAL LOGIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialIcon("G"),
                  const SizedBox(width: 15),
                  socialIcon(""),
                  const SizedBox(width: 15),
                  socialIcon("f"),
                ],
              ),

              const Spacer(),

              /// REGISTER LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      "Daftar di sini",
                      style: TextStyle(
                        color: Color(0xFF6A0DAD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// WIDGET ICON SOSIAL
  static Widget socialIcon(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}