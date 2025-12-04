import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_summary.dart';
import '../repositories/payment_summary_repository.dart';

class GetPaymentSummaryUseCase {
  final PaymentSummaryRepository repository;

  GetPaymentSummaryUseCase(this.repository);

  Future<Either<Failure, PaymentSummary>> call({
    required String startDate,
    required String endDate,
  }) async {
    return await repository.getPaymentSummary(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
