import 'package:dartz/dartz.dart';

import '../../data/models/update_profile_request.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<String, Unit>> call(UpdateProfileRequest request) {
    return _repository.updateProfile(request);
  }
}
