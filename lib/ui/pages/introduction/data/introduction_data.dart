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
    title: 'Your pocket med\ncabinet',
    subtitle: 'Everything you take, neatly in one\nplace',
    images: [
      Images.maskedCream,
      Images.maskedPill,
      Images.maskedCapsuleContainer
    ],
    showBtn: false,
  ),
  IntroductionEntity(
    title: 'Your pocket med\ncabinet',
    subtitle: 'Everything you take, neatly in one\nplace',
    images: [
      Images.maskedDrip,
      Images.maskedMedicine,
      Images.maskedMedicineBottle
    ],
    showBtn: true,
  ),
];