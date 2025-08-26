class OnboardingItem {
  final String image;
  final String title;
  final String? subtitle; // nullable subtitle

  OnboardingItem({
    required this.image,
    required this.title,
    this.subtitle,
  });
}
