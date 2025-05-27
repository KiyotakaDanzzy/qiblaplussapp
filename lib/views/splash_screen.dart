import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Pindahkan logika navigasi ke initState dan gunakan mounted check
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // Menambahkan pengecekan mounted
      Navigator.of(context).pushReplacementNamed('/beranda');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B4C3B),
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 120,
        ),
      ),
    );
  }
}