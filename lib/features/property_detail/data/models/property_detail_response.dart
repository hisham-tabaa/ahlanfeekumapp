class PropertyDetailResponse {
  final String id;
  final String propertyTitle;
  final String? hotelName;
  final int bedrooms;
  final int bathrooms;
  final int numberOfBed;
  final int floor;
  final int maximumNumberOfGuest;
  final int livingrooms;
  final String propertyDescription;
  final String hourseRules;
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
  final String? mainImage;
  final List<PropertyFeatureDto> propertyFeatures;
  final List<PropertyMediaDto> propertyMedia;
  final List<PropertyEvaluationDto> propertyEvaluations;
  final double averageRating;
  final double averageCleanliness;
  final double averagePriceAndValue;
  final double averageLocation;
  final double averageAccuracy;
  final double averageAttitude;

  const PropertyDetailResponse({
    required this.id,
    required this.propertyTitle,
    this.hotelName,
    required this.bedrooms,
    required this.bathrooms,
    required this.numberOfBed,
    required this.floor,
    required this.maximumNumberOfGuest,
    required this.livingrooms,
    required this.propertyDescription,
    required this.hourseRules,
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
    this.mainImage,
    required this.propertyFeatures,
    required this.propertyMedia,
    required this.propertyEvaluations,
    required this.averageRating,
    required this.averageCleanliness,
    required this.averagePriceAndValue,
    required this.averageLocation,
    required this.averageAccuracy,
    required this.averageAttitude,
  });

  factory PropertyDetailResponse.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0;
      }
      return 0;
    }

    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      return 0;
    }

    final featureList =
        (json['propertyFeatureMobileDtos'] as List<dynamic>? ?? [])
            .map(
              (item) =>
                  PropertyFeatureDto.fromJson(item as Map<String, dynamic>),
            )
            .toList();

    final mediaList = (json['propertyMediaMobileDto'] as List<dynamic>? ?? [])
        .map((item) => PropertyMediaDto.fromJson(item as Map<String, dynamic>))
        .toList();

    final evaluationList =
        (json['propertyEvaluationMobileDtos'] as List<dynamic>? ?? [])
            .map(
              (item) =>
                  PropertyEvaluationDto.fromJson(item as Map<String, dynamic>),
            )
            .toList();

    return PropertyDetailResponse(
      id: json['id'] as String? ?? '',
      propertyTitle: json['propertyTitle'] as String? ?? '',
      hotelName: json['hotelName'] as String?,
      bedrooms: toInt(json['bedrooms']),
      bathrooms: toInt(json['bathrooms']),
      numberOfBed: toInt(json['numberOfBed']),
      floor: toInt(json['floor']),
      maximumNumberOfGuest: toInt(json['maximumNumberOfGuest']),
      livingrooms: toInt(json['livingrooms']),
      propertyDescription: json['propertyDescription'] as String? ?? '',
      hourseRules: json['hourseRules'] as String? ?? '',
      importantInformation: json['importantInformation'] as String? ?? '',
      address: json['address'] as String?,
      streetAndBuildingNumber: json['streetAndBuildingNumber'] as String?,
      landMark: json['landMark'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      pricePerNight: toDouble(json['pricePerNight']),
      isActive: json['isActive'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      propertyTypeName: json['propertyTypeName'] as String? ?? '',
      governorateName: json['governorateName'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? '',
      ownerId: json['ownerId'] as String?,
      area: json['area'] == null ? null : toDouble(json['area']),
      mainImage: json['mainImage'] as String?,
      propertyFeatures: featureList,
      propertyMedia: mediaList,
      propertyEvaluations: evaluationList,
      averageRating: toDouble(json['averageRating']),
      averageCleanliness: toDouble(json['averageCleanliness']),
      averagePriceAndValue: toDouble(json['averagePriceAndValue']),
      averageLocation: toDouble(json['averageLocation']),
      averageAccuracy: toDouble(json['averageAccuracy']),
      averageAttitude: toDouble(json['averageAttitude']),
    );
  }
}

class PropertyFeatureDto {
  final String id;
  final String title;
  final String? icon;
  final int order;
  final bool isActive;

  const PropertyFeatureDto({
    required this.id,
    required this.title,
    this.icon,
    required this.order,
    required this.isActive,
  });

  factory PropertyFeatureDto.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      return 0;
    }

    return PropertyFeatureDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      icon: json['icon'] as String?,
      order: toInt(json['order']),
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}

class PropertyMediaDto {
  final String id;
  final String? image;
  final int order;
  final bool isActive;

  const PropertyMediaDto({
    required this.id,
    this.image,
    required this.order,
    required this.isActive,
  });

  factory PropertyMediaDto.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      return 0;
    }

    return PropertyMediaDto(
      id: json['id'] as String? ?? '',
      image: json['image'] as String?,
      order: toInt(json['order']),
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}

class PropertyEvaluationDto {
  final String id;
  final double cleanliness;
  final double priceAndValue;
  final double location;
  final double accuracy;
  final double attitude;
  final String? ratingComment;
  final String userProfileId;
  final String userProfileName;

  const PropertyEvaluationDto({
    required this.id,
    required this.cleanliness,
    required this.priceAndValue,
    required this.location,
    required this.accuracy,
    required this.attitude,
    this.ratingComment,
    required this.userProfileId,
    required this.userProfileName,
  });

  factory PropertyEvaluationDto.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0;
      }
      return 0;
    }

    return PropertyEvaluationDto(
      id: json['id'] as String? ?? '',
      cleanliness: toDouble(json['cleanliness']),
      priceAndValue: toDouble(json['priceAndValue']),
      location: toDouble(json['location']),
      accuracy: toDouble(json['accuracy']),
      attitude: toDouble(json['attitude']),
      ratingComment: json['ratingComment'] as String?,
      userProfileId: json['userProfileId'] as String? ?? '',
      userProfileName: json['userProfileName'] as String? ?? '',
    );
  }
}
