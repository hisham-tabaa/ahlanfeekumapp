import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../data/models/change_password_request.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: AppColors.textPrimary,
          fontSize: ResponsiveUtils.fontSize(context, mobile: 18, tablet: 20, desktop: 22),
        ),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.changePasswordSuccess) {
            context.showSnackBar('Password changed successfully');
            Navigator.pop(context);
          }

          if (state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          return ResponsiveLayout(
            maxWidth: 600,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveUtils.spacing(context, mobile: 20, tablet: 24, desktop: 28)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 20, tablet: 22, desktop: 24)),

                  // Old Password Field
                  Text(
                    'Old Password',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 15, desktop: 16),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                  CustomTextField(
                    controller: _oldPasswordController,
                    hintText: 'Enter old password',
                    obscureText: !_showOldPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showOldPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _showOldPassword = !_showOldPassword;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 24, tablet: 28, desktop: 32)),

                  // New Password Field
                  Text(
                    'New Password',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 15, desktop: 16),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                  CustomTextField(
                    controller: _newPasswordController,
                    hintText: 'Enter new password',
                    obscureText: !_showNewPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _showNewPassword = !_showNewPassword;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 24, tablet: 28, desktop: 32)),

                  // Confirm Password Field
                  Text(
                    'Repeat New Password',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 15, desktop: 16),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Repeat new password',
                    obscureText: !_showConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 40, tablet: 44, desktop: 48)),

                  // Change Button
                  CustomButton(
                    text: 'Change',
                    isLoading: state.isChangingPassword,
                    onPressed: () {
                      if (_oldPasswordController.text.isEmpty) {
                        context.showSnackBar(
                          'Please enter old password',
                          isError: true,
                        );
                        return;
                      }

                      if (_newPasswordController.text.isEmpty) {
                        context.showSnackBar(
                          'Please enter new password',
                          isError: true,
                        );
                        return;
                      }

                      if (_newPasswordController.text !=
                          _confirmPasswordController.text) {
                        context.showSnackBar(
                          'New passwords do not match',
                          isError: true,
                        );
                        return;
                      }

                      if (_newPasswordController.text.length < 6) {
                        context.showSnackBar(
                          'Password must be at least 6 characters',
                          isError: true,
                        );
                        return;
                      }

                      final request = ChangePasswordRequest(
                        emailOrPhone:
                            state.profile?.email ??
                            state.profile?.phoneNumber ??
                            '',
                        oldPassword: _oldPasswordController.text,
                        newPassword: _newPasswordController.text,
                      );

                      context.read<ProfileBloc>().add(
                        ChangePasswordEvent(request),
                      );
                    },
                    backgroundColor: AppColors.primary,
                  ),

                  SizedBox(height: ResponsiveUtils.spacing(context, mobile: 40, tablet: 44, desktop: 48)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
