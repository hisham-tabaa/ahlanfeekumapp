import 'package:flutter/material.dart';

import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/property_detail.dart';

class PropertyFeaturesWidget extends StatelessWidget {
  final List<PropertyFeature> features;

  const PropertyFeaturesWidget({
    super.key,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property Features',
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
        Wrap(
          spacing: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
          runSpacing: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
          children: features.map((feature) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  mobile: 8,
                  tablet: 10,
                  desktop: 12,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: ResponsiveUtils.fontSize(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    color: AppColors.primary,
                  ),
                  SizedBox(
                    width: ResponsiveUtils.spacing(
                      context,
                      mobile: 6,
                      tablet: 7,
                      desktop: 8,
                    ),
                  ),
                  Text(
                    feature.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
