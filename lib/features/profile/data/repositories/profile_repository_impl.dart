import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/reservation.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_response.dart';
import '../models/update_profile_request.dart';
import '../models/change_password_request.dart';
import '../mappers/reservation_mapper.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<String, Profile>> getProfileDetails() async {
    try {
      final response = await _remoteDataSource.getProfileDetails();
      final profile = _mapResponseToEntity(response);
      return Right(profile);
    } catch (e) {
      return Left(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, Unit>> updateProfile(
    UpdateProfileRequest request,
  ) async {
    try {
      await _remoteDataSource.updateProfile(request);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, Unit>> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      await _remoteDataSource.changePassword(request);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, List<Reservation>>> getMyReservations() async {
    try {
      final response = await _remoteDataSource.getMyReservations();
      final reservations = response.toEntities();
      return Right(reservations);
    } catch (e) {
      return Left(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, List<Reservation>>> getUserReservations(
    String userId,
  ) async {
    try {
      final response = await _remoteDataSource.getUserReservations(userId);
      final reservations = response.toEntities();
      return Right(reservations);
    } catch (e) {
      return Left(ErrorHandler.getErrorMessage(e));
    }
  }

  Profile _mapResponseToEntity(ProfileResponse response) {
    String? mapImageUrl(String? path) {
      if (path == null || path.isEmpty) {
        return null;
      }

      if (path.startsWith('http')) {
        return path;
      }

      final baseUrl = AppConstants.baseUrl.replaceAll('/api/mobile/', '');
      final fullUrl = path.startsWith('/') ? '$baseUrl$path' : '$baseUrl/$path';
      return fullUrl;
    }

    final favoriteProperties = response.favoriteProperties
        .map(
          (dto) => ProfileProperty(
            id: dto.id,
            title: dto.propertyTitle,
            hotelName: dto.hotelName,
            address: dto.address,
            streetAndBuildingNumber: dto.streetAndBuildingNumber,
            landMark: dto.landMark,
            averageRating: dto.averageRating,
            pricePerNight: dto.pricePerNight,
            isActive: dto.isActive,
            isFavorite: dto.isFavorite,
            area: dto.area,
            mainImageUrl: mapImageUrl(dto.mainImage),
          ),
        )
        .toList();

    final myProperties = response.myProperties
        .map(
          (dto) => ProfileProperty(
            id: dto.id,
            title: dto.propertyTitle,
            hotelName: dto.hotelName,
            address: dto.address,
            streetAndBuildingNumber: dto.streetAndBuildingNumber,
            landMark: dto.landMark,
            averageRating: dto.averageRating,
            pricePerNight: dto.pricePerNight,
            isActive: dto.isActive,
            isFavorite: dto.isFavorite,
            area: dto.area,
            mainImageUrl: mapImageUrl(dto.mainImage),
          ),
        )
        .toList();

    return Profile(
      id: response.id,
      name: response.name,
      email: response.email,
      phoneNumber: response.phoneNumber,
      latitude: response.latitude,
      longitude: response.longitude,
      address: response.address,
      profilePhotoUrl: mapImageUrl(response.profilePhoto),
      isSuperHost: response.isSuperHost,
      speedOfCompletion: response.speedOfCompletion,
      dealing: response.dealing,
      cleanliness: response.cleanliness,
      perfection: response.perfection,
      price: response.price,
      favoriteProperties: favoriteProperties,
      myProperties: myProperties,
    );
  }
}
