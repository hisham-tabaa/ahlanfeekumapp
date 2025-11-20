import 'package:dartz/dartz.dart';

import '../entities/property_detail.dart';
import '../entities/host_profile.dart';
import '../../data/models/property_rating_request.dart';
import '../../data/models/property_availability_models.dart';

abstract class PropertyDetailRepository {
  Future<Either<String, PropertyDetail>> getPropertyDetail(String id);
  Future<Either<String, HostProfile>> getHostProfile(String hostId);
  Future<Either<String, bool>> addToFavorite(String propertyId);
  Future<Either<String, bool>> removeFromFavorite(String propertyId);
  Future<Either<String, bool>> rateProperty(PropertyRatingRequest request);
  Future<Either<String, List<PropertyAvailabilityItem>>>
  getPropertyAvailability(String propertyId);
}
