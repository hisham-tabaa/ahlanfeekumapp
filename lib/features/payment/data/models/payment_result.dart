class PaymentResult {
  final bool success;
  final String? paymentIntentId;
  final String? status;
  final int? amount;
  final String? error;

  const PaymentResult({
    required this.success,
    this.paymentIntentId,
    this.status,
    this.amount,
    this.error,
  });
}
