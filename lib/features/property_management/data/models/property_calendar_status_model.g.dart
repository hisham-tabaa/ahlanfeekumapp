// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_calendar_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyCalendarStatusModel _$PropertyCalendarStatusModelFromJson(
        Map<String, dynamic> json) =>
    PropertyCalendarStatusModel(
      propertyId: json['propertyId'] as String?,
      date: json['date'] as String?,
      isAvailable: json['isAvailable'] as bool?,
      price: (json['price'] as num?)?.toDouble(),
      note: json['note'] as String?,
      isBooked: json['isBooked'] as bool?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$PropertyCalendarStatusModelToJson(
        PropertyCalendarStatusModel instance) =>
    <String, dynamic>{
      'propertyId': instance.propertyId,
      'date': instance.date,
      'isAvailable': instance.isAvailable,
      'price': instance.price,
      'note': instance.note,
      'isBooked': instance.isBooked,
      'status': instance.status,
    };
