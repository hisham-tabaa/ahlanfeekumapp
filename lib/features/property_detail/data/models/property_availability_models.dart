import 'package:json_annotation/json_annotation.dart';

part 'property_availability_models.g.dart';

/// Request model for adding/updating property availability
@JsonSerializable()
class PropertyAvailabilityRequest {
  final String propertyId;
  final String date; // Format: YYYY-MM-DD
  final bool isAvailable;
  final double price;
  final String? note;

  const PropertyAvailabilityRequest({
    required this.propertyId,
    required this.date,
    required this.isAvailable,
    required this.price,
    this.note,
  });

  factory PropertyAvailabilityRequest.fromJson(Map<String, dynamic> json) =>
      _$PropertyAvailabilityRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyAvailabilityRequestToJson(this);
}

/// Response model for property availability
@JsonSerializable()
class PropertyAvailabilityItem {
  final String? id;
  final String? propertyId;
  final String date; // Format: YYYY-MM-DD
  final bool isAvailable;
  final double? price;
  final String? note;

  const PropertyAvailabilityItem({
    this.id,
    this.propertyId,
    required this.date,
    required this.isAvailable,
    this.price,
    this.note,
  });

  factory PropertyAvailabilityItem.fromJson(Map<String, dynamic> json) =>
      _$PropertyAvailabilityItemFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyAvailabilityItemToJson(this);
}

/// Response wrapper for list of availability
@JsonSerializable()
class PropertyAvailabilityResponse {
  final int? totalCount;
  final List<PropertyAvailabilityItem>? items;
  final bool? success;
  final String? message;

  const PropertyAvailabilityResponse({
    this.totalCount,
    this.items,
    this.success,
    this.message,
  });

  factory PropertyAvailabilityResponse.fromJson(Map<String, dynamic> json) =>
      _$PropertyAvailabilityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyAvailabilityResponseToJson(this);
}
