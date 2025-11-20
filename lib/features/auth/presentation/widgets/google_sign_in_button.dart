import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({super.key, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final buttonHeight = ResponsiveUtils.size(
      context,
      mobile: 52,
      tablet: 56,
      desktop: 60,
    );
    
    final buttonRadius = ResponsiveUtils.radius(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );
    
    final horizontalPadding = ResponsiveUtils.spacing(
      context,
      mobile: 24,
      tablet: 28,
      desktop: 32,
    );
    
    final iconSize = ResponsiveUtils.size(
      context,
      mobile: 22,
      tablet: 24,
      desktop: 26,
    );
    
    final iconSpacing = ResponsiveUtils.spacing(
      context,
      mobile: 10,
      tablet: 12,
      desktop: 14,
    );
    
    final textSize = ResponsiveUtils.fontSize(
      context,
      mobile: 15,
      tablet: 16,
      desktop: 17,
    );
    
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 0,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: iconSize,
                height: iconSize,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Icon
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://developers.google.com/identity/images/g-logo.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: iconSpacing),
                  Text(
                    'login_with_google'.tr(),
                    style: AppTextStyles.buttonText.copyWith(
                      fontSize: textSize,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
