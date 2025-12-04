import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/auth_result.dart';
import '../../data/models/register_user_request.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> login({
    required String phoneOrEmail,
    required String password,
  });

  Future<Either<Failure, String>> sendOtp({required String email});
  Future<Either<Failure, String>> sendOtpPhone({required String phone});

  Future<Either<Failure, AuthResult>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<Failure, AuthResult>> verifyPhone({
    required String phone,
    required String otp,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<Failure, String>> requestPasswordReset({
    required String emailOrPhone,
  });

  Future<Either<Failure, AuthResult>> confirmPasswordReset({
    required String emailOrPhone,
    required String securityCode,
    required String newPassword,
  });

  Future<Either<Failure, String>> registerUser(RegisterUserRequest request);
  
  Future<Either<Failure, bool>> checkUserExists({required String phoneOrEmail});
}
