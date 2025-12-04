import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class CheckUserExistsUseCase {
  final AuthRepository repository;

  CheckUserExistsUseCase(this.repository);

  Future<Either<Failure, bool>> call(String phoneOrEmail) async {
    return await repository.checkUserExists(phoneOrEmail: phoneOrEmail);
  }
}
