import 'package:flutter/material.dart';
import '../../../../../theming/colors.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../theming/text_styles.dart';

class FeatureChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const FeatureChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing(context, mobile: 18, tablet: 20, desktop: 22), vertical: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 18, tablet: 20, desktop: 22)),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.withValues(alpha: 0.3),
            width: 1.4,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: Icon(
                isSelected ? Icons.check_circle : Icons.circle,
                key: ValueKey(
                  // ignore: unnecessary_string_interpolations
                  '${'$label'}-${isSelected ? 'selected' : 'default'}',
                ),
                size: ResponsiveUtils.fontSize(context, mobile: 12, tablet: 14, desktop: 16),
                color: isSelected ? AppColors.primary : Colors.grey[400],
              ),
            ),
            SizedBox(width: ResponsiveUtils.spacing(context, mobile: 10, tablet: 12, desktop: 14)),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 16, desktop: 18),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
