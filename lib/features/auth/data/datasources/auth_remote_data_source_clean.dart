import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/otp_response.dart';
import '../models/otp_verification_response.dart';
import '../models/register_user_request.dart';
import '../models/register_user_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<OtpResponse> sendOtpEmail(String email);
  Future<OtpResponse> sendOtpPhone(String phone);
  Future<OtpVerificationResponse> verifyOtp(
    String emailOrPhone,
    String securityCode,
  );
  Future<OtpResponse> requestPasswordReset(String emailOrPhone);
  Future<OtpResponse> confirmPasswordReset(
    String emailOrPhone,
    String securityCode,
    String newPassword,
  );
  Future<RegisterUserResponse> registerUser(RegisterUserRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.loginEndpoint}';
      final requestData = request.toJson();

      final response = await dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        return loginResponse;
      } else {
        throw ServerException(
          'Login failed with status code: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('Network connection error');
      } else if (e.response != null) {
        final errorMessage = e.response?.data?['message'] ?? 'Login failed';
        throw ServerException(errorMessage, e.response?.statusCode);
      } else {
        throw const ServerException('Unknown server error');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<OtpResponse> sendOtpEmail(String email) async {
    try {
      final url =
          '${AppConstants.baseUrl}${AppConstants.sendOtpEmailEndpoint}?email=$email';

      final response = await dio.post(
        url,
        data: '',
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

      if (response.statusCode == 200) {
        final otpResponse = OtpResponse.fromJson(response.data);
        return otpResponse;
      } else {
        throw ServerException(
          'Send OTP failed with status code: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('Network connection error');
      } else if (e.response != null) {
        final errorMessage = e.response?.data?['message'] ?? 'Send OTP failed';
        throw ServerException(errorMessage, e.response?.statusCode);
      } else {
        throw const NetworkException('Unknown network error');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<OtpResponse> sendOtpPhone(String phone) async {
    try {
      final url =
          '${AppConstants.baseUrl}${AppConstants.sendOtpPhoneEndpoint}?input=$phone';

      final response = await dio.post(
        url,
        data: '',
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

      if (response.statusCode == 200) {
        final otpResponse = OtpResponse.fromJson(response.data);
        return otpResponse;
      } else {
        throw ServerException(
          'Send OTP failed with status code: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('Network connection error');
      } else if (e.response != null) {
        final errorMessage = e.response?.data?['message'] ?? 'Send OTP failed';
        throw ServerException(errorMessage, e.response?.statusCode);
      } else {
        throw const NetworkException('Unknown network error');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<OtpVerificationResponse> verifyOtp(
    String emailOrPhone,
    String securityCode,
  ) async {
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.verifyOtpEndpoint}';
      final requestData = {
        'emailOrPhone': emailOrPhone,
        'securityCode': securityCode,
      };

      final response = await dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

      if (response.statusCode == 200) {
        return OtpVerificationResponse.fromJson(response.data);
      } else {
        throw ServerException(
          'Verify OTP failed with status code: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('Network connection error');
      } else if (e.response != null) {
        final errorMessage =
            e.response?.data?['message'] ?? 'Verify OTP failed';
        throw ServerException(errorMessage, e.response?.statusCode);
      } else {
        throw const NetworkException('Unknown network error');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<OtpResponse> requestPasswordReset(String emailOrPhone) async {
    try {
      final url =
          '${AppConstants.baseUrl}${AppConstants.passwordResetRequestEndpoint}';
      final requestData = {'emailOrPhone': emailOrPhone};

      final response = await dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

      if (response.statusCode == 200) {
        return OtpResponse.fromJson(response.data);
      } else {
        throw ServerException(
          'Password reset request failed with status code: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('Network connection error');
      } else if (e.response != null) {
        final errorMessage =
            e.response?.data?['message'] ?? 'Password reset request failed';
        throw ServerException(errorMessage, e.response?.statusCode);
      } else {
        throw const NetworkException('Unknown network error');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<OtpResponse> confirmPasswordReset(
    String emailOrPhone,
    String securityCode,
    String newPassword,
  ) async {
    try {
      final url =
          '${AppConstants.baseUrl}${AppConstants.confirmPasswordResetEndpoint}';
      final requestData = {
        'emailOrPhone': emailOrPhone,
        'securityCode': securityCode,
        'newPassword': newPassword,
      };

      final response = await dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );

      if (response.statusCode == 200) {
        return OtpResponse.fromJson(response.data);
      } else {
        throw ServerException(
          'Confirm password reset failed with status code: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('Network connection error');
      } else if (e.response != null) {
        final errorMessage =
            e.response?.data?['message'] ?? 'Confirm password reset failed';
        throw ServerException(errorMessage, e.response?.statusCode);
      } else {
        throw const NetworkException('Unknown network error');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<RegisterUserResponse> registerUser(RegisterUserRequest request) async {
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.registerUserEndpoint}';

      final formData = FormData.fromMap({
        'ProfilePhoto': request.profilePhotoPath != null
            ? await MultipartFile.fromFile(
                request.profilePhotoPath!,
                filename: 'profile.jpg',
              )
            : '',
        'Name': request.name,
        'Latitude': request.latitude,
        'Longitude': request.longitude,
        'RoleId': request.roleId.toString(),
        'Address': request.address,
        'PhoneNumber': request.phoneNumber,
        'IsSuperHost': request.isSuperHost.toString(),
        'Password': request.password,
        'Email': request.email,
      });

      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'X-Requested-With': 'XMLHttpRequest',
            'content-type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseModel = RegisterUserResponse.fromJson(response.data);
        if (responseModel.code == 200) {
          return responseModel;
        } else {
          throw ServerException(responseModel.message, responseModel.code);
        }
      } else {
        throw ServerException(
          'Register user failed with status code: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage =
            e.response?.data?['message'] ?? 'Registration failed';
        throw ServerException(errorMessage, e.response?.statusCode);
      } else {
        throw const NetworkException('Network connection error');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }
}
