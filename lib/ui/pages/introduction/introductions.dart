import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFF121212), // TODO: match your design
      body: SafeArea(
        child: Column(
          children: [
            // === CONTENT AREA: PageView ===
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: introData.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final page = introData[i];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),

                        // === COMPONENT 1: HERO LAYOUT ===
                        // Square grid background + floating medicine images (from page.images)
                        // Optional Sign Up button (page.showBtn)
                        // Expanded(
                        //   flex: 7,
                        //   // child: IntroHeroLayout(
                        //   //   images: page.images,
                        //   //   showBtn: page.showBtn,
                        //   //   onBtnPressed: () {
                        //   //     // TODO: Navigate to Sign Up screen
                        //   //   },
                        //   // ),
                        // ),

                        const SizedBox(height: 18),

                        // === COMPONENT 2: TEXT SECTION ===
                        // Expanded(
                        //   flex: 3,
                        //   child: IntroTextSection(
                        //     title: page.title,
                        //     subtitle: page.subtitle,
                        //   ),
                        // ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
            ),

            // === COMPONENT 3: PAGINATION ===
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 18, top: 6),
            //   child: IntroPagination(
            //     count: introData.length,
            //     index: _index,
            //     onTap: (i) {
            //       _pageController.animateToPage(
            //         i,
            //         duration: const Duration(milliseconds: 280),
            //         curve: Curves.easeOut,
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}