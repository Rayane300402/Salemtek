import 'package:flutter/material.dart';

import '../../../components/custom_header.dart';

class Statistics extends StatelessWidget {
  const Statistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TODO: REMOVE CUSTOM HEADER AND CREATE COMPONENT PROPERLY FOR STATS AS TITLE HAVE DROPDOWN
        CustomHeader(
          title:  'All Medicine\nJanuary,2026',
          onPressed: () {},
          icon: Icons.refresh,
        )
      ],
    );;
  }
}
