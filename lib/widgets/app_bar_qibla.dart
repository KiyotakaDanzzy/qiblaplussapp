import 'package:flutter/material.dart';
import '../utils/font.dart';

class AppBarQibla extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onSetting;

  const AppBarQibla({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
    this.onSetting,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBack,
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/logo.png'),
            ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: FontFamily.amiri,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      actions: [
        if (onSetting != null)
          IconButton(
            icon: Image.asset('assets/images/settings.png', width: 100, height: 100,),
            onPressed: onSetting,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
