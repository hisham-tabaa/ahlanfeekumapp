// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmPaymentRequest _$ConfirmPaymentRequestFromJson(
        Map<String, dynamic> json) =>
    ConfirmPaymentRequest(
      paymentIntentId: json['paymentIntentId'] as String,
      paymentMethodId: json['paymentMethodId'] as String,
    );

Map<String, dynamic> _$ConfirmPaymentRequestToJson(
        ConfirmPaymentRequest instance) =>
    <String, dynamic>{
      'paymentIntentId': instance.paymentIntentId,
      'paymentMethodId': instance.paymentMethodId,
    };
