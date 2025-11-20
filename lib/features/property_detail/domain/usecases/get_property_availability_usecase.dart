import 'package:dartz/dartz.dart';
import '../../data/models/property_availability_models.dart';
import '../repositories/property_detail_repository.dart';

class GetPropertyAvailabilityUseCase {
  final PropertyDetailRepository _repository;

  GetPropertyAvailabilityUseCase(this._repository);

  Future<Either<String, List<PropertyAvailabilityItem>>> call(
    String propertyId,
  ) {
    return _repository.getPropertyAvailability(propertyId);
  }
}
