import 'package:dartz/dartz.dart';
import '../../data/models/property_rating_request.dart';
import '../repositories/property_detail_repository.dart';

class RatePropertyUseCase {
  final PropertyDetailRepository _repository;

  RatePropertyUseCase(this._repository);

  Future<Either<String, bool>> call(PropertyRatingRequest request) async {
    return await _repository.rateProperty(request);
  }
}
