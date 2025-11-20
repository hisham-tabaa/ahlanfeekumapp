import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class VerifyPhoneUseCase {
  final AuthRepository repository;

  VerifyPhoneUseCase(this.repository);

  Future<Either<Failure, AuthResult>> call({
    required String phone,
    required String otp,
  }) {
    return repository.verifyPhone(phone: phone, otp: otp);
  }
}
