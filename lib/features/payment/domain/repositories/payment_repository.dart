import '../../../../core/network/api_result.dart';
import '../entities/payment_entity.dart';
import '../../data/models/payment_result.dart';

abstract class PaymentRepository {
  Future<ApiResult<PaymentEntity>> createPaymentIntent({
    required int amount,
    String currency = 'usd',
    String? description,
    String? receiptEmail,
    Map<String, String>? metadata,
    String? userId,
  });

  Future<ApiResult<String>> createPaymentMethod({
    required String email,
    String? name,
  });

  Future<ApiResult<PaymentEntity>> confirmPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  });

  Future<ApiResult<PaymentEntity>> getPaymentStatus(String paymentIntentId);

  Future<PaymentResult> processPayment({
    required int amount,
    required String email,
    String? name,
    String? description,
    Map<String, String>? metadata,
    String? userId,
  });
}
