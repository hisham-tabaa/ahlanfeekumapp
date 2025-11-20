import 'package:dartz/dartz.dart';

import '../entities/host_profile.dart';
import '../repositories/property_detail_repository.dart';

class GetHostProfileUseCase {
  final PropertyDetailRepository _repository;

  GetHostProfileUseCase(this._repository);

  Future<Either<String, HostProfile>> call(String hostId) {
    return _repository.getHostProfile(hostId);
  }
}
