import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/property_detail.dart';
import '../../domain/entities/host_profile.dart';
import '../../domain/repositories/property_detail_repository.dart';
import '../datasources/property_detail_remote_data_source.dart';
import '../models/property_detail_response.dart';
import '../models/host_profile_response.dart';
import '../models/property_rating_request.dart';
import '../models/property_availability_models.dart';

class PropertyDetailRepositoryImpl implements PropertyDetailRepository {
  final PropertyDetailRemoteDataSource _remoteDataSource;

  PropertyDetailRepositoryImpl({
    required PropertyDetailRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<String, PropertyDetail>> getPropertyDetail(String id) async {
    try {
      final response = await _remoteDataSource.getPropertyDetail(id);
      final entity = _mapResponseToEntity(response);
      return Right(entity);
    } catch (e) {
      return Left(ErrorHandler.getErrorMessage(e));
    }
  }

  PropertyDetail _mapResponseToEntity(PropertyDetailResponse response) {
    String? mapImageUrl(String? path) {
      if (path == null || path.isEmpty) {
        return null;
      }
      if (path.startsWith('http')) {
        return path;
      }

      final baseUrl = AppConstants.baseUrl.replaceAll('/api/mobile/', '');
      if (path.startsWith('/')) {
        return '$baseUrl$path';
      }
      return '$baseUrl/$path';
    }

    final features = response.propertyFeatures
        .map(
          (item) => PropertyFeature(
            id: item.id,
            title: item.title,
            iconUrl: mapImageUrl(item.icon),
            order: item.order,
            isActive: item.isActive,
          ),
        )
        .toList();

    final media = response.propertyMedia
        .map(
          (item) => PropertyMedia(
            id: item.id,
            imageUrl: mapImageUrl(item.image),
            order: item.order,
            isActive: item.isActive,
          ),
        )
        .toList();

    final evaluations = response.propertyEvaluations
        .map(
          (item) => PropertyEvaluation(
            id: item.id,
            cleanliness: item.cleanliness,
            priceAndValue: item.priceAndValue,
            location: item.location,
            accuracy: item.accuracy,
            attitude: item.attitude,
            comment: item.ratingComment,
            userProfileId: item.userProfileId,
            userProfileName: item.userProfileName,
          ),
        )
        .toList();

    return PropertyDetail(
      id: response.id,
      title: response.propertyTitle,
      hotelName: response.hotelName,
      bedrooms: response.bedrooms,
      bathrooms: response.bathrooms,
      numberOfBeds: response.numberOfBed,
      floor: response.floor,
      maxGuests: response.maximumNumberOfGuest,
      livingrooms: response.livingrooms,
      description: response.propertyDescription,
      houseRules: response.hourseRules,
      importantInformation: response.importantInformation,
      address: response.address,
      streetAndBuildingNumber: response.streetAndBuildingNumber,
      landMark: response.landMark,
      latitude: response.latitude,
      longitude: response.longitude,
      pricePerNight: response.pricePerNight,
      isActive: response.isActive,
      isFavorite: response.isFavorite,
      propertyTypeName: response.propertyTypeName,
      governorateName: response.governorateName,
      ownerName: response.ownerName,
      ownerId: response.ownerId,
      area: response.area,
      mainImageUrl: mapImageUrl(response.mainImage),
      features: features,
      media: media,
      evaluations: evaluations,
      averageRating: response.averageRating,
      averageCleanliness: response.averageCleanliness,
      averagePriceAndValue: response.averagePriceAndValue,
      averageLocation: response.averageLocation,
      averageAccuracy: response.averageAccuracy,
      averageAttitude: response.averageAttitude,
    );
  }

  @override
  Future<Either<String, bool>> addToFavorite(String propertyId) async {
    try {
      final result = await _remoteDataSource.addToFavorite(propertyId);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, bool>> removeFromFavorite(String propertyId) async {
    try {
      final result = await _remoteDataSource.removeFromFavorite(propertyId);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, bool>> rateProperty(
    PropertyRatingRequest request,
  ) async {
    try {
      final response = await _remoteDataSource.rateProperty(request);
      return Right(response.success);
    } catch (e) {
      return Left(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, List<PropertyAvailabilityItem>>>
  getPropertyAvailability(String propertyId) async {
    try {
      final result = await _remoteDataSource.getPropertyAvailability(
        propertyId,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Either<String, HostProfile>> getHostProfile(String hostId) async {
    try {
      final response = await _remoteDataSource.getHostProfile(hostId);
      final entity = _mapHostProfileResponseToEntity(response);
      return Right(entity);
    } catch (e) {
      return Left(ErrorHandler.getErrorMessage(e));
    }
  }

  HostProfile _mapHostProfileResponseToEntity(HostProfileResponse response) {
    String? mapImageUrl(String? path) {
      if (path == null || path.isEmpty) {
        return null;
      }
      if (path.startsWith('http')) {
        return path;
      }

      final baseUrl = AppConstants.baseUrl.replaceAll('/api/mobile/', '');
      if (path.startsWith('/')) {
        return '$baseUrl$path';
      }
      return '$baseUrl/$path';
    }

    final properties = (response.myProperties ?? [])
        .where(
          (item) => item.isActive ?? false,
        ) // Filter only approved properties
        .map(
          (item) => HostProperty(
            id: item.id,
            title: item.propertyTitle,
            address: item.address,
            landMark: item.landMark,
            mainImageUrl: mapImageUrl(item.mainImage),
            pricePerNight: item.pricePerNight ?? 0.0,
            averageRating: item.averageRating ?? 0.0,
            isFavorite: item.isFavorite ?? false,
            isActive: item.isActive ?? false,
          ),
        )
        .toList();

    return HostProfile(
      id: response.id,
      name: response.name,
      email: response.email,
      phoneNumber: response.phoneNumber,
      address: response.address,
      profilePhotoUrl: mapImageUrl(response.profilePhoto),
      isSuperHost: response.isSuperHost ?? false,
      properties: properties,
    );
  }
}
