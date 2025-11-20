import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class ProcessPaymentEvent extends PaymentEvent {
  final int amount;
  final String email;
  final String? name;
  final String? description;
  final Map<String, String>? metadata;
  final String? userId;

  const ProcessPaymentEvent({
    required this.amount,
    required this.email,
    this.name,
    this.description,
    this.metadata,
    this.userId,
  });

  @override
  List<Object?> get props => [amount, email, name, description, metadata, userId];
}

class CreatePaymentIntentEvent extends PaymentEvent {
  final int amount;
  final String currency;
  final String? description;
  final String? receiptEmail;
  final Map<String, String>? metadata;
  final String? userId;

  const CreatePaymentIntentEvent({
    required this.amount,
    this.currency = 'usd',
    this.description,
    this.receiptEmail,
    this.metadata,
    this.userId,
  });

  @override
  List<Object?> get props =>
      [amount, currency, description, receiptEmail, metadata, userId];
}

class ConfirmPaymentEvent extends PaymentEvent {
  final String paymentIntentId;
  final String paymentMethodId;

  const ConfirmPaymentEvent({
    required this.paymentIntentId,
    required this.paymentMethodId,
  });

  @override
  List<Object?> get props => [paymentIntentId, paymentMethodId];
}

class GetPaymentStatusEvent extends PaymentEvent {
  final String paymentIntentId;

  const GetPaymentStatusEvent(this.paymentIntentId);

  @override
  List<Object?> get props => [paymentIntentId];
}

class ResetPaymentEvent extends PaymentEvent {
  const ResetPaymentEvent();
}
