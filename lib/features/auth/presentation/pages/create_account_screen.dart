import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import '../cubit/registration_cubit.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/text_styles.dart';
import '../../../../theming/colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/phone_field.dart';
import 'otp_verification_screen.dart';
import 'login_screen.dart';
import '../../../../core/di/injection.dart';
import '../../domain/usecases/send_otp_phone_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/check_user_exists_usecase.dart';

enum SignupMethod { phone, email }

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  SignupMethod _selectedMethod = SignupMethod.phone;
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: ResponsiveUtils.isMobile(context)
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      backgroundColor: Colors.white,
      body: ResponsiveUtils.isDesktop(context) ||
              ResponsiveUtils.isTablet(context)
          ? _buildDesktopLayout(context)
          : _buildMobileLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing(context,
              mobile: 20, tablet: 24, desktop: 32),
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
                    ResponsiveUtils.spacing(
                      context,
                      mobile: 24,
                      tablet: 40,
                      desktop: 48,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/home_icon.png',
                        width: ResponsiveUtils.size(
                          context,
                          mobile: 150,
                          tablet: 200,
                          desktop: 250,
                        ),
                        height: ResponsiveUtils.size(
                          context,
                          mobile: 82,
                          tablet: 110,
                          desktop: 135,
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Join Ahlan Feekum',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 24,
                            tablet: 28,
                            desktop: 32,
                          ),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                          height: ResponsiveUtils.spacing(context,
                              mobile: 16, tablet: 20, desktop: 24)),
                      Text(
                        'Create your account to start your journey with us',
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
                    ResponsiveUtils.spacing(
                      context,
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
                          maxWidth: ResponsiveUtils.size(
                            context,
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
              'assets/images/home_icon.png',
              height: ResponsiveUtils.size(context,
                  mobile: 64, tablet: 72, desktop: 80),
            ),
          ),

        if (ResponsiveUtils.isMobile(context))
          SizedBox(
              height: ResponsiveUtils.spacing(context,
                  mobile: 12, tablet: 16, desktop: 20)),

        Text(
          'Create Account',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontSize: ResponsiveUtils.fontSize(
              context,
              mobile: 22,
              tablet: 26,
              desktop: 30,
            ),
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(
            height: ResponsiveUtils.spacing(
          context,
          mobile: 8,
          tablet: 12,
          desktop: 16,
        )),

        Text(
          'Choose your signup method',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: ResponsiveUtils.fontSize(
              context,
              mobile: 14,
              tablet: 16,
              desktop: 18,
            ),
          ),
        ),

        SizedBox(
            height: ResponsiveUtils.spacing(
          context,
          mobile: 20,
          tablet: 28,
          desktop: 32,
        )),

        // Method selection toggle
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(context, mobile: 10, tablet: 12, desktop: 14),
            ),
          ),
          padding: EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMethod = SignupMethod.phone;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveUtils.spacing(context,
                          mobile: 12, tablet: 14, desktop: 16),
                    ),
                    decoration: BoxDecoration(
                      color: _selectedMethod == SignupMethod.phone
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(context,
                            mobile: 8, tablet: 10, desktop: 12),
                      ),
                      boxShadow: _selectedMethod == SignupMethod.phone
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Text(
                      'Phone',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _selectedMethod == SignupMethod.phone
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: _selectedMethod == SignupMethod.phone
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMethod = SignupMethod.email;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveUtils.spacing(context,
                          mobile: 12, tablet: 14, desktop: 16),
                    ),
                    decoration: BoxDecoration(
                      color: _selectedMethod == SignupMethod.email
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(context,
                            mobile: 8, tablet: 10, desktop: 12),
                      ),
                      boxShadow: _selectedMethod == SignupMethod.email
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Text(
                      'Email',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _selectedMethod == SignupMethod.email
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: _selectedMethod == SignupMethod.email
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
            height: ResponsiveUtils.spacing(
          context,
          mobile: 24,
          tablet: 28,
          desktop: 32,
        )),

        // Input field based on selection
        if (_selectedMethod == SignupMethod.phone) ...[
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: PhoneField(hintText: 'Phone Number'),
          ),
          SizedBox(height: 8),
          Text(
            'enter_phone_country_code'.tr(),
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: ResponsiveUtils.fontSize(context,
                  mobile: 12, tablet: 13, desktop: 14),
              color: AppColors.textSecondary,
            ),
          ),
        ] else ...[
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: CustomTextField(
              hintText: 'email_address'.tr(),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppColors.textSecondary,
                size: ResponsiveUtils.size(context,
                    mobile: 20, tablet: 22, desktop: 24),
              ),
              onChanged: (value) {
                context.read<RegistrationCubit>().setEmail(value);
              },
            ),
          ),
        ],

        SizedBox(
            height: ResponsiveUtils.spacing(
          context,
          mobile: 40,
          tablet: 48,
          desktop: 56,
        )),

        CustomButton(
          text: 'next'.tr(),
          backgroundColor: const Color(0xFFED1C24),
          textColor: Colors.white,
          height: ResponsiveUtils.size(
            context,
            mobile: 48,
            tablet: 52,
            desktop: 56,
          ),
          onPressed: () => _handleNext(context),
        ),

        SizedBox(
            height: ResponsiveUtils.spacing(
          context,
          mobile: 16,
          tablet: 20,
          desktop: 24,
        )),

        Center(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
              ),
              children: [
                TextSpan(text: 'already_have_account'.tr()),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'login_title'.tr(),
                      style: TextStyle(
                        color: const Color(0xFFED1C24),
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(
            height: ResponsiveUtils.spacing(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        )),
      ],
    );
  }

  Future<void> _handleNext(BuildContext context) async {
    final cubit = context.read<RegistrationCubit>();
    
    if (_selectedMethod == SignupMethod.phone) {
      final phone = cubit.state.phoneNumber.trim();
      final countryCode = cubit.state.countryCode;
      final fullPhoneNumber = '$countryCode$phone';

      if (phone.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('enter_phone_number_first'.tr())),
        );
        return;
      }

      try {
        // First, check if user already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('checking_phone_number'.tr())),
        );

        final checkResult =
            await getIt<CheckUserExistsUseCase>()(fullPhoneNumber);

        await checkResult.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message.tr())),
            );
          },
          (userExists) async {
            if (userExists) {
              // User already exists, redirect to login
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'phone_already_registered'.tr(),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                
                // Wait a moment then redirect to login
                await Future.delayed(const Duration(seconds: 2));
                
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                }
              }
            } else {
              // User doesn't exist, proceed with OTP
              cubit.setRegistrationMethod(RegistrationMethod.phone);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('sending_otp'.tr())),
                );
              }

              final result = await getIt<SendOtpPhoneUseCase>()(
                fullPhoneNumber,
              );

              result.fold(
                (failure) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(failure.message.tr())),
                    );
                  }
                },
                (ok) {
                  if (context.mounted) {
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
                  }
                },
              );
            }
          },
        );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('generic_failed_with_error'.tr(args: ['$e']))),
          );
        }
      }
    } else {
      // Email signup
      final email = _emailController.text.trim();
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('enter_your_email'.tr())),
        );
        return;
      }

      try {
        // First, check if user already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('checking_email'.tr())),
        );

        final checkResult = await getIt<CheckUserExistsUseCase>()(email);

        await checkResult.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message.tr())),
            );
          },
          (userExists) async {
            if (userExists) {
              // User already exists, redirect to login
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'email_already_registered'.tr(),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                
                // Wait a moment then redirect to login
                await Future.delayed(const Duration(seconds: 2));
                
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                }
              }
            } else {
              // User doesn't exist, proceed with OTP
              cubit.setRegistrationMethod(RegistrationMethod.email);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('sending_otp'.tr())),
                );
              }

              final result = await getIt<SendOtpUseCase>()(email: email);
              result.fold(
                (failure) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(failure.message.tr())),
                    );
                  }
                },
                (ok) {
                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OtpVerificationScreen(
                          email: email,
                          otpCode: '',
                          isForgotPassword: false,
                          continueToProfile: true,
                          registrationCubit: cubit,
                        ),
                      ),
                    );
                  }
                },
              );
            }
          },
        );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('generic_failed_with_error'.tr(args: ['$e']))),
          );
        }
      }
    }
  }
}
