import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/managed_property.dart';
import '../entities/property_calendar_status.dart';

abstract class PropertyManagementRepository {
  Future<Either<Failure, List<ManagedProperty>>> getHostProperties();
  
  Future<Either<Failure, List<PropertyCalendarStatus>>> getPropertyCalendarStatuses(
    String propertyId,
    DateTime? startDate,
    DateTime? endDate,
  );
  
  Future<Either<Failure, Unit>> updatePropertyAvailability(
    List<PropertyCalendarStatus> availabilities,
  );
  
  Future<Either<Failure, Unit>> togglePropertyStatus(
    String propertyId,
    bool isActive,
  );
}
