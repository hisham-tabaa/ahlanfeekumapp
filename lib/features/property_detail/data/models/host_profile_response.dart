import 'package:json_annotation/json_annotation.dart';

part 'host_profile_response.g.dart';

@JsonSerializable()
class HostProfileResponse {
  final String id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? latitude;
  final String? longitude;
  final String? address;
  final String? profilePhoto;
  final bool? isSuperHost;
  final String? roleId;
  final double? speedOfCompletion;
  final double? dealing;
  final double? cleanliness;
  final double? perfection;
  final double? price;
  final List<FavoritePropertyResponse>? favoriteProperties;
  final List<MyPropertyResponse>? myProperties;

  const HostProfileResponse({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.address,
    this.profilePhoto,
    this.isSuperHost,
    this.roleId,
    this.speedOfCompletion,
    this.dealing,
    this.cleanliness,
    this.perfection,
    this.price,
    this.favoriteProperties,
    this.myProperties,
  });

  factory HostProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$HostProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HostProfileResponseToJson(this);
}

@JsonSerializable()
class FavoritePropertyResponse {
  final String id;
  final String? propertyTitle;
  final String? hotelName;
  final String? address;
  final String? streetAndBuildingNumber;
  final String? landMark;
  final double? averageRating;
  final double? pricePerNight;
  final bool? isActive;
  final bool? isFavorite;
  final double? area;
  final String? mainImage;

  const FavoritePropertyResponse({
    required this.id,
    this.propertyTitle,
    this.hotelName,
    this.address,
    this.streetAndBuildingNumber,
    this.landMark,
    this.averageRating,
    this.pricePerNight,
    this.isActive,
    this.isFavorite,
    this.area,
    this.mainImage,
  });

  factory FavoritePropertyResponse.fromJson(Map<String, dynamic> json) =>
      _$FavoritePropertyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FavoritePropertyResponseToJson(this);
}

@JsonSerializable()
class MyPropertyResponse {
  final String id;
  final String? propertyTitle;
  final String? hotelName;
  final String? address;
  final String? streetAndBuildingNumber;
  final String? landMark;
  final double? averageRating;
  final double? pricePerNight;
  final bool? isActive;
  final bool? isFavorite;
  final double? area;
  final String? mainImage;

  const MyPropertyResponse({
    required this.id,
    this.propertyTitle,
    this.hotelName,
    this.address,
    this.streetAndBuildingNumber,
    this.landMark,
    this.averageRating,
    this.pricePerNight,
    this.isActive,
    this.isFavorite,
    this.area,
    this.mainImage,
  });

  factory MyPropertyResponse.fromJson(Map<String, dynamic> json) =>
      _$MyPropertyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyPropertyResponseToJson(this);
}
