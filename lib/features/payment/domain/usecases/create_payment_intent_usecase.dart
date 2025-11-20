import '../../../../core/network/api_result.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class CreatePaymentIntentUseCase {
  final PaymentRepository repository;

  CreatePaymentIntentUseCase(this.repository);

  Future<ApiResult<PaymentEntity>> call({
    required int amount,
    String currency = 'usd',
    String? description,
    String? receiptEmail,
    Map<String, String>? metadata,
    String? userId,
  }) {
    return repository.createPaymentIntent(
      amount: amount,
      currency: currency,
      description: description,
      receiptEmail: receiptEmail,
      metadata: metadata,
      userId: userId,
    );
  }
}
