import 'package:salemtek/configs/assets/images.dart';
import '../../../../domain/entities/introduction.dart';


/// Central intro content.
/// IntroPage will import this and build UI from it.
final List<IntroductionEntity> introData = [
  IntroductionEntity(
    title: 'Your pocket med\ncabinet',
    subtitle: 'Everything you take, neatly in one\nplace',
    images: [
      Images.maskedPillBottle,
      Images.maskedPillContainer,
      Images.maskedCream
    ],
    showBtn: false,
  ),
  IntroductionEntity(
    title: 'All your medication\nin one system',
    subtitle: 'Log pills, creams, drips or powders.\nSee your progress over time.',
    images: [
      Images.maskedCreamBottle,
      Images.maskedPill,
      Images.maskedCapsuleContainer
    ],
    showBtn: false,
  ),
  IntroductionEntity(
    title: 'All your doses\nright on time',
    subtitle: 'So relax and let us handle\nthe timing',
    images: [
      Images.maskedDrip,
      Images.maskedMedicine,
      Images.maskedMedicineBottle
    ],
    showBtn: true,
  ),
];