import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? icon;
  final double? borderRadius;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Use responsive sizing for web and mobile
    final buttonHeight = height ?? ResponsiveUtils.size(
      context,
      mobile: 52,
      tablet: 56,
      desktop: 60,
    );
    
    final buttonRadius = borderRadius ?? ResponsiveUtils.radius(
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
      mobile: 20,
      tablet: 22,
      desktop: 24,
    );
    
    final iconSpacing = ResponsiveUtils.spacing(
      context,
      mobile: 8,
      tablet: 10,
      desktop: 12,
    );
    
    final textSize = ResponsiveUtils.fontSize(
      context,
      mobile: 15,
      tablet: 16,
      desktop: 17,
    );

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
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
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(textColor ?? Colors.white),
                ),
              )
            : (text.isEmpty
                ? Center(child: icon)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon!, 
                        SizedBox(width: iconSpacing)
                      ],
                      Expanded(
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: textStyle ??
                              AppTextStyles.buttonText.copyWith(
                                fontSize: textSize,
                                color: textColor ?? Colors.white,
                              ),
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }
}
