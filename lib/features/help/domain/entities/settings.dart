class Settings {
  final String id;
  final String termsTitle;
  final String termsAnnotation;
  final String termsDescription;
  final String? termsIcon;
  final String whoAreWeTitle;
  final String whoAreWeAnnotation;
  final String whoAreWeDescription;
  final String? whoAreWeIcon;
  final bool isActive;

  const Settings({
    required this.id,
    required this.termsTitle,
    required this.termsAnnotation,
    required this.termsDescription,
    this.termsIcon,
    required this.whoAreWeTitle,
    required this.whoAreWeAnnotation,
    required this.whoAreWeDescription,
    this.whoAreWeIcon,
    required this.isActive,
  });
}
