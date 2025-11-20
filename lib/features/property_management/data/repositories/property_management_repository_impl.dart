import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/managed_property.dart';
import '../../domain/entities/property_calendar_status.dart';
import '../../domain/repositories/property_management_repository.dart';
import '../datasources/property_management_remote_data_source.dart';
import '../models/property_calendar_status_model.dart';

class PropertyManagementRepositoryImpl implements PropertyManagementRepository {
  final PropertyManagementRemoteDataSource remoteDataSource;

  PropertyManagementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ManagedProperty>>> getHostProperties() async {
    try {
      final models = await remoteDataSource.getHostProperties();
      return Right(models.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Server error'));
    } on NetworkException {
      return Left(NetworkFailure('Network error'));
    } catch (e) {
      return Left(UnknownFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<PropertyCalendarStatus>>> getPropertyCalendarStatuses(
    String propertyId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    try {
      final models = await remoteDataSource.getPropertyCalendarStatuses(
        propertyId,
        startDate,
        endDate,
      );
      return Right(models.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Server error'));
    } on NetworkException {
      return Left(NetworkFailure('Network error'));
    } catch (e) {
      return Left(UnknownFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePropertyAvailability(
    List<PropertyCalendarStatus> availabilities,
  ) async {
    try {
      final models = availabilities
          .map((entity) => PropertyCalendarStatusModel.fromEntity(entity))
          .toList();
      await remoteDataSource.updatePropertyAvailability(models);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure('Server error'));
    } on NetworkException {
      return Left(NetworkFailure('Network error'));
    } catch (e) {
      return Left(UnknownFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Unit>> togglePropertyStatus(
    String propertyId,
    bool isActive,
  ) async {
    try {
      await remoteDataSource.togglePropertyStatus(propertyId, isActive);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure('Server error'));
    } on NetworkException {
      return Left(NetworkFailure('Network error'));
    } catch (e) {
      return Left(UnknownFailure('An unexpected error occurred'));
    }
  }
}
