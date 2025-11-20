import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/request_password_reset_usecase.dart';
import '../../domain/usecases/confirm_password_reset_usecase.dart';
import '../../data/datasources/auth_local_data_source.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../data/models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final RequestPasswordResetUseCase requestPasswordResetUseCase;
  final ConfirmPasswordResetUseCase confirmPasswordResetUseCase;
  final AuthLocalDataSource authLocalDataSource;

  AuthBloc({
    required this.loginUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.requestPasswordResetUseCase,
    required this.confirmPasswordResetUseCase,
    required this.authLocalDataSource,
  }) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LogoutEvent>(_onLogout);
    on<LogoutConfirmationEvent>(_onLogoutConfirmation);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<ContinueAsGuestEvent>(_onContinueAsGuest);
    on<ChangePasswordEvent>(_onChangePassword);
    on<PasswordResetRequestEvent>(_onPasswordResetRequest);
    on<ConfirmPasswordResetEvent>(_onConfirmPasswordReset);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      phoneOrEmail: event.phoneOrEmail,
      password: event.password,
    );

    await result.fold<Future<void>>(
      (failure) async {
        if (emit.isDone) return;
        emit(AuthError(message: failure.message));
      },
      (authResult) async {
        try {
          // Save tokens and user data to local storage
          await authLocalDataSource.saveTokens(
            authResult.accessToken,
            null, // Add refresh token if available
          );

          // Convert User entity to UserModel for storage
          final userModel = UserModel.fromEntity(authResult.user);
          await authLocalDataSource.saveUserData(userModel);
          await authLocalDataSource.setLoggedIn(true);
          // Clear guest status when user logs in
          await authLocalDataSource.setGuest(false);

          if (emit.isDone) return;
          emit(
            AuthAuthenticated(
              user: authResult.user,
              accessToken: authResult.accessToken,
            ),
          );
        } catch (e) {
          if (emit.isDone) return;
          emit(AuthError(message: 'Failed to save login data: $e'));
        }
      },
    );
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    final result = await sendOtpUseCase(email: event.email);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (otpCode) => emit(OtpSent(email: event.email, otpCode: otpCode)),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await verifyOtpUseCase(email: event.email, otp: event.otp);

    await result.fold<Future<void>>(
      (failure) async {
        if (emit.isDone) return;
        emit(AuthError(message: failure.message));
      },
      (authResult) async {
        try {
          // Save tokens and user data to local storage
          await authLocalDataSource.saveTokens(
            authResult.accessToken,
            null, // Add refresh token if available
          );

          // Convert User entity to UserModel for storage
          final userModel = UserModel.fromEntity(authResult.user);
          await authLocalDataSource.saveUserData(userModel);
          await authLocalDataSource.setLoggedIn(true);
          // Clear guest status when user logs in
          await authLocalDataSource.setGuest(false);

          if (emit.isDone) return;
          emit(
            AuthAuthenticated(
              user: authResult.user,
              accessToken: authResult.accessToken,
            ),
          );
        } catch (e) {
          if (emit.isDone) return;
          emit(AuthError(message: 'Failed to save login data: $e'));
        }
      },
    );
  }

  Future<void> _onLogoutConfirmation(
    LogoutConfirmationEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const LogoutConfirmationRequested());
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    try {
      // Clear all user data and tokens from local storage
      await authLocalDataSource.clearUserData();

      emit(const AuthUnauthenticated());
    } catch (e) {
      // Even if clearing fails, we should still log out the user
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Check if user is logged in from local storage
      final isLoggedIn = await authLocalDataSource.isLoggedIn();
      final isGuest = await authLocalDataSource.isGuest();
      final accessToken = await authLocalDataSource.getAccessToken();
      final userData = await authLocalDataSource.getUserData();

      if (isLoggedIn && accessToken != null && userData != null) {
        // User is authenticated, emit authenticated state
        emit(AuthAuthenticated(user: userData, accessToken: accessToken));
      } else if (isGuest) {
        // User is browsing as guest
        emit(const AuthGuest());
      } else {
        // User is not authenticated or guest
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      // If there's any error, assume user is not authenticated
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onContinueAsGuest(
    ContinueAsGuestEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Save guest status to SharedPreferences
      await authLocalDataSource.setGuest(true);
      // Clear any existing login status
      await authLocalDataSource.setLoggedIn(false);

      // Emit guest state
      emit(const AuthGuest());
    } catch (e) {
      // Even if saving fails, still allow guest access
      emit(const AuthGuest());
    }
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Use verifyOtpUseCase for change password (since we don't have a dedicated change password API yet)
      final result = await verifyOtpUseCase(
        email: event.email,
        otp: event.newPassword, // This is a workaround
      );

      result.fold(
        (failure) {
          emit(AuthError(message: failure.message));
        },
        (authResult) {
          emit(const PasswordChanged());
        },
      );
    } catch (e) {
      emit(AuthError(message: 'Change password failed: $e'));
    }
  }

  Future<void> _onPasswordResetRequest(
    PasswordResetRequestEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Call the correct password reset request API
      final result = await requestPasswordResetUseCase(
        emailOrPhone: event.emailOrPhone,
      );

      result.fold(
        (failure) {
          emit(AuthError(message: failure.message));
        },
        (message) {
          emit(PasswordResetRequested(emailOrPhone: event.emailOrPhone));
        },
      );
    } catch (e) {
      emit(AuthError(message: 'Password reset request failed: $e'));
    }
  }

  Future<void> _onConfirmPasswordReset(
    ConfirmPasswordResetEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Call the actual API through repository
      final result = await confirmPasswordResetUseCase(
        emailOrPhone: event.emailOrPhone,
        securityCode: event.securityCode,
        newPassword: event.newPassword,
      );

      result.fold(
        (failure) {
          emit(AuthError(message: failure.message));
        },
        (authResult) {
          emit(const PasswordChanged());
        },
      );
    } catch (e) {
      emit(AuthError(message: 'Password reset confirmation failed: $e'));
    }
  }
}
