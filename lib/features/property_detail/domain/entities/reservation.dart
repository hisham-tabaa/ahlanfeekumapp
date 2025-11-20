class ReservationRequest {
  final DateTime fromDate;
  final DateTime toDate;
  final int numberOfGuests;
  final String notes;
  final String sitePropertyId;

  const ReservationRequest({
    required this.fromDate,
    required this.toDate,
    required this.numberOfGuests,
    required this.notes,
    required this.sitePropertyId,
  });
}

class ReservationResponse {
  final String id;
  final String message;

  const ReservationResponse({required this.id, required this.message});
}

class HostProfile {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? latitude;
  final String? longitude;
  final String? address;
  final String? profilePhoto;
  final bool isSuperHost;
  final String roleId;
  final double speedOfCompletion;
  final double dealing;
  final double cleanliness;
  final double perfection;
  final double price;
  final List<FavoriteProperty> favoriteProperties;
  final List<MyProperty> myProperties;

  const HostProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.latitude,
    this.longitude,
    this.address,
    this.profilePhoto,
    required this.isSuperHost,
    required this.roleId,
    required this.speedOfCompletion,
    required this.dealing,
    required this.cleanliness,
    required this.perfection,
    required this.price,
    required this.favoriteProperties,
    required this.myProperties,
  });
}

class FavoriteProperty {
  final String id;
  final String propertyTitle;
  final String hotelName;
  final String address;
  final String streetAndBuildingNumber;
  final String landMark;
  final double averageRating;
  final double pricePerNight;
  final bool isActive;
  final bool isFavorite;
  final double area;
  final String mainImage;

  const FavoriteProperty({
    required this.id,
    required this.propertyTitle,
    required this.hotelName,
    required this.address,
    required this.streetAndBuildingNumber,
    required this.landMark,
    required this.averageRating,
    required this.pricePerNight,
    required this.isActive,
    required this.isFavorite,
    required this.area,
    required this.mainImage,
  });
}

class MyProperty {
  final String id;
  final String propertyTitle;
  final String hotelName;
  final String address;
  final String streetAndBuildingNumber;
  final String landMark;
  final double averageRating;
  final double pricePerNight;
  final bool isActive;
  final bool isFavorite;
  final double area;
  final String mainImage;

  const MyProperty({
    required this.id,
    required this.propertyTitle,
    required this.hotelName,
    required this.address,
    required this.streetAndBuildingNumber,
    required this.landMark,
    required this.averageRating,
    required this.pricePerNight,
    required this.isActive,
    required this.isFavorite,
    required this.area,
    required this.mainImage,
  });
}
