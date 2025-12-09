import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/property_detail.dart';

class PropertyMainDetailsWidget extends StatelessWidget {
  final PropertyDetail property;

  const PropertyMainDetailsWidget({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'main_details'.tr(),
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
          _buildDetailRow(
            context,
            'price'.tr(),
            '${property.pricePerNight.toStringAsFixed(0)} ${'s_per_night'.tr()}',
          ),
          _buildDetailRow(context, 'property_type'.tr(), property.propertyTypeName),
          _buildDetailRow(context, 'bedrooms'.tr(), '${property.bedrooms} ${'bedrooms'.tr()}'),
          _buildDetailRow(
            context,
            'living_rooms'.tr(),
            '${property.livingrooms} ${'rooms'.tr()}',
          ),
          _buildDetailRow(
            context,
            'bathrooms'.tr(),
            '${property.bathrooms} ${'bathrooms'.tr()}',
          ),
          _buildDetailRow(
            context,
            'number_of_beds'.tr(),
            '${property.numberOfBeds} ${'beds'.tr()}',
          ),
          _buildDetailRow(
            context,
            'maximum_guests'.tr(),
            '${property.maxGuests} ${'guests'.tr()}',
          ),
          _buildDetailRow(context, 'floor'.tr(), '${property.floor} ${'floor'.tr()}'),
          _buildDetailRow(context, 'posted_by'.tr(), property.ownerName),
          _buildDetailRow(context, 'governorate'.tr(), property.governorateName),
          if (property.area != null)
            _buildDetailRow(
              context,
              'area'.tr(),
              '${property.area!.toStringAsFixed(0)} m²',
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.spacing(
          context,
          mobile: 6,
          tablet: 7,
          desktop: 8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
