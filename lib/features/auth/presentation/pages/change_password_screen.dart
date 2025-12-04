import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;
  final String? securityCode; // Add security code parameter

  const ChangePasswordScreen({
    super.key,
    required this.email,
    this.securityCode,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  late final TextEditingController _securityCodeController;

  @override
  void initState() {
    super.initState();
    _securityCodeController = TextEditingController(
      text: widget.securityCode ?? '',
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _securityCodeController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        final securityCode = widget.securityCode != null
            ? _securityCodeController.text.trim()
            : null;

        if (widget.securityCode != null) {
          if (securityCode == null || securityCode.isEmpty) {
            context.showSnackBar(
              'enter_security_code'.tr(),
              isError: true,
            );
            return;
          }

          context.read<AuthBloc>().add(
            ConfirmPasswordResetEvent(
              emailOrPhone: widget.email,
              securityCode: securityCode,
              newPassword: _newPasswordController.text,
            ),
          );
        } else {
          context.read<AuthBloc>().add(
            ChangePasswordEvent(
              email: widget.email,
              newPassword: _newPasswordController.text,
            ),
          );
        }
      } else {
        context.showSnackBar('passwords_dont_match'.tr(), isError: true);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PasswordChanged) {
            context.showSnackBar('password_changed'.tr());
            // Navigate to login screen
            context.pop();
            context.pop(); // Pop twice to go back to login
          } else if (state is AuthError) {
            context.showSnackBar(state.message, isError: true);
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(context, mobile: 24, tablet: 32, desktop: 48),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 20, tablet: 24, desktop: 32)),

                    // Back Button
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: ResponsiveUtils.size(context, mobile: 24, tablet: 26, desktop: 28),
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 40, tablet: 48, desktop: 56)),

                    // Password Icon
                    Center(
                      child: Container(
                        width: ResponsiveUtils.size(context, mobile: 120, tablet: 140, desktop: 160),
                        height: ResponsiveUtils.size(context, mobile: 120, tablet: 140, desktop: 160),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.radius(context, mobile: 20, tablet: 24, desktop: 28),
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/password_54727411.svg',
                            width: ResponsiveUtils.size(context, mobile: 60, tablet: 70, desktop: 80),
                            height: ResponsiveUtils.size(context, mobile: 60, tablet: 70, desktop: 80),
                            color: Colors.white, // applies color filter
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 32, tablet: 40, desktop: 48)),

                    // Title
                    Center(
                      child: Text(
                        'change_password'.tr(),
                        style: AppTextStyles.h2.copyWith(
                          fontSize: ResponsiveUtils.fontSize(context, mobile: 24, tablet: 28, desktop: 32),
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 20, desktop: 24)),

                    // Subtitle
                    Center(
                      child: Text(
                        'change_password_subtitle'.tr(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 16, desktop: 18),
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 40, tablet: 48, desktop: 56)),

                    if (widget.securityCode != null) ...[
                      Text(
                        'security_code'.tr(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                      CustomTextField(
                        controller: _securityCodeController,
                        hintText: 'enter_4_digit_code'.tr(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (widget.securityCode != null) {
                            if (value == null || value.trim().isEmpty) {
                              return 'enter_security_code'.tr();
                            }
                            if (value.trim().length != 4) {
                              return 'security_code_must_4_digits'.tr();
                            }
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: ResponsiveUtils.spacing(context, mobile: 24, tablet: 28, desktop: 32)),
                    ],

                    // New Password Label
                    Text(
                      'new_password'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),

                    // New Password Field
                    CustomTextField(
                      controller: _newPasswordController,
                      hintText: 'password_hint'.tr(),
                      obscureText: _obscureNewPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'field_required'.tr();
                        }
                        if (value.length < 6) {
                          return 'password_too_short'.tr();
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 24, tablet: 28, desktop: 32)),

                    // Repeat Password Label
                    Text(
                      'repeat_new_password'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),

                    // Confirm Password Field
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: 'repeat_password'.tr(),
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'confirm_password_required'.tr();
                        }
                        if (value != _newPasswordController.text) {
                          return 'passwords_dont_match'.tr();
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 60, tablet: 70, desktop: 80)),

                    // Change Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'change'.tr(),
                          onPressed: _handleChangePassword,
                          isLoading: state is AuthLoading,
                          width: double.infinity,
                          backgroundColor: const Color(
                            0xFFED1C24,
                          ), // Red button
                        );
                      },
                    ),

                    SizedBox(height: ResponsiveUtils.spacing(context, mobile: 40, tablet: 48, desktop: 56)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
