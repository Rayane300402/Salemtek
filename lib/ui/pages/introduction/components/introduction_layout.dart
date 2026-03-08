import 'package:flutter/material.dart';
import 'package:salemtek/configs/assets/images.dart';
import 'package:salemtek/configs/theme/palette.dart';
import 'package:salemtek/ui/components/custom_button.dart';

class IntroductionLayout extends StatelessWidget {
  final int pageIndex;
  final List<String> images;
  final bool showBtn;

  const IntroductionLayout({
    super.key,
    required this.pageIndex,
    required this.images,
    this.showBtn = false
  }) : assert(images.length == 3, 'Each intro page must provide exactly 3 images.');


  static const double _layoutAspect = 0.81;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Controls how big the square is relative to screen width.
    // Tune this number until it matches your mock.
    final side = size.width ;

    final specs = _specsForPage(pageIndex);

    return Stack(
      clipBehavior: Clip.hardEdge, // IMPORTANT: keep things inside while tuning
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
               bottom: BorderSide(
                 width: 1,
                 color: Palette.secondary
               ),
              )
            ),
            child: Image.asset(
              Images.introLayout,
              fit: BoxFit.cover,           // ✅ fill the box cleanly
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        for (int i = 0; i < 3; i++)
          _PlacedImage(
            side: side,
            asset: images[i],
            spec: specs[i],
          ),
        if(showBtn)
        Align(
          alignment: Alignment.center,
          child: CustomButton(
            onPressed: () {},
            title: 'Get Started',
          ),
        )
      ],
    );
  }
}

/// Placement spec for a single floating image.
class _ImageSpec {
  final Alignment alignment;

  final double dx;
  final double dy;

  final double w;

  final double rot;

  const _ImageSpec({
    required this.alignment,
    required this.dx,
    required this.dy,
    required this.w,
    this.rot = 0,
  });
}

class _PlacedImage extends StatelessWidget {
  final double side;
  final String asset;
  final _ImageSpec spec;

  const _PlacedImage({
    required this.side,
    required this.asset,
    required this.spec,
  });

  @override
  Widget build(BuildContext context) {
    final width = side * spec.w;

    return Align(
      alignment: spec.alignment,
      child: Transform.translate(
        offset: Offset(side * spec.dx, side * spec.dy),
        child: Transform.rotate(
          angle: spec.rot,
          child: Image.asset(
            asset,
            width: width,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

/// Per-page layout presets tuned to your screenshot.
/// Each list contains 3 specs:
/// 0 = "top" image
/// 1 = "middle" image
/// 2 = "bottom" image
List<_ImageSpec> _specsForPage(int pageIndex) {
  switch (pageIndex) {
  // =========================
  // PAGE 1 (pill bottle top-right, container left, cream bottom-right)
  // =========================
    case 0:
      return const [
        _ImageSpec(
          alignment: Alignment.topRight,
          dx: 0.06,
          dy: -0.18,
          w: 0.7,
          rot: -0.1,
        ),
        _ImageSpec(
          alignment: Alignment.centerLeft,
          dx: 0.03,
          dy: -0.04,
          w: 0.45,
          rot: 0,
        ),
        _ImageSpec(
          alignment: Alignment.bottomRight,
          dx: -0.02,
          dy: 0,
          w: 0.52,
          rot: 0,
        ),
      ];

  // =========================
  // PAGE 2 (cream top-left, pill top-right, container bottom-left)
  // =========================
    case 1:
      return const [
        _ImageSpec(
          alignment: Alignment.topLeft,
          dx: 0.04,
          dy: 0.02,
          w: 0.6,
          rot: 0.0,
        ),
        _ImageSpec(
          alignment: Alignment.topRight,
          dx: 0.18,
          dy: 0.4,
          w: 0.6,
          rot: 0,
        ),
        _ImageSpec(
          alignment: Alignment.bottomLeft,
          dx: -0.07,
          dy: -0.1,
          w: 0.7,
          rot: -0.35,
        ),
      ];

  // =========================
  // PAGE 3 (drip top-right, medicine cluster left, bottle bottom-right)
  // =========================
    case 2:
    default:
      return const [
        _ImageSpec(
          alignment: Alignment.topRight,
          dx: 0.25,
          dy: -0.2,
          w: 0.72,
          rot: 0,
        ),
        _ImageSpec(
          alignment: Alignment.centerLeft,
          dx: -0.45,
          dy: -0.07,
          w: 0.9,
          rot: 0.0,
        ),
        _ImageSpec(
          alignment: Alignment.bottomRight,
          dx: -0.07,
          dy: 0.04,
          w: 0.62,
          rot:0.2,
        ),
      ];
  }
}