class Profile {
  final String id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String? latitude;
  final String? longitude;
  final String? address;
  final String? profilePhotoUrl;
  final bool isSuperHost;
  final double speedOfCompletion;
  final double dealing;
  final double cleanliness;
  final double perfection;
  final double price;
  final List<ProfileProperty> favoriteProperties;
  final List<ProfileProperty> myProperties;

  const Profile({
    required this.id,
    required this.name,
    this.email,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.address,
    this.profilePhotoUrl,
    required this.isSuperHost,
    required this.speedOfCompletion,
    required this.dealing,
    required this.cleanliness,
    required this.perfection,
    required this.price,
    required this.favoriteProperties,
    required this.myProperties,
  });
}

class ProfileProperty {
  final String id;
  final String title;
  final String? hotelName;
  final String? address;
  final String? streetAndBuildingNumber;
  final String? landMark;
  final double? averageRating;
  final double pricePerNight;
  final bool isActive;
  final bool isFavorite;
  final double? area;
  final String? mainImageUrl;

  const ProfileProperty({
    required this.id,
    required this.title,
    this.hotelName,
    this.address,
    this.streetAndBuildingNumber,
    this.landMark,
    this.averageRating,
    required this.pricePerNight,
    required this.isActive,
    required this.isFavorite,
    this.area,
    this.mainImageUrl,
  });
}
