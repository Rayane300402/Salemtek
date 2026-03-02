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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 30,
            color: Palette.surfaceApp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            color: Palette.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
