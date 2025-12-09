import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../domain/entities/property_detail.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/property_detail_bloc.dart';
import '../bloc/property_detail_event.dart';
import '../../../../core/utils/responsive_utils.dart';

class PropertyHeaderWidget extends StatelessWidget {
  final PropertyDetail property;
  final VoidCallback onSignInPrompt;

  const PropertyHeaderWidget({
    super.key,
    required this.property,
    required this.onSignInPrompt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  mobile: 10,
                  tablet: 12,
                  desktop: 14,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  mobile: 4,
                  tablet: 5,
                  desktop: 6,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    size: ResponsiveUtils.fontSize(
                      context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                    color: AppColors.primary,
                  ),
                  SizedBox(
                    width: ResponsiveUtils.spacing(
                      context,
                      mobile: 4,
                      tablet: 5,
                      desktop: 6,
                    ),
                  ),
                  Text(
                    property.averageRating.toStringAsFixed(1),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveUtils.spacing(
                      context,
                      mobile: 4,
                      tablet: 5,
                      desktop: 6,
                    ),
                  ),
                  Text(
                    property.averageRating > 4.5 ? 'Great' : 'Good',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return IconButton(
                  onPressed: () {
                    if (authState is AuthGuest) {
                      onSignInPrompt();
                    } else {
                      context.read<PropertyDetailBloc>().add(
                        ToggleFavoriteEvent(
                          propertyId: property.id,
                          isFavorite: property.isFavorite,
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    property.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: property.isFavorite ? Colors.red : AppColors.primary,
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () {
                SharePlus.instance.share(
                  ShareParams(
                    text:
                        'Check out this amazing property: ${property.title}\n\nLocation: ${property.address}\n\nPrice: ${property.pricePerNight.toStringAsFixed(0)} \$ per night\n\nBedrooms: ${property.bedrooms} | Bathrooms: ${property.bathrooms}',
                    subject: property.title,
                  ),
                );
              },
              icon: Icon(Icons.share_outlined, color: AppColors.textPrimary),
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
        Text(
          property.title,
          style: AppTextStyles.h2.copyWith(
            fontSize: ResponsiveUtils.fontSize(
              context,
              mobile: 22,
              tablet: 24,
              desktop: 26,
            ),
            fontWeight: FontWeight.w700,
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
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: AppColors.textSecondary,
              size: ResponsiveUtils.fontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(
                context,
                mobile: 4,
                tablet: 5,
                desktop: 6,
              ),
            ),
            Expanded(
              child: Text(
                property.address ?? 'Address not provided',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
