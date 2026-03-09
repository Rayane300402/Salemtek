import 'package:flutter/material.dart';
import 'package:salemtek/configs/theme/palette.dart';
import 'package:salemtek/ui/pages/main/settings/components/settings_button.dart';

import '../../../components/custom_header.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(title: 'Your\nMedical Settings'),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SettingsButton(
                      title: 'Data',
                      subtitle: 'manage your data',
                      icon: Icons.data_usage,
                      onTap: () {},
                    ),
                    SizedBox(height: 15),
                    SettingsButton(
                      title: 'Notification',
                      subtitle: 'manage your notifications',
                      icon: Icons.notifications_active,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
    ;
  }
}
