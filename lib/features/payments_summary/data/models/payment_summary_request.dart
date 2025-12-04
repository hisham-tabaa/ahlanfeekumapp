import 'package:json_annotation/json_annotation.dart';

part 'payment_summary_request.g.dart';

@JsonSerializable()
class PaymentSummaryRequest {
  final String startDate;
  final String endDate;

  PaymentSummaryRequest({
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => _$PaymentSummaryRequestToJson(this);

  factory PaymentSummaryRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentSummaryRequestFromJson(json);
}
