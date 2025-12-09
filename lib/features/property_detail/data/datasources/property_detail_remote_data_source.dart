import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_factory.dart';
import '../models/property_detail_response.dart';
import '../models/reservation_request.dart';
import '../models/host_profile_response.dart';
import '../models/property_rating_request.dart';
import '../models/property_availability_models.dart';

abstract class PropertyDetailRemoteDataSource {
  Future<PropertyDetailResponse> getPropertyDetail(String id);
  Future<bool> addToFavorite(String propertyId);
  Future<bool> removeFromFavorite(String propertyId);
  Future<ReservationResponse> createReservation(
    CreateReservationRequest request,
  );
  Future<HostProfileResponse> getHostProfile(String hostId);
  Future<PropertyRatingResponse> rateProperty(PropertyRatingRequest request);
  Future<List<PropertyAvailabilityItem>> getPropertyAvailability(
    String propertyId,
  );
  Future<bool> addPropertyAvailability(
    List<PropertyAvailabilityRequest> requests,
  );
}

class PropertyDetailRemoteDataSourceImpl
    implements PropertyDetailRemoteDataSource {
  final Dio _dio;

  PropertyDetailRemoteDataSourceImpl(this._dio);

  @override
  Future<PropertyDetailResponse> getPropertyDetail(String id) async {
    final endpoint = '${AppConstants.propertyWithDetailsEndpoint}/$id';

    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );


      return PropertyDetailResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<bool> addToFavorite(String propertyId) async {
    final endpoint = '${AppConstants.addToFavoriteEndpoint}/$propertyId';

    try {
      final response = await _dio.post(
        endpoint,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );


      // Check if response indicates success
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Invalidate caches after successful favorite add
        DioFactory.performanceInterceptor?.invalidateCacheForPath('home-data');
        DioFactory.performanceInterceptor?.invalidateCacheForPath('property-with-details');
        DioFactory.performanceInterceptor?.invalidateCacheForPath('favorites');
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<bool> removeFromFavorite(String propertyId) async {
    final endpoint = '${AppConstants.removeFromFavoriteEndpoint}/$propertyId';

    try {
      final response = await _dio.post(
        endpoint,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );


      // Check if response indicates success
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Invalidate caches after successful favorite remove
        DioFactory.performanceInterceptor?.invalidateCacheForPath('home-data');
        DioFactory.performanceInterceptor?.invalidateCacheForPath('property-with-details');
        DioFactory.performanceInterceptor?.invalidateCacheForPath('favorites');
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<ReservationResponse> createReservation(
    CreateReservationRequest request,
  ) async {
    final endpoint = AppConstants.createReservationEndpoint;

    try {
      // Create FormData for multipart/form-data request
      final formData = FormData.fromMap({
        'FromeDate': request.fromDate,
        'ToDate': request.toDate,
        'NumberOfGuest': request.numberOfGuests,
        'Notes': request.notes,
        'SitePropertyId': request.sitePropertyId,
        'PaymentMethod': request.paymentMethod,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'multipart/form-data',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );


      // The API might return different response formats, handle both cases
      if (response.data is String) {
        return ReservationResponse(id: null, message: response.data as String);
      } else if (response.data is Map<String, dynamic>) {
        return ReservationResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        return const ReservationResponse(
          id: null,
          message: 'Reservation created successfully',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<HostProfileResponse> getHostProfile(String hostId) async {
    final endpoint = '${AppConstants.userProfileDetailsById}/$hostId';

    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );


      return HostProfileResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<PropertyRatingResponse> rateProperty(
    PropertyRatingRequest request,
  ) async {
    final endpoint = AppConstants.propertyRatingEndpoint;

    try {
      // Send as JSON instead of FormData
      final jsonData = {
        'Cleanliness': request.cleanliness,
        'PriceAndValue': request.priceAndValue,
        'Location': request.location,
        'Accuracy': request.accuracy,
        'Attitude': request.attitude,
        'RatingComment': request.ratingComment,
        'SitePropertyId': request.sitePropertyId,
      };


      final response = await _dio.post(
        endpoint,
        data: jsonData,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );


      // Handle different response formats
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Invalidate caches after successful rating
        DioFactory.performanceInterceptor?.invalidateCacheForPath('property-with-details');
        DioFactory.performanceInterceptor?.invalidateCacheForPath('home-data');
        
        if (response.data is String) {
          return PropertyRatingResponse(
            success: true,
            message: response.data as String,
          );
        } else if (response.data is Map<String, dynamic>) {
          return PropertyRatingResponse.fromJson(
            response.data as Map<String, dynamic>,
          );
        } else {
          return PropertyRatingResponse(
            success: true,
            message: 'Rating submitted successfully',
          );
        }
      } else {
        return PropertyRatingResponse(
          success: false,
          message: 'Failed to submit rating',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  /// Fetches property availability data from the backend.
  ///
  /// **CRITICAL BACKEND ISSUE:** The backend does NOT mark dates as unavailable
  /// (isAvailable: false) when there are approved reservations for those dates.
  ///
  /// **BACKEND FIX REQUIRED:**
  /// The backend MUST:
  /// - Check for existing approved reservations (status = 2) for the property
  /// - Mark dates with approved reservations as isAvailable: false
  /// - This prevents double-booking and ensures data integrity
  ///
  /// **CURRENT LIMITATION:**
  /// The backend returns isAvailable: true for dates that have approved reservations.
  /// This allows users to book the same property for the same dates multiple times.
  ///
  /// The returned data should include:
  /// - Host-defined availability (dates the host has marked as available/unavailable)
  /// - Existing reservations (booked dates should have isAvailable: false)
  @override
  Future<List<PropertyAvailabilityItem>> getPropertyAvailability(
    String propertyId,
  ) async {
    final endpoint = AppConstants.propertyCalendar;

    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: {
          'SitePropertyId': propertyId,
          'MaxResultCount': 60,
        },
        options: Options(
          headers: {
            'accept': 'text/plain',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );


      List<PropertyAvailabilityItem> items = [];

      // Handle different response formats
      if (response.data is List) {
        items = (response.data as List)
            .map(
              (item) => PropertyAvailabilityItem.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
      } else if (response.data is Map<String, dynamic>) {
        final responseObj = PropertyAvailabilityResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        items = responseObj.items ?? [];
      }


      // Log warning about potential double-booking issue
      final availableDates = items.where((item) => item.isAvailable).length;
      if (availableDates > 0) {
      }

      return items;
    } catch (error) {
      // Return empty list instead of throwing to handle properties without availability data
      return [];
    }
  }

  @override
  Future<bool> addPropertyAvailability(
    List<PropertyAvailabilityRequest> requests,
  ) async {
    final endpoint = AppConstants.addAvailability;

    try {
      final response = await _dio.post(
        endpoint,
        data: requests.map((r) => r.toJson()).toList(),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (error) {
      rethrow;
    }
  }
}
