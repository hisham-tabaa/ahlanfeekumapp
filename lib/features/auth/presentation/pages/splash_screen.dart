import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../widgets/custom_button.dart';
import 'auth_options_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(context, mobile: 24, tablet: 32, desktop: 40),
            ),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // App Logo/Icon
                Container(
                  width: ResponsiveUtils.size(context, mobile: 120, tablet: 140, desktop: 160),
                  height: ResponsiveUtils.size(context, mobile: 120, tablet: 140, desktop: 160),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.radius(context, mobile: 30, tablet: 35, desktop: 40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.waving_hand,
                    size: ResponsiveUtils.size(context, mobile: 60, tablet: 70, desktop: 80),
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 40, tablet: 48, desktop: 56)),

                // App Name
                Text(
                  'app_name'.tr(),
                  style: AppTextStyles.h1.copyWith(
                    fontSize: ResponsiveUtils.fontSize(context, mobile: 32, tablet: 36, desktop: 40),
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 16, tablet: 20, desktop: 24)),

                // Welcome Message
                Text(
                  'welcome'.tr(),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 3),

                // Get Started Button
                CustomButton(
                  text: 'get_started'.tr(),
                  onPressed: () {
                    context.push(const AuthOptionsScreen());
                  },
                  width: double.infinity,
                ),

                SizedBox(height: ResponsiveUtils.spacing(context, mobile: 40, tablet: 48, desktop: 56)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
