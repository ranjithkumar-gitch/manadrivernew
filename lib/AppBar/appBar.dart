import 'package:flutter/material.dart';
import 'package:nyzoride/AppBar/notificationScreen.dart';
import 'package:nyzoride/SharedPreferences/shared_preferences.dart';
import 'package:nyzoride/Widgets/colors.dart';
import 'package:nyzoride/Widgets/customText.dart';

class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomMainAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      centerTitle: false, // left aligned
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
