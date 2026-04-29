import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: ListView(
            children: [
              const SizedBox(height: 40),

              /// LOGO
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

              /// TITLE
              const Text(
                "Daftar Akun Baru",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const Text(
                "Mulai atur tugas mu hari ini",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              /// INPUT
              inputField("Nama Lengkap"),
              inputField("Nama Pengguna"),
              inputField("Email"),

              /// PASSWORD
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Kata Sandi",
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

              /// BUTTON DAFTAR
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A0DAD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// INPUT FIELD REUSABLE
  static Widget inputField(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}