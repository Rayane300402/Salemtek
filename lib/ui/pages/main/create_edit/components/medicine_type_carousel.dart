import 'package:flutter/material.dart';

import '../../../../../configs/theme/palette.dart';
import '../models/medicine_type.dart';

class MedicineTypeCarousel extends StatefulWidget {
  final MedicineType selected;
  final ValueChanged<MedicineType> onChanged;

  const MedicineTypeCarousel({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<MedicineTypeCarousel> createState() => _MedicineTypeCarouselState();
}

class _MedicineTypeCarouselState extends State<MedicineTypeCarousel> {
  late final PageController controller;

  static const int _virtualPageCount = 10000;

  late final int _initialPage;
  late int _currentPage;

  int get selectedIndex => MedicineType.values.indexOf(widget.selected);

  int _realIndexFromPage(int page) {
    return page % MedicineType.values.length;
  }

  @override
  void initState() {
    super.initState();

    final middle = _virtualPageCount ~/ 2;

    _initialPage =
        middle - (middle % MedicineType.values.length) + selectedIndex;

    _currentPage = _initialPage;

    controller = PageController(
      viewportFraction: 0.42,
      initialPage: _initialPage,
    );
  }

  void _goToPage(int page) {
    controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final types = MedicineType.values;

    return Container(
      height: 255,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Palette.primary,
        borderRadius: BorderRadius.circular(42),
      ),
      clipBehavior: Clip.hardEdge,
      child: PageView.builder(
        controller: controller,
        itemCount: _virtualPageCount,
        pageSnapping: true,
        physics: const PageScrollPhysics(),
        onPageChanged: (page) {
          _currentPage = page;

          final type = types[_realIndexFromPage(page)];
          widget.onChanged(type);
        },
        itemBuilder: (context, page) {
          final type = types[_realIndexFromPage(page)];
          final isSelected = type == widget.selected;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!isSelected) {
                _goToPage(page);
              }
            },
            child: AnimatedScale(
              scale: isSelected ? 1 : 0.78,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    width: isSelected ? 118 : 104,
                    height: isSelected ? 118 : 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Palette.navIcon.withValues(alpha: 0.8)
                          : Palette.medicineType.withValues(alpha: 0.9),
                    ),
                    child: Center(
                      child: Image.asset(
                        type.asset,
                        height: isSelected ? 82 : 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  AnimatedOpacity(
                    opacity: isSelected ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      type.label,
                      style: const TextStyle(
                        color: Palette.secondary,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}