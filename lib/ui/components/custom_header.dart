import 'package:flutter/material.dart';
import 'package:salemtek/configs/theme/palette.dart';

class CustomHeader extends StatelessWidget {
  final String title;

  final VoidCallback? onPressed;
  final IconData icon;

  final VoidCallback? onSearchPressed;
  final IconData searchIcon;

  const CustomHeader({
    super.key,
    required this.title,
    this.onPressed,
    this.icon = Icons.notifications_active,
    this.onSearchPressed,
    this.searchIcon = Icons.search,
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
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              if (onSearchPressed != null)
                IconButton(
                  onPressed: onSearchPressed,
                  icon: Icon(
                    searchIcon,
                    size: 36,
                    color: Palette.text,
                  ),
                ),
              if (onPressed != null)
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    icon,
                    size: 40,
                    color: Palette.text,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}