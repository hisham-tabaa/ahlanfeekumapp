import 'package:json_annotation/json_annotation.dart';

part 'property_rating_request.g.dart';

@JsonSerializable()
class PropertyRatingRequest {
  final int cleanliness;
  final int priceAndValue;
  final int location;
  final int accuracy;
  final int attitude;
  final String ratingComment;
  final String sitePropertyId;

  PropertyRatingRequest({
    required this.cleanliness,
    required this.priceAndValue,
    required this.location,
    required this.accuracy,
    required this.attitude,
    required this.ratingComment,
    required this.sitePropertyId,
  });

  factory PropertyRatingRequest.fromJson(Map<String, dynamic> json) =>
      _$PropertyRatingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyRatingRequestToJson(this);
}

@JsonSerializable()
class PropertyRatingResponse {
  final bool success;
  final String? message;

  PropertyRatingResponse({this.success = true, this.message});

  factory PropertyRatingResponse.fromJson(Map<String, dynamic> json) =>
      _$PropertyRatingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyRatingResponseToJson(this);
}
