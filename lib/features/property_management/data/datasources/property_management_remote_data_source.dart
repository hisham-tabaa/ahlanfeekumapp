import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/managed_property_model.dart';
import '../models/property_calendar_status_model.dart';
import '../../../auth/data/models/user_model.dart';

abstract class PropertyManagementRemoteDataSource {
  Future<List<ManagedPropertyModel>> getHostProperties();
  Future<List<PropertyCalendarStatusModel>> getPropertyCalendarStatuses(
    String propertyId,
    DateTime? startDate,
    DateTime? endDate,
  );
  Future<void> updatePropertyAvailability(
    List<PropertyCalendarStatusModel> availabilities,
  );
  Future<void> togglePropertyStatus(String propertyId, bool isActive);
}

class PropertyManagementRemoteDataSourceImpl
    implements PropertyManagementRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  PropertyManagementRemoteDataSourceImpl({
    required this.dio,
    required this.sharedPreferences,
  });

  @override
  Future<List<ManagedPropertyModel>> getHostProperties() async {
    try {
      // Get the current user's ID from shared preferences
      String? ownerId;
      try {
        final userJson = sharedPreferences.getString(AppConstants.userDataKey);
        if (userJson != null) {
          final userMap = json.decode(userJson) as Map<String, dynamic>;
          final user = UserModel.fromJson(userMap);
          ownerId = user.id;
        }
      } catch (e) {
        // Silently handle error getting user ID
      }

      final queryParams = <String, dynamic>{};

      // Add OwnerId if available
      if (ownerId != null && ownerId.isNotEmpty) {
        queryParams['OwnerId'] = ownerId;
      }

      final response = await dio.get(
        '/properties/search-property',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'] ?? [];
        return items
            .map((json) => ManagedPropertyModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Server error');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Request timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Server error');
      }
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<List<PropertyCalendarStatusModel>> getPropertyCalendarStatuses(
    String propertyId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    try {
      final response = await dio.get(
        '/properties/property-calendar-statuses',
        queryParameters: {'SitePropertyId': propertyId, 'MaxResultCount': 60},
      );

      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'] ?? [];
        return items
            .map((json) => PropertyCalendarStatusModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Server error');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Request timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Server error');
      }
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> updatePropertyAvailability(
    List<PropertyCalendarStatusModel> availabilities,
  ) async {
    try {
      final response = await dio.post(
        '/properties/update-availability',
        data: availabilities.map((e) => e.toJson()).toList(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Server error');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Request timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Server error');
      }
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  @override
  Future<void> togglePropertyStatus(String propertyId, bool isActive) async {
    try {
      final response = await dio.post(
        '/properties/activate-deactivate',
        data: {'propertyId': propertyId, 'isActive': isActive},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Server error');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ServerException('Request timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Server error');
      }
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }
}
