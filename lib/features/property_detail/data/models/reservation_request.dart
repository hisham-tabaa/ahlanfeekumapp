import 'package:json_annotation/json_annotation.dart';

part 'reservation_request.g.dart';

@JsonSerializable()
class CreateReservationRequest {
  @JsonKey(name: 'FromeDate')
  final String fromDate; // Format: YYYY-MM-DD

  @JsonKey(name: 'ToDate')
  final String toDate; // Format: YYYY-MM-DD

  @JsonKey(name: 'NumberOfGuest')
  final int numberOfGuests;

  @JsonKey(name: 'Notes')
  final String notes;

  @JsonKey(name: 'SitePropertyId')
  final String sitePropertyId;

  @JsonKey(name: 'PaymentMethod')
  final int paymentMethod; // 1 = Card (Stripe), 2 = Cash

  const CreateReservationRequest({
    required this.fromDate,
    required this.toDate,
    required this.numberOfGuests,
    required this.notes,
    required this.sitePropertyId,
    this.paymentMethod = 1, // Default to Card payment
  });

  factory CreateReservationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReservationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReservationRequestToJson(this);
}

@JsonSerializable()
class ReservationResponse {
  final String? id;
  final String? message;

  const ReservationResponse({this.id, this.message});

  factory ReservationResponse.fromJson(Map<String, dynamic> json) =>
      _$ReservationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationResponseToJson(this);
}
