import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_result.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';
import '../models/register_user_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthResult>> login({
    required String phoneOrEmail,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {

        // Get FCM token for notifications
        String? fcmToken;
        try {
          fcmToken = await FCMService.getToken();
          if (fcmToken != null) {
          } else {
          }
        } catch (e) {
          // Continue with login even if FCM token fails
        }

        final request = LoginRequest(
          phoneOrEmail: phoneOrEmail,
          password: password,
          fcmToken: fcmToken,
        );


        final response = await remoteDataSource.login(request);

        if (response.code == 200 && response.data is LoginData) {
          final loginData = response.data as LoginData;
          // Create user from actual API response data
          final user = UserModel(
            id: loginData.userId ?? '1',
            email:
                loginData.email ??
                (phoneOrEmail.contains('@') ? phoneOrEmail : ''),
            name: loginData.name ?? 'User Name',
            phone:
                loginData.phone ??
                (!phoneOrEmail.contains('@') ? phoneOrEmail : null),
            isEmailVerified:
                true, // You might want to check this from API response
            isPhoneVerified:
                true, // You might want to check this from API response
            roleId: loginData.roleId, // Store roleId from login response
          );

          final authResult = AuthResult(
            user: user,
            accessToken: loginData.accessToken ?? '',
          );

          // Save user data locally
          await localDataSource.saveUserData(user);
          await localDataSource.saveTokens(loginData.accessToken ?? '', null);
          await localDataSource.setLoggedIn(true);

          return Right(authResult);
        } else {
          return Left(AuthFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure(ErrorHandler.getErrorMessage(e)));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtp({required String email}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.sendOtpEmail(email);

        if (response.code == 200) {
          return Right(response.data ?? 'OTP sent successfully');
        } else {
          return Left(ServerFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtpPhone({required String phone}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.sendOtpPhone(phone);
        if (response.code == 200) {
          return Right(response.data ?? 'OTP sent successfully');
        } else {
          return Left(ServerFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.verifyOtp(email, otp);

        if (response.code == 200 && response.data == true) {
          // OTP verification successful, but we need to perform a login to get a valid token
          // For now, we'll clear any existing tokens and require the user to login properly
          await localDataSource.clearUserData();

          // Return success but don't save invalid tokens
          final user = UserModel(
            id: '1', // We don't get userId from OTP verification
            email: email,
            name: 'User Name', // We don't get name from OTP verification
            isEmailVerified: true,
            isPhoneVerified: true,
          );

          final authResult = AuthResult(
            user: user,
            accessToken:
                '', // No token - user needs to login after OTP verification
          );

          // Don't save login state - user needs to login after OTP verification
          return Right(authResult);
        } else {
          return Left(AuthFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> verifyPhone({
    required String phone,
    required String otp,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.verifyPhone(phone, otp);


        if (response.code == 200 && response.data == true) {

          // Phone verification successful
          await localDataSource.clearUserData();

          // Return success - user needs to complete profile setup
          final user = UserModel(
            id: '0', // Temporary ID - will be assigned by backend after registration
            email: '', // Empty - phone registration doesn't require email
            phone: phone,
            name: 'User', // Temporary name - user will set in profile setup
            isEmailVerified: false,
            isPhoneVerified: true,
          );

          final authResult = AuthResult(
            user: user,
            accessToken: '', // No token - user needs to complete registration
          );

          // Don't save login state - user needs to complete registration
          return Right(authResult);
        } else {
          return Left(AuthFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUserData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Logout failed: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUserData();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to check login status: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> requestPasswordReset({
    required String emailOrPhone,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.requestPasswordReset(
          emailOrPhone,
        );

        if (response.code == 200) {
          return Right(response.message);
        } else {
          return Left(ServerFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Password reset request failed: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> confirmPasswordReset({
    required String emailOrPhone,
    required String securityCode,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.confirmPasswordReset(
          emailOrPhone,
          securityCode,
          newPassword,
        );

        if (response.code == 200) {
          // Password reset successful, but user needs to login with new password to get valid token
          await localDataSource.clearUserData();

          final user = UserModel(
            id: '1',
            email: emailOrPhone,
            name: 'User Name',
            profileImage: null,
            isEmailVerified: true,
            isPhoneVerified: false,
          );

          final authResult = AuthResult(
            user: user,
            accessToken: '', // No token - user needs to login with new password
          );

          // Don't save login state - user needs to login with new password
          return Right(authResult);
        } else {
          return Left(ServerFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Password reset failed: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> registerUser(
    RegisterUserRequest request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.registerUser(request);
        if (response.code == 200) {
          return Right(response.message);
        }
        return Left(ServerFailure(response.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Register user failed: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUserExists({
    required String phoneOrEmail,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.checkUserExists(phoneOrEmail);
        if (response.code == 200) {
          return Right(response.data); // Returns true if exists, false if not
        }
        return Left(ServerFailure(response.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Check user exist failed: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
