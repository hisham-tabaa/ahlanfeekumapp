import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/language_switcher_button.dart';
import 'auth_options_screen.dart';

class WelcomeSplashScreen extends StatefulWidget {
  const WelcomeSplashScreen({super.key});

  @override
  State<WelcomeSplashScreen> createState() => _WelcomeSplashScreenState();
}

class _WelcomeSplashScreenState extends State<WelcomeSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveUtils.isDesktop(context)
          ? _buildDesktopLayout(context)
          : _buildMobileLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ResponsiveLayout(
      maxWidth: ResponsiveUtils.isWeb ? 400 : null,
      child: Stack(
        children: [
        // الصورة الخلفية
        Positioned.fill(
          child: Image.asset(
            'assets/images/Background1.png',
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.srcOver,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),

        // محتوى الشاشة
        SafeArea(
          child: Column(
            children: [
              // Language Switcher at top right
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: ResponsiveUtils.spacing(context, mobile: 16, tablet: 20, desktop: 24),
                    right: ResponsiveUtils.spacing(context, mobile: 16, tablet: 20, desktop: 24),
                  ),
                  child: LanguageSwitcherButton(
                    isDark: true,
                    onLanguageChanged: () {
                      setState(() {
                        // Force rebuild when language changes
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing(context, mobile: 84, tablet: 100, desktop: 120)),

              // Logo
              Center(
                child: Image.asset(
                  'assets/images/home_icon.png',
                  width: ResponsiveUtils.size(context, mobile: 198, tablet: 220, desktop: 250),
                  height: ResponsiveUtils.size(context, mobile: 108, tablet: 120, desktop: 135),
                ),
              ),

              const Spacer(),

              // القسم الأبيض المنحني
              ClipPath(
                clipper: TopCurveClipper(),
                child: Container(
                  height: ResponsiveUtils.size(context, mobile: 293, tablet: 320, desktop: 350),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(context, mobile: 24, tablet: 28, desktop: 32),
                      vertical: ResponsiveUtils.spacing(context, mobile: 46, tablet: 52, desktop: 58),
                    ),
                    child: _buildOriginalContent(context),
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

  Widget _buildDesktopLayout(BuildContext context) {
    return ResponsiveLayout(
      child: Stack(
        children: [
          Row(
        children: [
          // Left side - Background image with logo (similar to login)
          Expanded(
            flex: ResponsiveUtils.isDesktop(context) ? 3 : 2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Background1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/home_icon.png',
                        width: ResponsiveUtils.responsive(context,
                          mobile: 150,
                          tablet: 200,
                          desktop: 280,
                        ),
                        height: ResponsiveUtils.responsive(context,
                          mobile: 82,
                          tablet: 110,
                          desktop: 150,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.spacing(context, mobile: 32, tablet: 36, desktop: 40)),
                      Text(
                        'welcome_to_syria'.tr(),
                        style: AppTextStyles.h2.copyWith(
                          fontSize: ResponsiveUtils.responsive(context,
                            mobile: 24,
                            tablet: 28,
                            desktop: 32,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
                      Text(
                        'find_perfect_stay'.tr(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: ResponsiveUtils.responsive(context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 18,
                          ),
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Right side - Welcome content (similar to login form)
          Expanded(
            flex: ResponsiveUtils.isDesktop(context) ? 2 : 3,
            child: Container(
              color: Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.responsive(context,
                      mobile: 24,
                      tablet: 40,
                      desktop: 48,
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveUtils.responsive(context,
                        mobile: double.infinity,
                        tablet: 400,
                        desktop: 450,
                      ),
                    ),
                    child: _buildContent(context),
                  ),
                ),
              ),
            ),
          ),
            ],
          ),
          
          // Language Switcher at top right
          Positioned(
            top: ResponsiveUtils.spacing(context, mobile: 16, tablet: 20, desktop: 24),
            right: ResponsiveUtils.spacing(context, mobile: 16, tablet: 20, desktop: 24),
            child: LanguageSwitcherButton(
              onLanguageChanged: () {
                setState(() {
                  // Force rebuild when language changes
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isTablet(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // Welcome title
        Text(
          'ahlan_feekum'.tr(),
          style: AppTextStyles.h6.copyWith(
            fontSize: ResponsiveUtils.responsive(context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ),
        
        SizedBox(height: ResponsiveUtils.responsive(context,
          mobile: 8,
          tablet: 12,
          desktop: 16,
        )),
        
        // Main heading
        RichText(
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'discover_unique_part1'.tr(),
                style: AppTextStyles.h2.copyWith(
                  fontSize: ResponsiveUtils.responsive(context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'discover_unique_part2'.tr(),
                style: AppTextStyles.h2.copyWith(
                  fontSize: ResponsiveUtils.responsive(context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                  color: const Color(0xFF4CAF50),
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'discover_unique_part3'.tr(),
                style: AppTextStyles.h2.copyWith(
                  fontSize: ResponsiveUtils.responsive(context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: ResponsiveUtils.responsive(context,
          mobile: 16,
          tablet: 20,
          desktop: 24,
        )),
        
        // Subtitle description
        Text(
          'join_travelers'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: ResponsiveUtils.responsive(context,
              mobile: 14,
              tablet: 16,
              desktop: 18,
            ),
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ),
        
        SizedBox(height: ResponsiveUtils.responsive(context,
          mobile: 32,
          tablet: 40,
          desktop: 48,
        )),
        
        // Get Started Button
        CustomButton(
          borderRadius: ResponsiveUtils.responsive(context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
          text: 'get_started'.tr(),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AuthOptionsScreen(),
              ),
            );
          },
          width: double.infinity,
          height: ResponsiveUtils.responsive(context,
            mobile: 48,
            tablet: 52,
            desktop: 56,
          ),
          backgroundColor: const Color(0xFFED1C24),
          textColor: Colors.white,
        ),
        
        SizedBox(height: ResponsiveUtils.responsive(context,
          mobile: 24,
          tablet: 28,
          desktop: 32,
        )),
        
        // Features list for desktop
        if (isDesktop) ...[
          Row(
            children: [
              Icon(
                Icons.verified_user,
                color: const Color(0xFF4CAF50),
                size: ResponsiveUtils.responsive(context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
              ),
              SizedBox(width: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16)),
              Expanded(
                child: Text(
                  'verified_properties'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: ResponsiveUtils.responsive(context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
          
          Row(
            children: [
              Icon(
                Icons.support_agent,
                color: const Color(0xFF4CAF50),
                size: ResponsiveUtils.responsive(context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
              ),
              SizedBox(width: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16)),
              Expanded(
                child: Text(
                  'customer_support_24_7'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: ResponsiveUtils.responsive(context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20)),
          
          Row(
            children: [
              Icon(
                Icons.security,
                color: const Color(0xFF4CAF50),
                size: ResponsiveUtils.responsive(context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
              ),
              SizedBox(width: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16)),
              Expanded(
                child: Text(
                  'secure_booking'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: ResponsiveUtils.responsive(context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOriginalContent(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ahlan_feekum'.tr(),
          style: AppTextStyles.h6.copyWith(
            fontSize: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'discover_unique_part1'.tr(),
                style: AppTextStyles.h2.copyWith(
                  fontSize: ResponsiveUtils.fontSize(context, mobile: 24, tablet: 26, desktop: 28),
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'discover_unique_part2'.tr(),
                style: AppTextStyles.h2.copyWith(
                  fontSize: ResponsiveUtils.fontSize(context, mobile: 24, tablet: 26, desktop: 28),
                  color: const Color(0xFF4CAF50),
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'discover_unique_part3'.tr(),
                style: AppTextStyles.h2.copyWith(
                  fontSize: ResponsiveUtils.fontSize(context, mobile: 24, tablet: 26, desktop: 28),
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context, mobile: 28, tablet: 32, desktop: 36)),
        CustomButton(
          borderRadius: ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20),
          text: 'get_started'.tr(),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AuthOptionsScreen(),
              ),
            );
          },
          width: double.infinity,
        ),
      ],
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final double curveHeight = size.height * 0.1; // 5% من ارتفاع الشاشة

    path.moveTo(0, curveHeight);

    path.cubicTo(
      size.width * 0.25,
      0, // control point أعلى
      size.width * 0.75,
      0, // control point أعلى
      size.width,
      curveHeight, // نهاية القوس
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
