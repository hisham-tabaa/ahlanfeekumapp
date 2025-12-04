// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_summary_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentSummaryRequest _$PaymentSummaryRequestFromJson(
        Map<String, dynamic> json) =>
    PaymentSummaryRequest(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
    );

Map<String, dynamic> _$PaymentSummaryRequestToJson(
        PaymentSummaryRequest instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
