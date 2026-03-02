import 'package:flutter/material.dart';
import 'package:salemtek/configs/assets/images.dart';

class IntroductionPagination extends StatelessWidget {
  final int count;
  final int index;
  final ValueChanged<int>? onTap;

  const IntroductionPagination({
    super.key,
    required this.count,
    required this.index,
    this.onTap,

  }) : assert(count > 0),
        assert(index >= 0);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // matches your screenshot
      children: List.generate(count, (i) {
        final isActive = i == index;
        final asset = isActive ? Images.pillCurrentPage : Images.pillPage;

        return Padding(
          padding: EdgeInsets.only(right: i == count - 1 ? 0 : 10),
          child: GestureDetector(
            onTap: onTap == null ? null : () => onTap!(i),
            behavior: HitTestBehavior.translucent,
            child: AnimatedScale(
              // Later: swap this for a custom animation (bounce/wiggle/slide)
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              scale:  1.0,
              child: Image.asset(
                asset,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      }),
    );
  }
}