import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/text_styles.dart';
import '../../../../theming/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../cubit/registration_cubit.dart';
import '../../../../core/utils/validators.dart';
import 'login_screen.dart';

class SecureAccountScreen extends StatefulWidget {
  const SecureAccountScreen({super.key});

  @override
  State<SecureAccountScreen> createState() => _SecureAccountScreenState();
}

class _SecureAccountScreenState extends State<SecureAccountScreen> {
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegistrationCubit>();
    final passController = TextEditingController(text: cubit.state.password);
    final confirmController = TextEditingController(
      text: cubit.state.confirmPassword,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: BlocConsumer<RegistrationCubit, RegistrationState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          } else if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Account created successfully! Please login to continue.',
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
            // Navigate to login screen and clear all previous routes
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(context, mobile: 20, tablet: 24, desktop: 32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 12, desktop: 16)),

                // Error container
                if (state.error != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
                    ),
                    margin: EdgeInsets.only(
                      bottom: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(context, mobile: 8, tablet: 10, desktop: 12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: ResponsiveUtils.size(context, mobile: 20, tablet: 22, desktop: 24),
                        ),
                        SizedBox(width: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
                        Expanded(
                          child: Text(
                            state.error!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 15, desktop: 16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                Text(
                  'Secure Your Account',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveUtils.fontSize(context, mobile: 22, tablet: 24, desktop: 26),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 6, tablet: 8, desktop: 10)),
                Text(
                  'Create A Strong , Long And Hard Guessing Password',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 20, tablet: 24, desktop: 28)),

                // Password
                CustomTextField(
                  controller: passController,
                  labelText: 'Password',
                  hintText: 'Password',
                  obscureText: _obscure1,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure1
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscure1 = !_obscure1),
                  ),
                  validator: Validators.validatePassword,
                  onChanged: (value) {
                    cubit.setPassword(value);
                    cubit.clearError();
                  },
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 14, tablet: 16, desktop: 18)),

                // Confirm
                CustomTextField(
                  controller: confirmController,
                  labelText: 'Repeat Password',
                  hintText: 'Repeat Password',
                  obscureText: _obscure2,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure2
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscure2 = !_obscure2),
                  ),
                  onChanged: (value) {
                    cubit.setConfirmPassword(value);
                    cubit.clearError();
                  },
                ),

                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 40, tablet: 48, desktop: 56)),

                CustomButton(
                  text: state.isLoading ? 'Creating...' : 'Create Account',
                  backgroundColor: const Color(0xFFED1C24),
                  textColor: Colors.white,
                  onPressed: state.isLoading
                      ? null
                      : () {
                          context.read<RegistrationCubit>().submit();
                        },
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 20, tablet: 24, desktop: 28)),
              ],
            ),
          );
        },
      ),
    );
  }
}
