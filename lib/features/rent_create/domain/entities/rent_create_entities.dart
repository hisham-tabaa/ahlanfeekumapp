class PropertyCreationResult {
  final bool success;
  final String? propertyId;
  final String message;
  final dynamic data;

  const PropertyCreationResult({
    required this.success,
    this.propertyId,
    required this.message,
    this.data,
  });
}

class PropertyTypeEntity {
  final String id;
  final String name;
  final String? description;
  final bool isActive;

  const PropertyTypeEntity({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
  });
}

class PropertyFeatureEntity {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final bool isActive;

  const PropertyFeatureEntity({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.isActive = true,
  });
}

class GovernorateEntity {
  final String id;
  final String name;
  final String? description;
  final bool isActive;

  const GovernorateEntity({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
  });
}

enum PropertyCreationStep {
  propertyDetails(1, 'Property Details'),
  location(2, 'Location'),
  availability(3, 'Available In'),
  photos(4, 'Photos'),
  price(5, 'Price'),
  review(6, 'Review');

  const PropertyCreationStep(this.stepNumber, this.title);

  final int stepNumber;
  final String title;

  String getTranslationKey() {
    switch (this) {
      case PropertyCreationStep.propertyDetails:
        return 'property_details';
      case PropertyCreationStep.location:
        return 'location';
      case PropertyCreationStep.availability:
        return 'available_in';
      case PropertyCreationStep.photos:
        return 'photos';
      case PropertyCreationStep.price:
        return 'price';
      case PropertyCreationStep.review:
        return 'review';
    }
  }
}

class PropertyCreationStepStatus {
  final PropertyCreationStep step;
  final bool isCompleted;
  final bool isActive;

  const PropertyCreationStepStatus({
    required this.step,
    required this.isCompleted,
    required this.isActive,
  });
}
