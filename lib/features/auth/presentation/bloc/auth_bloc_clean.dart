import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/confirm_password_reset_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ConfirmPasswordResetUseCase confirmPasswordResetUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.confirmPasswordResetUseCase,
  }) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
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

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (authResult) => emit(
        AuthAuthenticated(
          user: authResult.user,
          accessToken: authResult.accessToken,
        ),
      ),
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

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (authResult) => emit(
        AuthAuthenticated(
          user: authResult.user,
          accessToken: authResult.accessToken,
        ),
      ),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    try {
      // await secureStorage.delete(key: 'access_token');
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // This would typically check if user is logged in from local storage
      // await secureStorage.read(key: 'access_token');
      // For now, assume user is not authenticated
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthUnauthenticated());
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
      // Call the actual API through repository
      final result = await sendOtpUseCase(email: event.emailOrPhone);

      result.fold(
        (failure) {
          emit(AuthError(message: failure.message));
        },
        (otpCode) {
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
