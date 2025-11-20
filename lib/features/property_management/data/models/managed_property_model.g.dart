// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'managed_property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagedPropertyModel _$ManagedPropertyModelFromJson(
        Map<String, dynamic> json) =>
    ManagedPropertyModel(
      id: json['id'] as String?,
      title: json['propertyTitle'] as String?,
      imageUrl: json['mainImage'] as String?,
      price: (json['pricePerNight'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool?,
      location: json['streetAndBuildingNumber'] as String?,
      totalBookings: (json['totalBookings'] as num?)?.toInt(),
      rating: (json['averageRating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ManagedPropertyModelToJson(
        ManagedPropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyTitle': instance.title,
      'mainImage': instance.imageUrl,
      'pricePerNight': instance.price,
      'isActive': instance.isActive,
      'streetAndBuildingNumber': instance.location,
      'totalBookings': instance.totalBookings,
      'averageRating': instance.rating,
    };
