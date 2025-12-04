import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/file_upload_helper.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/otp_response.dart';
import '../models/otp_verification_response.dart';
import '../models/register_user_request.dart';
import '../models/register_user_response.dart';
import '../models/firebase_auth_request.dart';
import '../models/check_user_exist_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<LoginResponse> firebaseAuth(String idToken, {String? fcmToken});
  Future<OtpResponse> sendOtpEmail(String email);
  Future<OtpResponse> sendOtpPhone(String phone);
  Future<OtpVerificationResponse> verifyOtp(
    String emailOrPhone,
    String securityCode,
  );
  Future<OtpVerificationResponse> verifyPhone(
    String phone,
    String securityCode,
  );
  Future<OtpResponse> requestPasswordReset(String emailOrPhone);
  Future<OtpResponse> confirmPasswordReset(
    String emailOrPhone,
    String securityCode,
    String newPassword,
  );
  Future<RegisterUserResponse> registerUser(RegisterUserRequest request);
  Future<CheckUserExistResponse> checkUserExists(String phoneOrEmail);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.loginEndpoint}';
      final requestData = request.toJson();

      if (requestData['fcmToken'] != null) {
      }

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
  Future<LoginResponse> firebaseAuth(String idToken, {String? fcmToken}) async {
    try {
      final url = '${AppConstants.baseUrl}${AppConstants.firebaseAuthEndpoint}';
      final requestData = FirebaseAuthRequest(
        idToken: idToken,
        fcmToken: fcmToken,
      ).toJson();


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
        final loginResponse = LoginResponse.fromJson(response.data);
        return loginResponse;
      } else {
        throw ServerException(
          'Firebase auth failed with status code: ${response.statusCode}',
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
            e.response?.data?['message'] ?? 'Firebase auth failed';
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

      // Remove '+' symbol from phone number as backend expects digits only
      final cleanPhone = phone.replaceAll('+', '');

      // Call backend to generate OTP and send via WhatsApp (backend handles WhatsApp automatically)
      // Using 'email' parameter as specified in the API curl
      final url =
          '${AppConstants.baseUrl}${AppConstants.sendOtpPhoneEndpoint}?input=$cleanPhone';


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
  Future<OtpVerificationResponse> verifyPhone(
    String phone,
    String securityCode,
  ) async {
    try {

      // Remove '+' symbol from phone number as backend expects digits only
      final cleanPhone = phone.replaceAll('+', '');

      final url = '${AppConstants.baseUrl}${AppConstants.verifyPhoneEndpoint}';
      final requestData = {'phone': cleanPhone, 'securityCode': securityCode};


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
          'Verify phone failed with status code: ${response.statusCode}',
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
            e.response?.data?['message'] ?? 'Verify phone failed';
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

      // Use XFile if available (web compatible), otherwise fallback to path
      MultipartFile? profilePhoto;
      if (request.profilePhotoFile != null) {
        profilePhoto = await FileUploadHelper.createMultipartFile(
          request.profilePhotoFile!,
          filename: 'profile.jpg',
        );
      } else if (request.profilePhotoPath != null) {
        profilePhoto = await FileUploadHelper.createMultipartFileFromPath(
          request.profilePhotoPath,
          filename: 'profile.jpg',
        );
      }

      final formData = FormData.fromMap({
        'ProfilePhoto': profilePhoto ?? '',
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

  @override
  Future<CheckUserExistResponse> checkUserExists(String phoneOrEmail) async {
    try {
      final url =
          '${AppConstants.baseUrl}${AppConstants.checkUserExistEndpoint}?PhoneOrEmail=$phoneOrEmail';

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
        return CheckUserExistResponse.fromJson(response.data);
      } else {
        throw ServerException(
          'Check user exist failed with status code: ${response.statusCode}',
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
            e.response?.data?['message'] ?? 'Check user exist failed';
        throw ServerException(errorMessage, e.response?.statusCode);
      } else {
        throw const NetworkException('Unknown network error');
      }
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
