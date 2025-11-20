// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_availability_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyAvailabilityRequest _$PropertyAvailabilityRequestFromJson(
        Map<String, dynamic> json) =>
    PropertyAvailabilityRequest(
      propertyId: json['propertyId'] as String,
      date: json['date'] as String,
      isAvailable: json['isAvailable'] as bool,
      price: (json['price'] as num).toDouble(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$PropertyAvailabilityRequestToJson(
        PropertyAvailabilityRequest instance) =>
    <String, dynamic>{
      'propertyId': instance.propertyId,
      'date': instance.date,
      'isAvailable': instance.isAvailable,
      'price': instance.price,
      'note': instance.note,
    };

PropertyAvailabilityItem _$PropertyAvailabilityItemFromJson(
        Map<String, dynamic> json) =>
    PropertyAvailabilityItem(
      id: json['id'] as String?,
      propertyId: json['propertyId'] as String?,
      date: json['date'] as String,
      isAvailable: json['isAvailable'] as bool,
      price: (json['price'] as num?)?.toDouble(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$PropertyAvailabilityItemToJson(
        PropertyAvailabilityItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyId': instance.propertyId,
      'date': instance.date,
      'isAvailable': instance.isAvailable,
      'price': instance.price,
      'note': instance.note,
    };

PropertyAvailabilityResponse _$PropertyAvailabilityResponseFromJson(
        Map<String, dynamic> json) =>
    PropertyAvailabilityResponse(
      totalCount: (json['totalCount'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) =>
              PropertyAvailabilityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PropertyAvailabilityResponseToJson(
        PropertyAvailabilityResponse instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'items': instance.items,
      'success': instance.success,
      'message': instance.message,
    };
