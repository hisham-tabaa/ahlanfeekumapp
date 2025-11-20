// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePaymentIntentRequest _$CreatePaymentIntentRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePaymentIntentRequest(
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String? ?? 'usd',
      description: json['description'] as String?,
      receiptEmail: json['receiptEmail'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$CreatePaymentIntentRequestToJson(
        CreatePaymentIntentRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency': instance.currency,
      'description': instance.description,
      'receiptEmail': instance.receiptEmail,
      'metadata': instance.metadata,
      'userId': instance.userId,
    };
