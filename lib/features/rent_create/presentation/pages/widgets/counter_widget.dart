import 'package:flutter/material.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/text_styles.dart';

class CounterWidget extends StatelessWidget {
  final String title;
  final int value;
  final ValueChanged<int> onChanged;
  final int minValue;
  final int maxValue;

  const CounterWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.minValue = 1,
    this.maxValue = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: ResponsiveUtils.fontSize(context, mobile: 14, tablet: 16, desktop: 18),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(context, mobile: 8, tablet: 10, desktop: 12)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing(context, mobile: 18, tablet: 20, desktop: 22), vertical: ResponsiveUtils.spacing(context, mobile: 14, tablet: 16, desktop: 18)),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20)),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.18)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveUtils.fontSize(context, mobile: 16, tablet: 18, desktop: 20),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildArrowButton(
                    context,
                    icon: Icons.expand_more,
                    onTap: value > minValue ? () => onChanged(value - 1) : null,
                  ),
                  SizedBox(width: ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16)),
                  _buildArrowButton(
                    context,
                    icon: Icons.expand_less,
                    onTap: value < maxValue ? () => onChanged(value + 1) : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArrowButton(BuildContext context, {
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveUtils.size(context, mobile: 32, tablet: 36, desktop: 40),
        height: ResponsiveUtils.size(context, mobile: 32, tablet: 36, desktop: 40),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: isEnabled ? 0.12 : 0.06),
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius(context, mobile: 10, tablet: 12, desktop: 14)),
        ),
        child: Icon(
          icon,
          color: isEnabled ? AppColors.primary : Colors.grey[400],
          size: ResponsiveUtils.fontSize(context, mobile: 18, tablet: 20, desktop: 22),
        ),
      ),
    );
  }
}
