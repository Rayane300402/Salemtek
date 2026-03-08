import 'package:flutter/material.dart';

import '../../../components/custom_header.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(
          title:  'Your\nMedical Settings',
        )
      ],
    );;
  }
}
