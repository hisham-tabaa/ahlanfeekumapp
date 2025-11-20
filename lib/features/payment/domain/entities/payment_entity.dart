import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String id;
  final String status;
  final int amount;
  final String currency;
  final int? amountReceived;

  const PaymentEntity({
    required this.id,
    required this.status,
    required this.amount,
    required this.currency,
    this.amountReceived,
  });

  @override
  List<Object?> get props => [id, status, amount, currency, amountReceived];
}
