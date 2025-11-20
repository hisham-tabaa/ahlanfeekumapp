import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../auth/presentation/widgets/custom_button.dart';
import '../../../auth/presentation/widgets/custom_text_field.dart';
import '../../data/models/change_password_request.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ChangePasswordSheet extends StatefulWidget {
  final String emailOrPhone;

  const ChangePasswordSheet({super.key, required this.emailOrPhone});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.changePasswordSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Password',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _oldPasswordController,
                hintText: 'Old Password',
                obscureText: true,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _newPasswordController,
                hintText: 'New Password',
                obscureText: true,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Repeat New Password',
                obscureText: true,
              ),
              SizedBox(height: 24.h),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  return CustomButton(
                    text: 'Change',
                    isLoading: state.isChangingPassword,
                    onPressed: () {
                      if (_newPasswordController.text !=
                          _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }

                      final request = ChangePasswordRequest(
                        emailOrPhone: widget.emailOrPhone,
                        oldPassword: _oldPasswordController.text,
                        newPassword: _newPasswordController.text,
                      );

                      context.read<ProfileBloc>().add(
                        ChangePasswordEvent(request),
                      );
                    },
                    backgroundColor: AppColors.primary,
                  );
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
