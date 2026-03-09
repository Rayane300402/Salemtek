import 'package:flutter/material.dart';
import 'package:salemtek/ui/pages/main/home/components/calendar/calendar.dart';

import '../../../../configs/theme/palette.dart';
import '../../../components/custom_header.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(
          title: 'Your\nDrug Schedule',
          onPressed: () {},
          icon: Icons.notifications_active,
        ),
        SizedBox(height: 20),
Calendar(),
        SizedBox(height: 20),
        Expanded(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Palette.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Reminder',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 25,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
