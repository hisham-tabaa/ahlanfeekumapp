import '../../../../core/network/api_result.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

class GetPaymentStatusUseCase {
  final PaymentRepository repository;

  GetPaymentStatusUseCase(this.repository);

  Future<ApiResult<PaymentEntity>> call(String paymentIntentId) {
    return repository.getPaymentStatus(paymentIntentId);
  }
}
