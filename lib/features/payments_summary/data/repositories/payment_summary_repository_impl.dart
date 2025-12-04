import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/payment_summary_repository.dart';
import '../../domain/entities/payment_summary.dart';
import '../datasources/payment_summary_remote_data_source.dart';
import '../models/payment_summary_request.dart';

class PaymentSummaryRepositoryImpl implements PaymentSummaryRepository {
  final PaymentSummaryRemoteDataSource remoteDataSource;

  PaymentSummaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaymentSummary>> getPaymentSummary({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final request = PaymentSummaryRequest(
        startDate: startDate,
        endDate: endDate,
      );

      final response = await remoteDataSource.getPaymentSummary(request);

      final paymentSummary = PaymentSummary(
        monthlyPayments: response.monthlyPayments,
        totalPayment: response.totalPayment,
        currency: response.currency,
        paymentCount: response.paymentCount,
      );

      return Right(paymentSummary);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to get payment summary: $e'));
    }
  }
}
