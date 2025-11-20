import 'package:dartz/dartz.dart';

import '../entities/property_detail.dart';
import '../repositories/property_detail_repository.dart';

class GetPropertyDetailUseCase {
  final PropertyDetailRepository _repository;

  GetPropertyDetailUseCase(this._repository);

  Future<Either<String, PropertyDetail>> call(String id) {
    return _repository.getPropertyDetail(id);
  }
}
