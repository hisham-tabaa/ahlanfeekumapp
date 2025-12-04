// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentSummaryResponse _$PaymentSummaryResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentSummaryResponse(
      monthlyPayments: (json['monthlyPayments'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalPayment: (json['totalPayment'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentCount: (json['paymentCount'] as num).toInt(),
    );

Map<String, dynamic> _$PaymentSummaryResponseToJson(
        PaymentSummaryResponse instance) =>
    <String, dynamic>{
      'monthlyPayments': instance.monthlyPayments,
      'totalPayment': instance.totalPayment,
      'currency': instance.currency,
      'paymentCount': instance.paymentCount,
    };
