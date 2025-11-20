class ProfileResponse {
  final String id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String? latitude;
  final String? longitude;
  final String? address;
  final String? profilePhoto;
  final bool isSuperHost;
  final double speedOfCompletion;
  final double dealing;
  final double cleanliness;
  final double perfection;
  final double price;
  final List<ProfilePropertyDto> favoriteProperties;
  final List<ProfilePropertyDto> myProperties;

  const ProfileResponse({
    required this.id,
    required this.name,
    this.email,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.address,
    this.profilePhoto,
    required this.isSuperHost,
    required this.speedOfCompletion,
    required this.dealing,
    required this.cleanliness,
    required this.perfection,
    required this.price,
    required this.favoriteProperties,
    required this.myProperties,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    final favoriteList = (json['favoriteProperties'] as List<dynamic>? ?? [])
        .map(
          (item) => ProfilePropertyDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    final myPropertiesList = (json['myProperties'] as List<dynamic>? ?? [])
        .map(
          (item) => ProfilePropertyDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    double _parseDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0;
      }
      return 0;
    }

    return ProfileResponse(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      address: json['address'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      isSuperHost: json['isSuperHost'] as bool? ?? false,
      speedOfCompletion: _parseDouble(json['speedOfCompletion']),
      dealing: _parseDouble(json['dealing']),
      cleanliness: _parseDouble(json['cleanliness']),
      perfection: _parseDouble(json['perfection']),
      price: _parseDouble(json['price']),
      favoriteProperties: favoriteList,
      myProperties: myPropertiesList,
    );
  }
}

class ProfilePropertyDto {
  final String id;
  final String propertyTitle;
  final String? hotelName;
  final String? address;
  final String? streetAndBuildingNumber;
  final String? landMark;
  final double? averageRating;
  final double pricePerNight;
  final bool isActive;
  final bool isFavorite;
  final double? area;
  final String? mainImage;

  const ProfilePropertyDto({
    required this.id,
    required this.propertyTitle,
    this.hotelName,
    this.address,
    this.streetAndBuildingNumber,
    this.landMark,
    this.averageRating,
    required this.pricePerNight,
    required this.isActive,
    required this.isFavorite,
    this.area,
    this.mainImage,
  });

  factory ProfilePropertyDto.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value);
      }
      return null;
    }

    // Debug: Check what image field we receive from backend
    final mainImageValue = json['mainImage'] as String?;
    final propertyTitle = json['propertyTitle'] as String? ?? 'Unknown';


    // Check for alternative field names
    if (mainImageValue == null) {
      final alternativeFields = [
        'MainImage',
        'image',
        'Image',
        'imageUrl',
        'ImageUrl',
      ];
      for (final field in alternativeFields) {
        if (json.containsKey(field) && json[field] != null) {
        }
      }
    }

    return ProfilePropertyDto(
      id: json['id'] as String? ?? '',
      propertyTitle: propertyTitle,
      hotelName: json['hotelName'] as String?,
      address: json['address'] as String?,
      streetAndBuildingNumber: json['streetAndBuildingNumber'] as String?,
      landMark: json['landMark'] as String?,
      averageRating: _toDouble(json['averageRating']),
      pricePerNight: _toDouble(json['pricePerNight']) ?? 0,
      isActive: json['isActive'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      area: _toDouble(json['area']),
      mainImage: json['mainImage'] as String?,
    );
  }
}
