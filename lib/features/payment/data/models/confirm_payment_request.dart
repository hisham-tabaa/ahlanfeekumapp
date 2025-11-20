import 'package:json_annotation/json_annotation.dart';

part 'confirm_payment_request.g.dart';

@JsonSerializable()
class ConfirmPaymentRequest {
  final String paymentIntentId;
  final String paymentMethodId;

  const ConfirmPaymentRequest({
    required this.paymentIntentId,
    required this.paymentMethodId,
  });

  factory ConfirmPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$ConfirmPaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmPaymentRequestToJson(this);
}
