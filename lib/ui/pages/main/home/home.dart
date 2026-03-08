import 'package:flutter/material.dart';

import '../../../components/custom_header.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(
          title:  'Your\nDrug Schedule',
          onPressed: () {},
          icon: Icons.notifications_active,
        )
      ],
    );
  }
}
