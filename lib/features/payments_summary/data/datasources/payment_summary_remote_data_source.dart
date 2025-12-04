import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/payment_summary_request.dart';
import '../models/payment_summary_response.dart';

abstract class PaymentSummaryRemoteDataSource {
  Future<PaymentSummaryResponse> getPaymentSummary(PaymentSummaryRequest request);
}

class PaymentSummaryRemoteDataSourceImpl implements PaymentSummaryRemoteDataSource {
  final Dio dio;

  PaymentSummaryRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaymentSummaryResponse> getPaymentSummary(PaymentSummaryRequest request) async {
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.paymentSummaryEndpoint}';

      final response = await dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

      if (response.statusCode == 200) {
        return PaymentSummaryResponse.fromJson(response.data);
      } else {
        throw ServerException(
          'Get payment summary failed with status code: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('Network connection error');
      } else if (e.response != null) {
        final errorMessage =
            e.response?.data?['message'] ?? 'Get payment summary failed';
        throw ServerException(errorMessage, e.response?.statusCode);
      } else {
        throw const NetworkException('Unknown network error');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
