import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';
import '../models/payment_intent_request.dart';
import '../models/confirm_payment_request.dart';
import '../models/payment_result.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<PaymentEntity>> createPaymentIntent({
    required int amount,
    String currency = 'usd',
    String? description,
    String? receiptEmail,
    Map<String, String>? metadata,
    String? userId,
  }) async {
    try {
      final request = CreatePaymentIntentRequest(
        amount: amount,
        currency: currency,
        description: description,
        receiptEmail: receiptEmail,
        metadata: metadata,
        userId: userId,
      );

      final response = await remoteDataSource.createPaymentIntent(request);

      final entity = PaymentEntity(
        id: response.id,
        status: response.status,
        amount: response.amount,
        currency: response.currency,
        amountReceived: response.amountReceived,
      );

      return ApiResult.success(entity);
    } on ServerException catch (e) {
      return ApiResult.failure(e.message);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<String>> createPaymentMethod({
    required String email,
    String? name,
  }) async {
    try {
      final paymentMethodId = await remoteDataSource.createPaymentMethod(
        email: email,
        name: name,
      );

      return ApiResult.success(paymentMethodId);
    } on ServerException catch (e) {
      return ApiResult.failure(e.message);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<PaymentEntity>> confirmPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  }) async {
    try {
      final request = ConfirmPaymentRequest(
        paymentIntentId: paymentIntentId,
        paymentMethodId: paymentMethodId,
      );

      final response = await remoteDataSource.confirmPayment(request);

      final entity = PaymentEntity(
        id: response.id,
        status: response.status,
        amount: response.amount,
        currency: response.currency,
        amountReceived: response.amountReceived,
      );

      return ApiResult.success(entity);
    } on ServerException catch (e) {
      return ApiResult.failure(e.message);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<PaymentEntity>> getPaymentStatus(
    String paymentIntentId,
  ) async {
    try {
      final response =
          await remoteDataSource.getPaymentStatus(paymentIntentId);

      final entity = PaymentEntity(
        id: response.id,
        status: response.status,
        amount: response.amount,
        currency: response.currency,
        amountReceived: response.amountReceived,
      );

      return ApiResult.success(entity);
    } on ServerException catch (e) {
      return ApiResult.failure(e.message);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<PaymentResult> processPayment({
    required int amount,
    required String email,
    String? name,
    String? description,
    Map<String, String>? metadata,
    String? userId,
  }) async {
    try {
      final intentResult = await createPaymentIntent(
        amount: amount,
        description: description,
        receiptEmail: email,
        metadata: metadata,
        userId: userId,
      );

      if (intentResult.when(success: (_) => false, failure: (_) => true)) {
        return PaymentResult(
          success: false,
          error: intentResult.when(
            success: (_) => '',
            failure: (failure) => failure,
          ),
        );
      }

      final paymentIntent = intentResult.when(
        success: (entity) => entity,
        failure: (_) => throw Exception('Failed to create payment intent'),
      );

      final methodResult = await createPaymentMethod(
        email: email,
        name: name,
      );

      if (methodResult.when(success: (_) => false, failure: (_) => true)) {
        return PaymentResult(
          success: false,
          error: methodResult.when(
            success: (_) => '',
            failure: (failure) => failure,
          ),
        );
      }

      final paymentMethodId = methodResult.when(
        success: (id) => id,
        failure: (_) => throw Exception('Failed to create payment method'),
      );

      final confirmResult = await confirmPayment(
        paymentIntentId: paymentIntent.id,
        paymentMethodId: paymentMethodId,
      );

      if (confirmResult.when(success: (_) => false, failure: (_) => true)) {
        return PaymentResult(
          success: false,
          error: confirmResult.when(
            success: (_) => '',
            failure: (failure) => failure,
          ),
        );
      }

      final confirmedPayment = confirmResult.when(
        success: (entity) => entity,
        failure: (_) => throw Exception('Failed to confirm payment'),
      );

      return PaymentResult(
        success: confirmedPayment.status == 'succeeded',
        paymentIntentId: confirmedPayment.id,
        status: confirmedPayment.status,
        amount: confirmedPayment.amount,
      );
    } catch (e) {
      return PaymentResult(
        success: false,
        error: e.toString(),
      );
    }
  }
}
