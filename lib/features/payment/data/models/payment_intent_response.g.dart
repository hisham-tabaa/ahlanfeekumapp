// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentIntentResponse _$PaymentIntentResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentIntentResponse(
      id: json['id'] as String,
      clientSecret: json['clientSecret'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      amountReceived: (json['amountReceived'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaymentIntentResponseToJson(
        PaymentIntentResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientSecret': instance.clientSecret,
      'status': instance.status,
      'amount': instance.amount,
      'currency': instance.currency,
      'amountReceived': instance.amountReceived,
    };
