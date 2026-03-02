import 'package:flutter/material.dart';
import 'package:salemtek/configs/theme/palette.dart';

class IntroductionText extends StatelessWidget {
  final String title;
  final String subtitle;
  const IntroductionText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 30,
              color: Palette.surfaceApp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10),
          Text(
              subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Palette.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
