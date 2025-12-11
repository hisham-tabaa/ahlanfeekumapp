import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/utils/file_upload_helper.dart';
import '../../../../core/utils/universal_io.dart';
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
    try {
      final response = await _dio.get(endpoint);
      return ProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      if (error is DioException && error.response != null) {}
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(UpdateProfileRequest request) async {
    final formDataMap = Map<String, dynamic>.from(request.toJson());

    if (request.isProfilePhotoChanged) {
      // Use XFile if available (web compatible), otherwise fallback to path
      if (request.profilePhotoFile != null) {
        formDataMap['ProfilePhoto'] =
            await FileUploadHelper.createMultipartFile(
              request.profilePhotoFile!,
              filename: 'profile-photo.jpg',
            );
      } else if (request.profilePhotoPath != null &&
          request.profilePhotoPath!.isNotEmpty) {
        final file = File(request.profilePhotoPath!);
        if (await file.exists()) {
          formDataMap['ProfilePhoto'] =
              await FileUploadHelper.createMultipartFileFromPath(
                file.path,
                filename: file.uri.pathSegments.isNotEmpty
                    ? file.uri.pathSegments.last
                    : 'profile-photo.jpg',
              );
        }
      }
    }

    final formData = FormData.fromMap(formDataMap);

    const endpoint = AppConstants.updateMyProfileEndpoint;
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

      // Invalidate profile cache after successful update
      DioFactory.performanceInterceptor?.invalidateCacheForPath('user-profile');
    } catch (error) {
      if (error is DioException && error.response != null) {}
      rethrow;
    }
  }

  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    const endpoint = AppConstants.passwordChangeEndpoint;
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
    } catch (error) {
      if (error is DioException && error.response != null) {}
      rethrow;
    }
  }

  @override
  Future<List<ReservationResponse>> getMyReservations() async {
    const endpoint = AppConstants.myReservationsEndpoint;
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

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map(
            (json) =>
                ReservationResponse.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (error) {
      if (error is DioException && error.response != null) {}
      rethrow;
    }
  }

  @override
  Future<List<ReservationResponse>> getUserReservations(String userId) async {
    final endpoint = '${AppConstants.userReservationsEndpoint}/$userId';
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

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map(
            (json) =>
                ReservationResponse.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (error) {
      if (error is DioException && error.response != null) {}
      rethrow;
    }
  }
}
