class IntroductionEntity {
   final String title;
   final String subtitle;
   final List<String> images;
   final bool showBtn ;

  const IntroductionEntity({required this.title, required this.subtitle, required this.images, this.showBtn = false});
}