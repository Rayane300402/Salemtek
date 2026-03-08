import 'package:flutter/material.dart';
import 'package:salemtek/configs/theme/palette.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  void Function()? onPressed;
  IconData icon;

  CustomHeader({
    super.key,
    required this.title,
    this.onPressed,
    this.icon = Icons.notifications_active,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
           title,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          if (onPressed != null)
            IconButton(
              onPressed: onPressed,
              icon: Icon(icon, size: 40, color: Palette.text),
            ),
        ],
      ),
    );
  }
}
