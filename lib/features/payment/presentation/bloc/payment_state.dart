import 'package:equatable/equatable.dart';
import '../../data/models/payment_result.dart';
import '../../domain/entities/payment_entity.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class PaymentIntentCreated extends PaymentState {
  final PaymentEntity payment;

  const PaymentIntentCreated(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentConfirmed extends PaymentState {
  final PaymentEntity payment;

  const PaymentConfirmed(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentSuccess extends PaymentState {
  final PaymentResult result;

  const PaymentSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class PaymentFailure extends PaymentState {
  final String error;

  const PaymentFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class PaymentStatusLoaded extends PaymentState {
  final PaymentEntity payment;

  const PaymentStatusLoaded(this.payment);

  @override
  List<Object?> get props => [payment];
}
