import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/profile_response.dart';
import '../models/update_profile_request.dart';
import '../models/change_password_request.dart';
import '../models/reservation_response.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileResponse> getProfileDetails();
  Future<void> updateProfile(UpdateProfileRequest request);
  Future<void> changePassword(ChangePasswordRequest request);
  Future<List<ReservationResponse>> getMyReservations();
  Future<List<ReservationResponse>> getUserReservations(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<ProfileResponse> getProfileDetails() async {
    const endpoint = AppConstants.userProfileDetailsEndpoint;
    print('🛰️ [Profile] Request → GET $endpoint');
    try {
      final response = await _dio.get(endpoint);
      print('✅ [Profile] Response ← ${response.statusCode} $endpoint');
      print('✅ [Profile] Payload: ${response.data}');
      return ProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      print('🚨 [Profile] Error ↩ $endpoint :: $error');
      if (error is DioException && error.response != null) {
        print('🚨 [Profile] Status: ${error.response?.statusCode}');
        print('🚨 [Profile] Body: ${error.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(UpdateProfileRequest request) async {
    final formDataMap = Map<String, dynamic>.from(request.toJson());

    if (request.profilePhotoPath != null &&
        request.profilePhotoPath!.isNotEmpty) {
      final file = File(request.profilePhotoPath!);
      if (await file.exists()) {
        formDataMap['ProfilePhoto'] = await MultipartFile.fromFile(
          file.path,
          filename: file.uri.pathSegments.isNotEmpty
              ? file.uri.pathSegments.last
              : 'profile-photo.jpg',
        );
      }
    }

    final formData = FormData.fromMap(formDataMap);

    const endpoint = AppConstants.updateMyProfileEndpoint;
    print('🛰️ [Profile] Request → POST $endpoint (form-data)');
    try {
      await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'accept': 'text/plain',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );
      print('✅ [Profile] Response ← 200 $endpoint');
    } catch (error) {
      print('🚨 [Profile] Error ↩ $endpoint :: $error');
      if (error is DioException && error.response != null) {
        print('🚨 [Profile] Status: ${error.response?.statusCode}');
        print('🚨 [Profile] Body: ${error.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    const endpoint = AppConstants.passwordChangeEndpoint;
    print('🛰️ [Profile] Request → POST $endpoint');
    try {
      await _dio.post(
        endpoint,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'text/plain',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );
      print('✅ [Profile] Response ← 200 $endpoint');
    } catch (error) {
      print('🚨 [Profile] Error ↩ $endpoint :: $error');
      if (error is DioException && error.response != null) {
        print('🚨 [Profile] Status: ${error.response?.statusCode}');
        print('🚨 [Profile] Body: ${error.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<List<ReservationResponse>> getMyReservations() async {
    const endpoint = AppConstants.myReservationsEndpoint;
    print('🛰️ [Reservations] Request → GET $endpoint');
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
      print('✅ [Reservations] Response ← ${response.statusCode} $endpoint');
      print('✅ [Reservations] Payload: ${response.data}');

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map(
            (json) =>
                ReservationResponse.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (error) {
      print('🚨 [Reservations] Error ↩ $endpoint :: $error');
      if (error is DioException && error.response != null) {
        print('🚨 [Reservations] Status: ${error.response?.statusCode}');
        print('🚨 [Reservations] Body: ${error.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<List<ReservationResponse>> getUserReservations(String userId) async {
    final endpoint = '${AppConstants.userReservationsEndpoint}/$userId';
    print('🛰️ [Reservations] Request → GET $endpoint');
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
      print('✅ [Reservations] Response ← ${response.statusCode} $endpoint');
      print('✅ [Reservations] Payload: ${response.data}');

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map(
            (json) =>
                ReservationResponse.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (error) {
      print('🚨 [Reservations] Error ↩ $endpoint :: $error');
      if (error is DioException && error.response != null) {
        print('🚨 [Reservations] Status: ${error.response?.statusCode}');
        print('🚨 [Reservations] Body: ${error.response?.data}');
      }
      rethrow;
    }
  }
}
