class PropertyDetail {
  final String id;
  final String title;
  final String? hotelName;
  final int bedrooms;
  final int bathrooms;
  final int numberOfBeds;
  final int floor;
  final int maxGuests;
  final int livingrooms;
  final String description;
  final String houseRules;
  final String importantInformation;
  final String? address;
  final String? streetAndBuildingNumber;
  final String? landMark;
  final String? latitude;
  final String? longitude;
  final double pricePerNight;
  final bool isActive;
  final bool isFavorite;
  final String propertyTypeName;
  final String governorateName;
  final String ownerName;
  final String? ownerId;
  final double? area;
  final String? mainImageUrl;
  final List<PropertyFeature> features;
  final List<PropertyMedia> media;
  final List<PropertyEvaluation> evaluations;
  final double averageRating;
  final double averageCleanliness;
  final double averagePriceAndValue;
  final double averageLocation;
  final double averageAccuracy;
  final double averageAttitude;

  const PropertyDetail({
    required this.id,
    required this.title,
    this.hotelName,
    required this.bedrooms,
    required this.bathrooms,
    required this.numberOfBeds,
    required this.floor,
    required this.maxGuests,
    required this.livingrooms,
    required this.description,
    required this.houseRules,
    required this.importantInformation,
    this.address,
    this.streetAndBuildingNumber,
    this.landMark,
    this.latitude,
    this.longitude,
    required this.pricePerNight,
    required this.isActive,
    required this.isFavorite,
    required this.propertyTypeName,
    required this.governorateName,
    required this.ownerName,
    this.ownerId,
    this.area,
    this.mainImageUrl,
    required this.features,
    required this.media,
    required this.evaluations,
    required this.averageRating,
    required this.averageCleanliness,
    required this.averagePriceAndValue,
    required this.averageLocation,
    required this.averageAccuracy,
    required this.averageAttitude,
  });

  PropertyDetail copyWith({
    String? id,
    String? title,
    String? hotelName,
    int? bedrooms,
    int? bathrooms,
    int? numberOfBeds,
    int? floor,
    int? maxGuests,
    int? livingrooms,
    String? description,
    String? houseRules,
    String? importantInformation,
    String? address,
    String? streetAndBuildingNumber,
    String? landMark,
    String? latitude,
    String? longitude,
    double? pricePerNight,
    bool? isActive,
    bool? isFavorite,
    String? propertyTypeName,
    String? governorateName,
    String? ownerName,
    String? ownerId,
    double? area,
    String? mainImageUrl,
    List<PropertyFeature>? features,
    List<PropertyMedia>? media,
    List<PropertyEvaluation>? evaluations,
    double? averageRating,
    double? averageCleanliness,
    double? averagePriceAndValue,
    double? averageLocation,
    double? averageAccuracy,
    double? averageAttitude,
  }) {
    return PropertyDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      hotelName: hotelName ?? this.hotelName,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      numberOfBeds: numberOfBeds ?? this.numberOfBeds,
      floor: floor ?? this.floor,
      maxGuests: maxGuests ?? this.maxGuests,
      livingrooms: livingrooms ?? this.livingrooms,
      description: description ?? this.description,
      houseRules: houseRules ?? this.houseRules,
      importantInformation: importantInformation ?? this.importantInformation,
      address: address ?? this.address,
      streetAndBuildingNumber:
          streetAndBuildingNumber ?? this.streetAndBuildingNumber,
      landMark: landMark ?? this.landMark,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      isActive: isActive ?? this.isActive,
      isFavorite: isFavorite ?? this.isFavorite,
      propertyTypeName: propertyTypeName ?? this.propertyTypeName,
      governorateName: governorateName ?? this.governorateName,
      ownerName: ownerName ?? this.ownerName,
      ownerId: ownerId ?? this.ownerId,
      area: area ?? this.area,
      mainImageUrl: mainImageUrl ?? this.mainImageUrl,
      features: features ?? this.features,
      media: media ?? this.media,
      evaluations: evaluations ?? this.evaluations,
      averageRating: averageRating ?? this.averageRating,
      averageCleanliness: averageCleanliness ?? this.averageCleanliness,
      averagePriceAndValue: averagePriceAndValue ?? this.averagePriceAndValue,
      averageLocation: averageLocation ?? this.averageLocation,
      averageAccuracy: averageAccuracy ?? this.averageAccuracy,
      averageAttitude: averageAttitude ?? this.averageAttitude,
    );
  }
}

class PropertyFeature {
  final String id;
  final String title;
  final String? iconUrl;
  final int order;
  final bool isActive;

  const PropertyFeature({
    required this.id,
    required this.title,
    this.iconUrl,
    required this.order,
    required this.isActive,
  });
}

class PropertyMedia {
  final String id;
  final String? imageUrl;
  final int order;
  final bool isActive;

  const PropertyMedia({
    required this.id,
    this.imageUrl,
    required this.order,
    required this.isActive,
  });
}

class PropertyEvaluation {
  final String id;
  final double cleanliness;
  final double priceAndValue;
  final double location;
  final double accuracy;
  final double attitude;
  final String? comment;
  final String userProfileId;
  final String userProfileName;

  const PropertyEvaluation({
    required this.id,
    required this.cleanliness,
    required this.priceAndValue,
    required this.location,
    required this.accuracy,
    required this.attitude,
    this.comment,
    required this.userProfileId,
    required this.userProfileName,
  });
}
