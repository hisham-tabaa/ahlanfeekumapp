class SettingsResponse {
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

  const SettingsResponse({
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

  factory SettingsResponse.fromJson(Map<String, dynamic> json) {
    return SettingsResponse(
      id: json['id'] as String? ?? '',
      termsTitle: json['termsTitle'] as String? ?? '',
      termsAnnotation: json['termsAnnotation'] as String? ?? '',
      termsDescription: json['termsDescription'] as String? ?? '',
      termsIcon: json['termsIcon'] as String?,
      whoAreWeTitle: json['whoAreWeTitle'] as String? ?? '',
      whoAreWeAnnotation: json['whoAreWeAnnotation'] as String? ?? '',
      whoAreWeDescription: json['whoAreWeDescription'] as String? ?? '',
      whoAreWeIcon: json['whoAreWeIcon'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'termsTitle': termsTitle,
      'termsAnnotation': termsAnnotation,
      'termsDescription': termsDescription,
      'termsIcon': termsIcon,
      'whoAreWeTitle': whoAreWeTitle,
      'whoAreWeAnnotation': whoAreWeAnnotation,
      'whoAreWeDescription': whoAreWeDescription,
      'whoAreWeIcon': whoAreWeIcon,
      'isActive': isActive,
    };
  }
}