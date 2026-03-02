import 'package:flutter/material.dart';
import 'package:salemtek/configs/theme/palette.dart';
import 'package:salemtek/ui/pages/introduction/components/introduction_pagination.dart';
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
        child: PageView.builder(
          controller: _pageController,
          itemCount: introData.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) {
            final page = introData[i];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  flex: 7,
                  child: IntroductionLayout(
                    pageIndex: i,
                    images: page.images,
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntroductionText(title: page.title, subtitle: page.subtitle),

                        const SizedBox(height: 14), // ✅ controls closeness

                        IntroductionPagination(
                          count: introData.length,
                          index: _index,
                          onTap: (p) {
                            _pageController.animateToPage(
                              p,
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOut,
                            );
                          },
                        ),

                        SizedBox(height: MediaQuery.paddingOf(context).bottom),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}