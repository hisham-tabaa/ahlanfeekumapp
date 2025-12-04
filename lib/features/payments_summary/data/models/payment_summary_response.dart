import 'package:json_annotation/json_annotation.dart';

part 'payment_summary_response.g.dart';

@JsonSerializable()
class PaymentSummaryResponse {
  final Map<String, double> monthlyPayments;
  final double totalPayment;
  final String currency;
  final int paymentCount;

  PaymentSummaryResponse({
    required this.monthlyPayments,
    required this.totalPayment,
    required this.currency,
    required this.paymentCount,
  });

  factory PaymentSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentSummaryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentSummaryResponseToJson(this);
}
