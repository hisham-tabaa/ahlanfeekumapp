// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReservationRequest _$CreateReservationRequestFromJson(
        Map<String, dynamic> json) =>
    CreateReservationRequest(
      fromDate: json['FromeDate'] as String,
      toDate: json['ToDate'] as String,
      numberOfGuests: (json['NumberOfGuest'] as num).toInt(),
      notes: json['Notes'] as String,
      sitePropertyId: json['SitePropertyId'] as String,
      paymentMethod: (json['PaymentMethod'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$CreateReservationRequestToJson(
        CreateReservationRequest instance) =>
    <String, dynamic>{
      'FromeDate': instance.fromDate,
      'ToDate': instance.toDate,
      'NumberOfGuest': instance.numberOfGuests,
      'Notes': instance.notes,
      'SitePropertyId': instance.sitePropertyId,
      'PaymentMethod': instance.paymentMethod,
    };

ReservationResponse _$ReservationResponseFromJson(Map<String, dynamic> json) =>
    ReservationResponse(
      id: json['id'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ReservationResponseToJson(
        ReservationResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
    };
