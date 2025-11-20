import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          phoneOrEmail: _emailOrPhoneController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    final emailOrPhone = _emailOrPhoneController.text.trim();

    if (emailOrPhone.isEmpty) {
      context.showSnackBar(
        'Please enter your email or phone first',
        isError: true,
      );
      return;
    }

    context.read<AuthBloc>().add(
      PasswordResetRequestEvent(emailOrPhone: emailOrPhone),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.showSnackBar('login_success'.tr());
            // Navigate to home screen and clear all previous routes
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/main-navigation',
              (route) => false,
            );
          } else if (state is AuthError) {
            context.showSnackBar(state.message.tr(), isError: true);
          } else if (state is OtpSent) {
            context.showSnackBar('verification_sent'.tr());
            context.push(
              OtpVerificationScreen(
                email: state.email,
                otpCode: state.otpCode,
                isForgotPassword: true, // This is for forgot password flow
              ),
            );
          } else if (state is PasswordResetRequested) {
            context.showSnackBar(
              'Password reset code sent to ${state.emailOrPhone}',
            );
            context.push(
              OtpVerificationScreen(
                email: state.emailOrPhone,
                otpCode:
                    '', // We don't get the code from password reset request
                isForgotPassword: true,
              ),
            );
          }
        },
        child: ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isTablet(context)
            ? _buildDesktopLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bulding.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // Logo
        Positioned(
          top: ResponsiveUtils.size(context, mobile: 120, tablet: 140, desktop: 160),
          left: 0,
          right: 0,
          child: Center(
            child: Image.asset(
              'assets/icons/logo.png',
              width: ResponsiveUtils.size(context, mobile: 150, tablet: 180, desktop: 200),
              height: ResponsiveUtils.size(context, mobile: 82, tablet: 98, desktop: 110),
            ),
          ),
        ),

        // Gray curved underlay (second layer)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: LoginTopCurveClipper(),
            child: Container(
              height: ResponsiveUtils.size(context, mobile: 540, tablet: 580, desktop: 620),
              color: const Color(0xFFF2F3F6),
            ),
          ),
        ),

        // Curved white section with form (top layer)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: LoginTopCurveClipper(),
            child: Container(
              height: ResponsiveUtils.size(context, mobile: 520, tablet: 560, desktop: 600),
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveUtils.spacing(context, mobile: 24, tablet: 32, desktop: 40),
                  ResponsiveUtils.spacing(context, mobile: 60, tablet: 70, desktop: 80),
                  ResponsiveUtils.spacing(context, mobile: 24, tablet: 32, desktop: 40),
                  ResponsiveUtils.spacing(context, mobile: 40, tablet: 48, desktop: 56),
                ),
                child: _buildLoginForm(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return ResponsiveLayout(
      child: Row(
        children: [
          // Left side - Background image with logo
          Expanded(
            flex: ResponsiveUtils.isDesktop(context) ? 3 : 2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bulding.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Center(
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
                      SizedBox(
                        height: ResponsiveUtils.spacing(context,
                          mobile: 24,
                          tablet: 28,
                          desktop: 32,
                        ),
                      ),
                      Text(
                        'Welcome Back',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: ResponsiveUtils.fontSize(context,
                            mobile: 24,
                            tablet: 28,
                            desktop: 32,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(context,
                          mobile: 12,
                          tablet: 16,
                          desktop: 20,
                        ),
                      ),
                      Text(
                        'Sign in to access your account',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: ResponsiveUtils.fontSize(context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 18,
                          ),
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Right side - Login form
          Expanded(
            flex: ResponsiveUtils.isDesktop(context) ? 2 : 3,
            child: Container(
              color: Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.spacing(context,
                      mobile: 24,
                      tablet: 40,
                      desktop: 48,
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveUtils.size(context,
                        mobile: double.infinity,
                        tablet: 400,
                        desktop: 450,
                      ),
                    ),
                    child: _buildLoginForm(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Login',
            style: AppTextStyles.h2.copyWith(
              fontSize: ResponsiveUtils.fontSize(context,
                mobile: 28,
                tablet: 32,
                desktop: 36,
              ),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(
            height: ResponsiveUtils.spacing(context,
              mobile: 8,
              tablet: 12,
              desktop: 16,
            ),
          ),

          // Subtitle
          Text(
            'Please Put Your Credentials To Login To Your Account',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: ResponsiveUtils.fontSize(context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(
            height: ResponsiveUtils.spacing(context,
              mobile: 40,
              tablet: 48,
              desktop: 56,
            ),
          ),

          // Email or Phone Field
          CustomTextField(
            labelText: '',
            hintText: 'Email Or Phone Number',
            controller: _emailOrPhoneController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmailOrPhone,
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppColors.textSecondary,
              size: ResponsiveUtils.size(context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
            ),
          ),

          SizedBox(
            height: ResponsiveUtils.spacing(context,
              mobile: 24,
              tablet: 28,
              desktop: 32,
            ),
          ),

          // Password Field
          CustomTextField(
            labelText: '',
            hintText: 'Password',
            controller: _passwordController,
            obscureText: true,
            validator: Validators.validatePassword,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
              size: ResponsiveUtils.size(context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
            ),
          ),

          SizedBox(
            height: ResponsiveUtils.spacing(context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
          ),

          // Forgot Password
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: Text(
                'Forgot Password ?',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: ResponsiveUtils.fontSize(context,
                    mobile: 14,
                    tablet: 16,
                    desktop: 18,
                  ),
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          SizedBox(
            height: ResponsiveUtils.spacing(context,
              mobile: 32,
              tablet: 40,
              desktop: 48,
            ),
          ),

          // Login Button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return CustomButton(
                text: 'Login',
                onPressed: _handleLogin,
                isLoading: state is AuthLoading,
                width: double.infinity,
                backgroundColor: const Color(0xFFED1C24),
                textColor: Colors.white,
              );
            },
          ),

          SizedBox(
            height: ResponsiveUtils.spacing(context,
              mobile: 24,
              tablet: 28,
              desktop: 32,
            ),
          ),

          // Sign Up Link
          Center(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: ResponsiveUtils.fontSize(context,
                    mobile: 14,
                    tablet: 16,
                    desktop: 18,
                  ),
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(
                    text: "Don't Have An Account, ",
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to sign up screen
                      },
                      child: Text(
                        'Register',
                        style: AppTextStyles.bodyMedium
                            .copyWith(
                              fontSize: ResponsiveUtils.fontSize(context,
                                mobile: 14,
                                tablet: 16,
                                desktop: 18,
                              ),
                              color: const Color(0xFFED1C24),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginTopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // ارتفاع الانحناء يعتمد على ارتفاع الشاشة
    final double curveHeight = 0.08 * size.height; // 8% من ارتفاع الشاشة

    // البداية من أعلى يسار الشاشة
    path.moveTo(0, 0);

    // القوس للأعلى
    path.quadraticBezierTo(
      size.width / 2, // منتصف العرض
      curveHeight, // أعلى نقطة للقوس
      size.width, // نهاية القوس على اليمين
      0, // مستوى البداية
    );

    // إكمال المستطيل لتحت
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

@override
bool shouldReclip(CustomClipper<Path> oldClipper) => false;
