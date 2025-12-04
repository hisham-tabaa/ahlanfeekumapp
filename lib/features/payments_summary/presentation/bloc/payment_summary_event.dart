import 'package:equatable/equatable.dart';

abstract class PaymentSummaryEvent extends Equatable {
  const PaymentSummaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadPaymentSummaryEvent extends PaymentSummaryEvent {
  final String startDate;
  final String endDate;

  const LoadPaymentSummaryEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class RefreshPaymentSummaryEvent extends PaymentSummaryEvent {
  final String startDate;
  final String endDate;

  const RefreshPaymentSummaryEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
