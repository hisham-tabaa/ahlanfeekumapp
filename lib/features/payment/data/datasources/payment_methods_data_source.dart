import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/payment_method_model.dart';

abstract class PaymentMethodsDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods();
}

class PaymentMethodsDataSourceImpl implements PaymentMethodsDataSource {
  final Dio _dio;

  PaymentMethodsDataSourceImpl(this._dio);

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final response = await _dio.get(
        AppConstants.paymentMethodsEndpoint,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

      if (response.data is List) {
        return (response.data as List)
            .map((method) => PaymentMethodModel.fromJson(method))
            .toList();
      } else {
        // If no payment methods from API, return default options
        return _getDefaultPaymentMethods();
      }
    } catch (e) {
      // Return default payment methods on error
      return _getDefaultPaymentMethods();
    }
  }

  List<PaymentMethodModel> _getDefaultPaymentMethods() {
    return [
      const PaymentMethodModel(
        id: 1,
        name: 'Credit/Debit Card',
        description: 'Pay securely with Stripe',
        icon: 'credit_card',
        isActive: true,
      ),
      const PaymentMethodModel(
        id: 2,
        name: 'Cash on Arrival',
        description: 'Pay when you check-in',
        icon: 'cash',
        isActive: true,
      ),
    ];
  }
}
