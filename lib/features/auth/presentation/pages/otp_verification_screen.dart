import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:ui' as ui;

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'change_password_screen.dart';
import 'set_profile_screen.dart';
import '../cubit/registration_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../domain/usecases/verify_phone_usecase.dart';
import '../../domain/usecases/send_otp_phone_usecase.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String otpCode;
  final bool isForgotPassword; // true = forgot password flow, false = login OTP
  final bool continueToProfile; // registration flow control
  final RegistrationCubit? registrationCubit; // For registration flow

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.otpCode,
    this.isForgotPassword = false,
    this.continueToProfile = false,
    this.registrationCubit,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  Timer? _timer;
  int _remainingTime = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _handleVerifyOtp() async {
    if (_otpController.text.length == 4) {
      if (widget.isForgotPassword) {
        // For forgot password, we don't verify OTP here - just navigate to change password
        // The actual verification happens when confirming password reset
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(
              email: widget.email,
              securityCode: _otpController.text,
            ),
          ),
        );
      } else {
        // Check if it's a phone number (doesn't contain @)
        final isPhone = !widget.email.contains('@');

        if (isPhone) {
          // Phone verification

          try {
            context.showSnackBar('verifying_phone_number'.tr());

            final result = await getIt<VerifyPhoneUseCase>()(
              phone: widget.email,
              otp: _otpController.text,
            );

            result.fold(
              (failure) {
                context.showSnackBar(failure.message, isError: true);
              },
              (authResult) {
                context.showSnackBar('verification_success'.tr());

                if (widget.continueToProfile) {
                  // Registration flow - go to profile setup
                  final cubit =
                      widget.registrationCubit ?? getIt<RegistrationCubit>();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider<RegistrationCubit>.value(
                        value: cubit,
                        child: const SetProfileScreen(),
                      ),
                    ),
                  );
                } else {
                  // Login flow - navigate to home
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main-navigation',
                    (route) => false,
                  );
                }
              },
            );
          } catch (e) {
            context.showSnackBar('Verification failed: $e', isError: true);
          }
        } else {
          // Email verification (existing flow)
          context.read<AuthBloc>().add(
            VerifyOtpEvent(email: widget.email, otp: _otpController.text),
          );
        }
      }
      } else {
        context.showSnackBar(
          'enter_complete_otp'.tr(),
          isError: true,
        );
      }
  }

  void _handleResendOtp() async {
    if (_canResend) {
      final isPhone = !widget.email.contains('@');

      if (isPhone) {
        // Resend phone OTP

        try {
          context.showSnackBar('resending_otp'.tr());

          final result = await getIt<SendOtpPhoneUseCase>()(widget.email);

          result.fold(
            (failure) {
              context.showSnackBar(failure.message.tr(), isError: true);
            },
            (message) {
              context.showSnackBar('otp_sent_success'.tr());
              _startTimer();
            },
          );
        } catch (e) {
          context.showSnackBar('resend_otp_failed'.tr(args: ['$e']), isError: true);
        }
      } else {
        // Resend email OTP (existing flow)
        context.read<AuthBloc>().add(SendOtpEvent(email: widget.email));
        _startTimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinSize = ResponsiveUtils.size(
      context,
      mobile: 56,
      tablet: 64,
      desktop: 72,
    );

    final defaultPinTheme = PinTheme(
      width: pinSize,
      height: pinSize,
      textStyle: AppTextStyles.h4.copyWith(
        fontSize: ResponsiveUtils.fontSize(
          context,
          mobile: 20,
          tablet: 22,
          desktop: 24,
        ),
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 12, tablet: 14, desktop: 16),
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.primary),
      ),
    );

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerified || state is AuthAuthenticated) {
            context.showSnackBar('verification_success'.tr());
            if (widget.continueToProfile) {
              // Registration flow - go directly to profile setup
              // Missing field will be handled within SetProfileScreen
              final cubit =
                  widget.registrationCubit ?? getIt<RegistrationCubit>();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<RegistrationCubit>.value(
                    value: cubit,
                    child: const SetProfileScreen(),
                  ),
                ),
              );
            } else if (!widget.isForgotPassword) {
              // Normal login flow - navigate to home and clear all previous routes
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/main-navigation',
                (route) => false,
              );
            }
            // For forgot password, navigation is handled in _handleVerifyOtp
          } else if (state is AuthError) {
            context.showSnackBar(state.message.tr(), isError: true);
          } else if (state is OtpSent) {
            context.showSnackBar('verification_sent'.tr());
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white, // White background to match image
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 32,
                  desktop: 48,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 20,
                      tablet: 24,
                      desktop: 32,
                    ),
                  ),

                  // Back Button
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: ResponsiveUtils.size(
                        context,
                        mobile: 24,
                        tablet: 26,
                        desktop: 28,
                      ),
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 40,
                      tablet: 48,
                      desktop: 56,
                    ),
                  ),

                  // Shield Icon (different for email vs phone/WhatsApp)
                  Center(
                    child: Container(
                      width: ResponsiveUtils.size(
                        context,
                        mobile: 120,
                        tablet: 140,
                        desktop: 160,
                      ),
                      height: ResponsiveUtils.size(
                        context,
                        mobile: 120,
                        tablet: 140,
                        desktop: 160,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.radius(
                            context,
                            mobile: 20,
                            tablet: 24,
                            desktop: 28,
                          ),
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          // Use different image based on authentication method
                          widget.email.contains('@')
                              ? 'assets/images/security_5797697 1.svg' // Email
                              : 'assets/images/security_5797697 2.svg', // WhatsApp/Phone
                          width: ResponsiveUtils.size(
                            context,
                            mobile: 107,
                            tablet: 125,
                            desktop: 143,
                          ),
                          height: ResponsiveUtils.size(
                            context,
                            mobile: 100,
                            tablet: 117,
                            desktop: 133,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 32,
                      tablet: 40,
                      desktop: 48,
                    ),
                  ),

                  // Title (dynamic based on authentication method)
                  Center(
                    child: Text(
                      widget.email.contains('@')
                          ? 'verify_through_email'.tr()
                          : 'verify_through_whatsapp'.tr(),
                      style: AppTextStyles.h2.copyWith(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          mobile: 24,
                          tablet: 28,
                          desktop: 32,
                        ),
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
                    ),
                  ),

                  // Subtitle (dynamic based on authentication method)
                  Center(
                    child: Text(
                      widget.email.contains('@')
                          ? 'otp_sent_email'.tr(args: [
                              widget.email.replaceAll(
                                RegExp(r'(?<=.{3}).(?=.*@)'),
                                '*',
                              ),
                            ])
                          : 'otp_sent_whatsapp'.tr(args: [widget.email]),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        ),
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 40,
                      tablet: 48,
                      desktop: 56,
                    ),
                  ),

                  // OTP Input
                  Center(
                    child: Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: Pinput(
                        controller: _otpController,
                        length: 4, // Changed to 4 digits
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        showCursor: true,
                        onCompleted: (pin) => _handleVerifyOtp(),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 32,
                      tablet: 40,
                      desktop: 48,
                    ),
                  ),

                  // Timer and Resend
                  Center(
                    child: Column(
                      children: [
                        if (!_canResend) ...[
                          Text(
                            'otp_seconds_left'
                                .tr(args: ['$_remainingTime']),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                mobile: 14,
                                tablet: 16,
                                desktop: 18,
                              ),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ] else ...[
                          TextButton(
                            onPressed: _handleResendOtp,
                            child: Text(
                              'resend_otp_button'.tr(),
                              style: AppTextStyles.linkText.copyWith(
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 16,
                                  tablet: 18,
                                  desktop: 20,
                                ),
                                color: const Color(0xFFED1C24), // Red color
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 32,
                      tablet: 40,
                      desktop: 48,
                    ),
                  ),

                  // Verify Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'verify'.tr(),
                        onPressed: _handleVerifyOtp,
                        isLoading: state is AuthLoading,
                        width: double.infinity,
                        backgroundColor: const Color(0xFFED1C24), // Red button
                      );
                    },
                  ),

                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 40,
                      tablet: 48,
                      desktop: 56,
                    ),
                  ),

                  // Debug info (remove in production)
                  if (widget.otpCode.isNotEmpty) ...[
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(
                          ResponsiveUtils.spacing(
                            context,
                            mobile: 16,
                            tablet: 20,
                            desktop: 24,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 8,
                              tablet: 10,
                              desktop: 12,
                            ),
                          ),
                          border: Border.all(
                            color: AppColors.info.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
