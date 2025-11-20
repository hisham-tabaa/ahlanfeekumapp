// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HostProfileResponse _$HostProfileResponseFromJson(Map<String, dynamic> json) =>
    HostProfileResponse(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      address: json['address'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      isSuperHost: json['isSuperHost'] as bool?,
      roleId: json['roleId'] as String?,
      speedOfCompletion: (json['speedOfCompletion'] as num?)?.toDouble(),
      dealing: (json['dealing'] as num?)?.toDouble(),
      cleanliness: (json['cleanliness'] as num?)?.toDouble(),
      perfection: (json['perfection'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      favoriteProperties: (json['favoriteProperties'] as List<dynamic>?)
          ?.map((e) =>
              FavoritePropertyResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      myProperties: (json['myProperties'] as List<dynamic>?)
          ?.map((e) => MyPropertyResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HostProfileResponseToJson(
        HostProfileResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'profilePhoto': instance.profilePhoto,
      'isSuperHost': instance.isSuperHost,
      'roleId': instance.roleId,
      'speedOfCompletion': instance.speedOfCompletion,
      'dealing': instance.dealing,
      'cleanliness': instance.cleanliness,
      'perfection': instance.perfection,
      'price': instance.price,
      'favoriteProperties': instance.favoriteProperties,
      'myProperties': instance.myProperties,
    };

FavoritePropertyResponse _$FavoritePropertyResponseFromJson(
        Map<String, dynamic> json) =>
    FavoritePropertyResponse(
      id: json['id'] as String,
      propertyTitle: json['propertyTitle'] as String?,
      hotelName: json['hotelName'] as String?,
      address: json['address'] as String?,
      streetAndBuildingNumber: json['streetAndBuildingNumber'] as String?,
      landMark: json['landMark'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool?,
      isFavorite: json['isFavorite'] as bool?,
      area: (json['area'] as num?)?.toDouble(),
      mainImage: json['mainImage'] as String?,
    );

Map<String, dynamic> _$FavoritePropertyResponseToJson(
        FavoritePropertyResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyTitle': instance.propertyTitle,
      'hotelName': instance.hotelName,
      'address': instance.address,
      'streetAndBuildingNumber': instance.streetAndBuildingNumber,
      'landMark': instance.landMark,
      'averageRating': instance.averageRating,
      'pricePerNight': instance.pricePerNight,
      'isActive': instance.isActive,
      'isFavorite': instance.isFavorite,
      'area': instance.area,
      'mainImage': instance.mainImage,
    };

MyPropertyResponse _$MyPropertyResponseFromJson(Map<String, dynamic> json) =>
    MyPropertyResponse(
      id: json['id'] as String,
      propertyTitle: json['propertyTitle'] as String?,
      hotelName: json['hotelName'] as String?,
      address: json['address'] as String?,
      streetAndBuildingNumber: json['streetAndBuildingNumber'] as String?,
      landMark: json['landMark'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool?,
      isFavorite: json['isFavorite'] as bool?,
      area: (json['area'] as num?)?.toDouble(),
      mainImage: json['mainImage'] as String?,
    );

Map<String, dynamic> _$MyPropertyResponseToJson(MyPropertyResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyTitle': instance.propertyTitle,
      'hotelName': instance.hotelName,
      'address': instance.address,
      'streetAndBuildingNumber': instance.streetAndBuildingNumber,
      'landMark': instance.landMark,
      'averageRating': instance.averageRating,
      'pricePerNight': instance.pricePerNight,
      'isActive': instance.isActive,
      'isFavorite': instance.isFavorite,
      'area': instance.area,
      'mainImage': instance.mainImage,
    };
