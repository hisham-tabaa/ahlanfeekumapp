import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_summary.dart';

abstract class PaymentSummaryState extends Equatable {
  const PaymentSummaryState();

  @override
  List<Object?> get props => [];
}

class PaymentSummaryInitial extends PaymentSummaryState {}

class PaymentSummaryLoading extends PaymentSummaryState {}

class PaymentSummaryLoaded extends PaymentSummaryState {
  final PaymentSummary paymentSummary;

  const PaymentSummaryLoaded(this.paymentSummary);

  @override
  List<Object?> get props => [paymentSummary];
}

class PaymentSummaryError extends PaymentSummaryState {
  final String message;

  const PaymentSummaryError(this.message);

  @override
  List<Object?> get props => [message];
}
