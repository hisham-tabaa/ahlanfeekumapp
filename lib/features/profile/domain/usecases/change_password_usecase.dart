import 'package:dartz/dartz.dart';

import '../../data/models/change_password_request.dart';
import '../repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<Either<String, Unit>> call(ChangePasswordRequest request) {
    return _repository.changePassword(request);
  }
}
