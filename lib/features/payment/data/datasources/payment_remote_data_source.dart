import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/payment_intent_request.dart';
import '../models/payment_intent_response.dart';
import '../models/confirm_payment_request.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentIntentResponse> createPaymentIntent(
    CreatePaymentIntentRequest request,
  );
  Future<String> createPaymentMethod({
    required String email,
    String? name,
  });
  Future<PaymentIntentResponse> confirmPayment(
    ConfirmPaymentRequest request,
  );
  Future<PaymentIntentResponse> getPaymentStatus(String paymentIntentId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSourceImpl(this._dio);

  @override
  Future<PaymentIntentResponse> createPaymentIntent(
    CreatePaymentIntentRequest request,
  ) async {
    try {
      final response = await _dio.post(
        AppConstants.createPaymentIntentEndpoint,
        data: request.toJson(),
      );

      return PaymentIntentResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createPaymentMethod({
    required String email,
    String? name,
  }) async {
    try {
      // Create payment method from the card form field
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              email: email,
              name: name,
            ),
          ),
        ),
      );

      return paymentMethod.id;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentIntentResponse> confirmPayment(
    ConfirmPaymentRequest request,
  ) async {
    try {
      final response = await _dio.post(
        AppConstants.confirmPaymentEndpoint,
        data: request.toJson(),
      );

      return PaymentIntentResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaymentIntentResponse> getPaymentStatus(
    String paymentIntentId,
  ) async {
    try {
      final response = await _dio.get(
        '${AppConstants.getPaymentStatusEndpoint}/$paymentIntentId',
      );

      return PaymentIntentResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
