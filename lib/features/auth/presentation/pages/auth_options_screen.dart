import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'login_screen.dart';
import 'choose_account_screen.dart';

class AuthOptionsScreen extends StatelessWidget {
  const AuthOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to home screen
            context.showSnackBar('login_success'.tr());
          } else if (state is AuthError) {
            context.showSnackBar(state.message.tr(), isError: true);
          }
        },
        child: ResponsiveUtils.isDesktop(context)
            ? _buildDesktopLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ResponsiveLayout(
      maxWidth: ResponsiveUtils.isWeb ? 400 : null,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/images/DarkBG.png', fit: BoxFit.cover),
          ),

          // Rectangle at top
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
              ),
              child: Image.asset(
                'assets/icons/Rectangle.png',
                width: ResponsiveUtils.size(
                  context,
                  mobile: 60,
                  tablet: 70,
                  desktop: 80,
                ),
                height: ResponsiveUtils.size(
                  context,
                  mobile: 6,
                  tablet: 7,
                  desktop: 8,
                ),
              ),
            ),
          ),

          // Logo above modal
          Align(
            alignment: Alignment(0, -0.4), // طلّع اللوجو شوي لفوق
            child: Image.asset(
              'assets/icons/logo.png',
              width: ResponsiveUtils.size(
                context,
                mobile: 180,
                tablet: 210,
                desktop: 240,
              ), // كبّر الحجم مثل ما بالصورة
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.business,
                size: ResponsiveUtils.size(
                  context,
                  mobile: 100,
                  tablet: 120,
                  desktop: 140,
                ),
                color: Colors.grey,
              ),
            ),
          ),

          // Modal dialog
          Align(
            alignment: Alignment(0, 0.8),
            child: _buildOriginalAuthModal(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return ResponsiveLayout(
      child: Row(
        children: [
          // Left side - Background image with logo (similar to login)
          Expanded(
            flex: ResponsiveUtils.isDesktop(context) ? 2 : 2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/DarkBG.png'),
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
                      // Logo with enhanced styling
                      Container(
                        padding: EdgeInsets.all(
                          ResponsiveUtils.spacing(
                            context,
                            mobile: 16,
                            tablet: 20,
                            desktop: 24,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 20,
                              tablet: 22,
                              desktop: 24,
                            ),
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          'assets/icons/logo.png',
                          width: ResponsiveUtils.size(
                            context,
                            mobile: 120,
                            tablet: 160,
                            desktop: 200,
                          ),
                          height: ResponsiveUtils.size(
                            context,
                            mobile: 65,
                            tablet: 85,
                            desktop: 110,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          mobile: 32,
                          tablet: 36,
                          desktop: 40,
                        ),
                      ),

                      Text(
                        'Welcome to Ahlan Feekum',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: ResponsiveUtils.responsive(
                            context,
                            mobile: 26,
                            tablet: 30,
                            desktop: 34,
                          ),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.spacing(
                            context,
                            mobile: 24,
                            tablet: 28,
                            desktop: 32,
                          ),
                          vertical: ResponsiveUtils.spacing(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 16,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 25,
                              tablet: 28,
                              desktop: 30,
                            ),
                          ),
                        ),
                        child: Text(
                          'Get started with your rental journey',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: ResponsiveUtils.responsive(
                              context,
                              mobile: 15,
                              tablet: 17,
                              desktop: 19,
                            ),
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Right side - Auth options form (similar to login)
          Expanded(
            flex: ResponsiveUtils.isDesktop(context) ? 3 : 3,
            child: Container(
              color: Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.spacing(
                      context,
                      mobile: 24,
                      tablet: 32,
                      desktop: 40,
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveUtils.responsive(
                        context,
                        mobile: double.infinity,
                        tablet: 600,
                        desktop: 750,
                      ),
                    ),
                    child: _buildAuthModal(context, isDesktop: true),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthModal(BuildContext context, {bool isDesktop = false}) {
    final isLargeScreen =
        ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isTablet(context);

    return Container(
      width: double.infinity,
      margin: isDesktop
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
            ),
      decoration: isDesktop
          ? null
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.radius(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 28,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: ResponsiveUtils.responsive(
                    context,
                    mobile: 10,
                    tablet: 20,
                    desktop: 30,
                  ),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
      child: Stack(
        children: [
          // Star icon in circle
          if (!isDesktop)
            Positioned(
              top: -16,
              left: 16,
              child: Container(
                width: ResponsiveUtils.size(
                  context,
                  mobile: 80,
                  tablet: 90,
                  desktop: 100,
                ),
                height: ResponsiveUtils.size(
                  context,
                  mobile: 80,
                  tablet: 90,
                  desktop: 100,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/start.png',
                    width: ResponsiveUtils.size(
                      context,
                      mobile: 44,
                      tablet: 50,
                      desktop: 56,
                    ),
                    height: ResponsiveUtils.size(
                      context,
                      mobile: 45,
                      tablet: 51,
                      desktop: 57,
                    ),
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.star,
                      size: ResponsiveUtils.size(
                        context,
                        mobile: 32,
                        tablet: 36,
                        desktop: 40,
                      ),
                      color: Colors.amber[900],
                    ),
                  ),
                ),
              ),
            ),

          // Close button (only for mobile)
          if (!isDesktop)
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.close,
                  size: ResponsiveUtils.size(
                    context,
                    mobile: 24,
                    tablet: 26,
                    desktop: 28,
                  ),
                  color: Colors.grey,
                ),
              ),
            ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 32,
                desktop: 40,
              ),
              ResponsiveUtils.spacing(
                context,
                mobile: 48,
                tablet: 32,
                desktop: 40,
              ),
              ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 32,
                desktop: 40,
              ),
              ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 32,
                desktop: 40,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    vertical: ResponsiveUtils.spacing(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFED1C24).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.radius(
                        context,
                        mobile: 20,
                        tablet: 22,
                        desktop: 24,
                      ),
                    ),
                    border: Border.all(
                      color: const Color(0xFFED1C24).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color(0xFFED1C24),
                        size: ResponsiveUtils.responsive(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveUtils.spacing(
                          context,
                          mobile: 8,
                          tablet: 10,
                          desktop: 12,
                        ),
                      ),
                      Text(
                        'Welcome',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: ResponsiveUtils.responsive(
                            context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 18,
                          ),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFED1C24),
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
                  ),
                ),

                // Title
                Text(
                  'Get Started',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: ResponsiveUtils.responsive(
                      context,
                      mobile: 28,
                      tablet: 32,
                      desktop: 36,
                    ),
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 12,
                    tablet: 16,
                    desktop: 20,
                  ),
                ),

                // Subtitle
                Text(
                  'Begin your journey with Syria\'s most trusted rental platform. Join thousands of satisfied users.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: ResponsiveUtils.responsive(
                      context,
                      mobile: 15,
                      tablet: 17,
                      desktop: 19,
                    ),
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 24,
                    tablet: 32,
                    desktop: 40,
                  ),
                ),

                // Register Button with enhanced styling
                Container(
                  width: double.infinity,
                  height: ResponsiveUtils.size(
                    context,
                    mobile: 52,
                    tablet: 56,
                    desktop: 60,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFED1C24), Color(0xFFD91825)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.radius(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFED1C24).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ChooseAccountScreen(),
                          ),
                        );
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_add,
                              color: Colors.white,
                              size: ResponsiveUtils.responsive(
                                context,
                                mobile: 20,
                                tablet: 22,
                                desktop: 24,
                              ),
                            ),
                            SizedBox(
                              width: ResponsiveUtils.spacing(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                            Text(
                              'Create Account',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: ResponsiveUtils.responsive(
                                  context,
                                  mobile: 16,
                                  tablet: 18,
                                  desktop: 20,
                                ),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

                // Login and Google buttons
                isLargeScreen
                    ? Column(
                        children: [
                          // Login Button
                          Container(
                            width: double.infinity,
                            height: ResponsiveUtils.size(
                              context,
                              mobile: 52,
                              tablet: 56,
                              desktop: 60,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.radius(
                                  context,
                                  mobile: 16,
                                  tablet: 18,
                                  desktop: 20,
                                ),
                              ),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1.5,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveUtils.radius(
                                    context,
                                    mobile: 16,
                                    tablet: 18,
                                    desktop: 20,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.login,
                                        color: AppColors.textPrimary,
                                        size: ResponsiveUtils.responsive(
                                          context,
                                          mobile: 20,
                                          tablet: 22,
                                          desktop: 24,
                                        ),
                                      ),
                                      SizedBox(
                                        width: ResponsiveUtils.spacing(
                                          context,
                                          mobile: 12,
                                          tablet: 14,
                                          desktop: 16,
                                        ),
                                      ),
                                      Text(
                                        'Sign In',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              fontSize:
                                                  ResponsiveUtils.responsive(
                                                    context,
                                                    mobile: 16,
                                                    tablet: 18,
                                                    desktop: 20,
                                                  ),
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : CustomButton(
                        height: ResponsiveUtils.size(
                          context,
                          mobile: 48,
                          tablet: 52,
                          desktop: 56,
                        ),
                        text: 'Login',
                        textStyle: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Lato',
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        backgroundColor: Colors.grey[100],
                      ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 20,
                    desktop: 24,
                  ),
                ),

                // Terms text with enhanced styling
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.radius(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: ResponsiveUtils.responsive(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(
                          text: 'By continuing, you agree to Ahlan Feekum\'s ',
                        ),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: const Color(0xFFED1C24),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to Terms screen
                              Navigator.pushNamed(context, '/terms');
                            },
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: const Color(0xFFED1C24),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to Terms screen (privacy policy section)
                              Navigator.pushNamed(context, '/terms');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginalAuthModal(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: ResponsiveUtils.isWeb ? 400 : double.infinity,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(
          context,
          mobile: 24,
          tablet: 28,
          desktop: 32,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 20, tablet: 22, desktop: 24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Star icon in circle
          Positioned(
            top: -16,
            left: 16,
            child: Container(
              width: ResponsiveUtils.size(
                context,
                mobile: 80,
                tablet: 90,
                desktop: 100,
              ),
              height: ResponsiveUtils.size(
                context,
                mobile: 80,
                tablet: 90,
                desktop: 100,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/start.png',
                  width: ResponsiveUtils.size(
                    context,
                    mobile: 44,
                    tablet: 50,
                    desktop: 56,
                  ),
                  height: ResponsiveUtils.size(
                    context,
                    mobile: 45,
                    tablet: 51,
                    desktop: 57,
                  ),
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.star,
                    size: ResponsiveUtils.size(
                      context,
                      mobile: 32,
                      tablet: 36,
                      desktop: 40,
                    ),
                    color: Colors.amber[900],
                  ),
                ),
              ),
            ),
          ),

          // Close button
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.close,
                size: ResponsiveUtils.size(
                  context,
                  mobile: 24,
                  tablet: 26,
                  desktop: 28,
                ),
                color: Colors.grey,
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
              ResponsiveUtils.spacing(
                context,
                mobile: 48,
                tablet: 52,
                desktop: 56,
              ),
              ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
              ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Get Started',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 20,
                      tablet: 22,
                      desktop: 24,
                    ),
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),

                // Subtitle
                Text(
                  'Get Started And Begin Your Journey In Our Fabulous Renting App',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 12,
                      tablet: 14,
                      desktop: 16,
                    ),
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                ),

                // Register Button
                CustomButton(
                  text: 'Register',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ChooseAccountScreen(),
                      ),
                    );
                  },
                  width: double.infinity,
                  backgroundColor: const Color(0xFFED1C24),
                  textColor: Colors.white,
                ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                ),
                CustomButton(
                  height: ResponsiveUtils.size(
                    context,
                    mobile: 48,
                    tablet: 52,
                    desktop: 56,
                  ),
                  text: 'Login',
                  textStyle: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lato',
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  backgroundColor: Colors.grey[100],
                ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                ),

                // Terms text
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          mobile: 10,
                          tablet: 12,
                          desktop: 14,
                        ),
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(
                          text: 'By Continuing, You Agree To Ahlan Feekm ',
                        ),
                        TextSpan(
                          text: 'Terms Of Use',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to Terms screen
                              Navigator.pushNamed(context, '/terms');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
