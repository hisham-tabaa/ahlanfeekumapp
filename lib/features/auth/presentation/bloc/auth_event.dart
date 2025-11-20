import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String phoneOrEmail;
  final String password;

  const LoginEvent({required this.phoneOrEmail, required this.password});

  @override
  List<Object> get props => [phoneOrEmail, password];
}

class SendOtpEvent extends AuthEvent {
  final String email;

  const SendOtpEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOtpEvent({required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class LogoutConfirmationEvent extends AuthEvent {
  const LogoutConfirmationEvent();
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class ContinueAsGuestEvent extends AuthEvent {
  const ContinueAsGuestEvent();
}

class ChangePasswordEvent extends AuthEvent {
  final String email;
  final String newPassword;

  const ChangePasswordEvent({required this.email, required this.newPassword});

  @override
  List<Object> get props => [email, newPassword];
}

class PasswordResetRequestEvent extends AuthEvent {
  final String emailOrPhone;

  const PasswordResetRequestEvent({required this.emailOrPhone});

  @override
  List<Object> get props => [emailOrPhone];
}

class ConfirmPasswordResetEvent extends AuthEvent {
  final String emailOrPhone;
  final String securityCode;
  final String newPassword;

  const ConfirmPasswordResetEvent({
    required this.emailOrPhone,
    required this.securityCode,
    required this.newPassword,
  });

  @override
  List<Object> get props => [emailOrPhone, securityCode, newPassword];
}
