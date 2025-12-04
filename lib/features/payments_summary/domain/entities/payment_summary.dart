class PaymentSummary {
  final Map<String, double> monthlyPayments;
  final double totalPayment;
  final String currency;
  final int paymentCount;

  PaymentSummary({
    required this.monthlyPayments,
    required this.totalPayment,
    required this.currency,
    required this.paymentCount,
  });
}
