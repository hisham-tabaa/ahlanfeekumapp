import 'package:dartz/dartz.dart';

import '../repositories/property_detail_repository.dart';

class ToggleFavoriteUseCase {
  final PropertyDetailRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Future<Either<String, bool>> addToFavorite(String propertyId) {
    return _repository.addToFavorite(propertyId);
  }

  Future<Either<String, bool>> removeFromFavorite(String propertyId) {
    return _repository.removeFromFavorite(propertyId);
  }
}
