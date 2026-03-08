import 'package:flutter/material.dart';

import '../../../components/custom_header.dart';

class Cabinet extends StatelessWidget {
  const Cabinet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(
          title:  'Your\nDrug Cabinet',
          onPressed: () {},
          icon: Icons.add,
        )
      ],
    );;
  }
}
