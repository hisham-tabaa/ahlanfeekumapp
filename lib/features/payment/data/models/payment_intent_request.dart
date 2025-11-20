import 'package:json_annotation/json_annotation.dart';

part 'payment_intent_request.g.dart';

@JsonSerializable()
class CreatePaymentIntentRequest {
  final int amount;
  final String currency;
  final String? description;
  final String? receiptEmail;
  final Map<String, String>? metadata;
  final String? userId;

  const CreatePaymentIntentRequest({
    required this.amount,
    this.currency = 'usd',
    this.description,
    this.receiptEmail,
    this.metadata,
    this.userId,
  });

  factory CreatePaymentIntentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentIntentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePaymentIntentRequestToJson(this);
}
