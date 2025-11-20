import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/registration_cubit.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/text_styles.dart';
import '../../../../theming/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/phone_field.dart';
import 'otp_verification_screen.dart';
import '../../../../core/di/injection.dart';
import '../../domain/usecases/send_otp_phone_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: ResponsiveUtils.isMobile(context) ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ) : null,
      backgroundColor: Colors.white,
      body: ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isTablet(context)
          ? _buildDesktopLayout(context)
          : _buildMobileLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(context, mobile: 20, tablet: 24, desktop: 32),
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return ResponsiveLayout(
      child: Row(
        children: [
          // Left side - Branding
          Expanded(
            flex: ResponsiveUtils.isDesktop(context) ? 2 : 1,
            child: Container(
              color: const Color(0xFFF8F9FA),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.spacing(context,
                      mobile: 24,
                      tablet: 40,
                      desktop: 48,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/logo.png',
                        width: ResponsiveUtils.size(context,
                          mobile: 150,
                          tablet: 200,
                          desktop: 250,
                        ),
                        height: ResponsiveUtils.size(context,
                          mobile: 82,
                          tablet: 110,
                          desktop: 135,
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Join Ahlan Feekum',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: ResponsiveUtils.fontSize(context,
                            mobile: 24,
                            tablet: 28,
                            desktop: 32,
                          ),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 20, desktop: 24)),
                      Text(
                        'Create your account to start your journey with us',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: ResponsiveUtils.fontSize(context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 18,
                          ),
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Right side - Form
          Expanded(
            flex: ResponsiveUtils.isDesktop(context) ? 3 : 2,
            child: Container(
              color: Colors.white,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.spacing(context,
                      mobile: 24,
                      tablet: 40,
                      desktop: 48,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Back button for desktop
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Form content
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveUtils.size(context,
                            mobile: double.infinity,
                            tablet: 400,
                            desktop: 450,
                          ),
                        ),
                        child: _buildContent(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ResponsiveUtils.isMobile(context))
          Center(
            child: Image.asset(
              'assets/icons/logo.png', 
              height: ResponsiveUtils.size(context, mobile: 64, tablet: 72, desktop: 80),
            ),
          ),
        
        if (ResponsiveUtils.isMobile(context))
          SizedBox(height: ResponsiveUtils.spacing(context, mobile: 12, tablet: 16, desktop: 20)),
        
        Text(
          'Create Account',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontSize: ResponsiveUtils.fontSize(context,
              mobile: 22,
              tablet: 26,
              desktop: 30,
            ),
            fontWeight: FontWeight.w700,
          ),
        ),
        
        SizedBox(height: ResponsiveUtils.spacing(context,
          mobile: 8,
          tablet: 12,
          desktop: 16,
        )),
        
        Text(
          'Type Your Phone Number To Continue',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: ResponsiveUtils.fontSize(context,
              mobile: 14,
              tablet: 16,
              desktop: 18,
            ),
          ),
        ),
        
        SizedBox(height: ResponsiveUtils.spacing(context,
          mobile: 20,
          tablet: 28,
          desktop: 32,
        )),

        // Phone input with country code picker
        PhoneField(hintText: 'Phone Number'),

        Padding(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.spacing(context,
              mobile: 20,
              tablet: 28,
              desktop: 32,
            ),
          ),
          child: Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
                ),
                child: Text(
                  'or',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtils.fontSize(context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
        ),

        CustomButton(
          text: 'Continue With Email Address',
          backgroundColor: Colors.grey[100],
          textColor: AppColors.textPrimary,
          height: ResponsiveUtils.size(context,
            mobile: 48,
            tablet: 52,
            desktop: 56,
          ),
          onPressed: () {
            _showEmailDialog(context);
          },
        ),

        SizedBox(height: ResponsiveUtils.spacing(context,
          mobile: 40,
          tablet: 48,
          desktop: 56,
        )),
        
        CustomButton(
          text: 'Next',
          backgroundColor: const Color(0xFFED1C24),
          textColor: Colors.white,
          height: ResponsiveUtils.size(context,
            mobile: 48,
            tablet: 52,
            desktop: 56,
          ),
          onPressed: () async {
            final cubit = context.read<RegistrationCubit>();
            final phone = cubit.state.phoneNumber.trim();
            final countryCode = cubit.state.countryCode;
            final fullPhoneNumber = '$countryCode$phone';

            if (phone.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter phone number')),
              );
              return;
            }
            try {
              // Set registration method to phone
              cubit.setRegistrationMethod(RegistrationMethod.phone);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sending OTP...')),
              );
              final result = await getIt<SendOtpPhoneUseCase>()(
                fullPhoneNumber,
              );
              result.fold(
                (failure) => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(failure.message))),
                (ok) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OtpVerificationScreen(
                        email: fullPhoneNumber,
                        otpCode: '',
                        isForgotPassword: false,
                        continueToProfile: true,
                        registrationCubit: cubit,
                      ),
                    ),
                  );
                },
              );
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to send OTP: $e')),
                );
              }
            }
          },
        ),
        
        SizedBox(height: ResponsiveUtils.spacing(context,
          mobile: 16,
          tablet: 20,
          desktop: 24,
        )),
        
        Center(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: ResponsiveUtils.fontSize(context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
              ),
              children: [
                const TextSpan(text: 'Already Have An Account , '),
                TextSpan(
                  text: 'Login',
                  style: const TextStyle(color: Color(0xFFED1C24)),
                  // navigation to login handled elsewhere if needed
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: ResponsiveUtils.spacing(context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        )),
      ],
    );
  }

  void _showEmailDialog(BuildContext context) {
    final controller = TextEditingController(
      text: context.read<RegistrationCubit>().state.email,
    );
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter Email'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'example@gmail.com'),
          onChanged: (v) => context.read<RegistrationCubit>().setEmail(v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final email = controller.text.trim();
              if (email.isEmpty) return;
              try {
                // Set registration method to email
                context.read<RegistrationCubit>().setRegistrationMethod(
                  RegistrationMethod.email,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Sending OTP...')));
                final result = await getIt<SendOtpUseCase>()(email: email);
                result.fold(
                  (failure) => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(failure.message))),
                  (ok) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OtpVerificationScreen(
                          email: email,
                          otpCode: '',
                          isForgotPassword: false,
                          continueToProfile: true,
                          registrationCubit: context.read<RegistrationCubit>(),
                        ),
                      ),
                    );
                  },
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to send OTP: $e')),
                  );
                }
              }
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
