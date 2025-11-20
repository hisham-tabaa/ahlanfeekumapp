// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_rating_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyRatingRequest _$PropertyRatingRequestFromJson(
        Map<String, dynamic> json) =>
    PropertyRatingRequest(
      cleanliness: (json['cleanliness'] as num).toInt(),
      priceAndValue: (json['priceAndValue'] as num).toInt(),
      location: (json['location'] as num).toInt(),
      accuracy: (json['accuracy'] as num).toInt(),
      attitude: (json['attitude'] as num).toInt(),
      ratingComment: json['ratingComment'] as String,
      sitePropertyId: json['sitePropertyId'] as String,
    );

Map<String, dynamic> _$PropertyRatingRequestToJson(
        PropertyRatingRequest instance) =>
    <String, dynamic>{
      'cleanliness': instance.cleanliness,
      'priceAndValue': instance.priceAndValue,
      'location': instance.location,
      'accuracy': instance.accuracy,
      'attitude': instance.attitude,
      'ratingComment': instance.ratingComment,
      'sitePropertyId': instance.sitePropertyId,
    };

PropertyRatingResponse _$PropertyRatingResponseFromJson(
        Map<String, dynamic> json) =>
    PropertyRatingResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PropertyRatingResponseToJson(
        PropertyRatingResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };
