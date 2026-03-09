import 'package:flutter/material.dart';
import 'package:salemtek/configs/theme/palette.dart';

class SettingsButton extends StatelessWidget {
  final String title;
  String subtitle;
  final IconData icon;
  final void Function()? onTap;
  SettingsButton({super.key, required this.title, this.subtitle = '', required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: Palette.secondary,
          borderRadius:  BorderRadius.circular(50),
          boxShadow:[
            BoxShadow(
            color:  Color(0x40000000),
              offset: const Offset(
                0,
                5.0,
              ),
              blurRadius: 21.4,
              spreadRadius: 2.0,
          )]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
                icon,
              size: 35,
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                ),
                if(subtitle != '')
                Text(
                    subtitle,
                  style: TextStyle(
                    color: Color(0xFF696870),
                    fontWeight: FontWeight.w500
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
