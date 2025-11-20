import '../../../../core/network/api_result.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class ConfirmPaymentUseCase {
  final PaymentRepository repository;

  ConfirmPaymentUseCase(this.repository);

  Future<ApiResult<PaymentEntity>> call({
    required String paymentIntentId,
    required String paymentMethodId,
  }) {
    return repository.confirmPayment(
      paymentIntentId: paymentIntentId,
      paymentMethodId: paymentMethodId,
    );
  }
}
