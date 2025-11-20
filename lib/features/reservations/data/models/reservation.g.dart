// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      id: json['id'] as String,
      fromDate: json['fromeDate'] as String,
      toDate: json['toDate'] as String,
      checkInDate: json['checkInDate'] as String?,
      checkOutDate: json['checkOutDate'] as String?,
      numberOfGuest: (json['numberOfGuest'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      reservationStatus: (json['reservationStatus'] as num).toInt(),
      reservationStatusAsString: json['reservationStatusAsString'] as String,
      notes: json['notes'] as String?,
      userProfileId: json['userProfileId'] as String,
      userProfileName: json['userProfileName'] as String,
      userProfilePhoto: json['userProfilePhoto'] as String?,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      ownerProfilePhoto: json['ownerProfilePhoto'] as String?,
      propertyId: json['propertyId'] as String,
      propertyTitle: json['propertyTitle'] as String,
      propertyArea: json['propertyArea'] as String,
      propertyMainImage: json['propertyMainImage'] as String?,
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromeDate': instance.fromDate,
      'toDate': instance.toDate,
      'checkInDate': instance.checkInDate,
      'checkOutDate': instance.checkOutDate,
      'numberOfGuest': instance.numberOfGuest,
      'price': instance.price,
      'discount': instance.discount,
      'reservationStatus': instance.reservationStatus,
      'reservationStatusAsString': instance.reservationStatusAsString,
      'notes': instance.notes,
      'userProfileId': instance.userProfileId,
      'userProfileName': instance.userProfileName,
      'userProfilePhoto': instance.userProfilePhoto,
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
      'ownerProfilePhoto': instance.ownerProfilePhoto,
      'propertyId': instance.propertyId,
      'propertyTitle': instance.propertyTitle,
      'propertyArea': instance.propertyArea,
      'propertyMainImage': instance.propertyMainImage,
    };

ReservationResponse _$ReservationResponseFromJson(Map<String, dynamic> json) =>
    ReservationResponse(
      reservations: (json['reservations'] as List<dynamic>)
          .map((e) => Reservation.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
    );

Map<String, dynamic> _$ReservationResponseToJson(
        ReservationResponse instance) =>
    <String, dynamic>{
      'reservations': instance.reservations,
      'totalCount': instance.totalCount,
    };
