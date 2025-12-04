import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_summary.dart';

abstract class PaymentSummaryRepository {
  Future<Either<Failure, PaymentSummary>> getPaymentSummary({
    required String startDate,
    required String endDate,
  });
}
