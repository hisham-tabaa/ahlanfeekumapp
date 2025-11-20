import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;
  final String accessToken;

  const AuthAuthenticated({required this.user, required this.accessToken});

  @override
  List<Object> get props => [user, accessToken];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthGuest extends AuthState {
  const AuthGuest();
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class OtpSent extends AuthState {
  final String email;
  final String otpCode;

  const OtpSent({required this.email, required this.otpCode});

  @override
  List<Object> get props => [email, otpCode];
}

class OtpVerified extends AuthState {
  final User user;
  final String accessToken;

  const OtpVerified({required this.user, required this.accessToken});

  @override
  List<Object> get props => [user, accessToken];
}

class PasswordChanged extends AuthState {
  const PasswordChanged();
}

class PasswordResetRequested extends AuthState {
  final String emailOrPhone;

  const PasswordResetRequested({required this.emailOrPhone});

  @override
  List<Object> get props => [emailOrPhone];
}

class LogoutConfirmationRequested extends AuthState {
  const LogoutConfirmationRequested();
}
