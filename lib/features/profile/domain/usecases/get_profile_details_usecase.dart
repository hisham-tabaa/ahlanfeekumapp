import 'package:dartz/dartz.dart';

import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class GetProfileDetailsUseCase {
  final ProfileRepository _repository;

  GetProfileDetailsUseCase(this._repository);

  Future<Either<String, Profile>> call() {
    return _repository.getProfileDetails();
  }
}
