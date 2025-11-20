import 'package:json_annotation/json_annotation.dart';

part 'payment_intent_response.g.dart';

@JsonSerializable()
class PaymentIntentResponse {
  final String id;
  final String clientSecret;
  final String status;
  final int amount;
  final String currency;
  final int? amountReceived;

  const PaymentIntentResponse({
    required this.id,
    required this.clientSecret,
    required this.status,
    required this.amount,
    required this.currency,
    this.amountReceived,
  });

  factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentIntentResponseToJson(this);
}
