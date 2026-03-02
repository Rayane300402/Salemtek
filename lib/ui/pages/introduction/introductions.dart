import 'package:flutter/material.dart';
import 'package:salemtek/configs/theme/palette.dart';
import 'package:salemtek/ui/pages/introduction/components/introduction_text.dart';

import 'components/introduction_layout.dart';
import 'data/introduction_data.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primary,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: introData.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final page = introData[i];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      IntroductionLayout(
                        pageIndex: i,
                        images: page.images,
                      ),


                      const SizedBox(height: 30),

                      // === COMPONENT 2: TEXT SECTION ===
                      IntroductionText(title: page.title, subtitle: page.subtitle),

                      // const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),

            // === COMPONENT 3: PAGINATION ===
            Padding(
              padding: const EdgeInsets.only(bottom: 18, top: 6),
              child: Text('here'),
              // child: IntroPagination(
              //   count: introData.length,
              //   index: _index,
              //   onTap: (i) {
              //     _pageController.animateToPage(
              //       i,
              //       duration: const Duration(milliseconds: 280),
              //       curve: Curves.easeOut,
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}