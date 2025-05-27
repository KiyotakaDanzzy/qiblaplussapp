import 'package:flutter/material.dart';

class BottomNavQibla extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavQibla({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFD6E7F2),
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/clock_nav.png', width: 30),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/compass_nav.png', width: 30),
          label: '',
        ),
      ],
      onTap: onTap,
    );
  }
}
