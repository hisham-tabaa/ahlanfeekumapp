import '../../data/models/payment_result.dart';
import '../repositories/payment_repository.dart';

class ProcessPaymentUseCase {
  final PaymentRepository repository;

  ProcessPaymentUseCase(this.repository);

  Future<PaymentResult> call({
    required int amount,
    required String email,
    String? name,
    String? description,
    Map<String, String>? metadata,
    String? userId,
  }) {
    return repository.processPayment(
      amount: amount,
      email: email,
      name: name,
      description: description,
      metadata: metadata,
      userId: userId,
    );
  }
}
