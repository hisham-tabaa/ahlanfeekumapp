import 'package:flutter/material.dart';

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
            'Main Details',
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
            'Price',
            '${property.pricePerNight.toStringAsFixed(0)} S / Night',
          ),
          _buildDetailRow(context, 'Property Type', property.propertyTypeName),
          _buildDetailRow(context, 'Bedrooms', '${property.bedrooms} Bedrooms'),
          _buildDetailRow(
            context,
            'Living Rooms',
            '${property.livingrooms} Rooms',
          ),
          _buildDetailRow(
            context,
            'Bathrooms',
            '${property.bathrooms} Bathrooms',
          ),
          _buildDetailRow(
            context,
            'Number Of Beds',
            '${property.numberOfBeds} Beds',
          ),
          _buildDetailRow(
            context,
            'Maximum Guests',
            '${property.maxGuests} Guests',
          ),
          _buildDetailRow(context, 'Floor', '${property.floor} Floor'),
          _buildDetailRow(context, 'Posted By', property.ownerName),
          _buildDetailRow(context, 'Governorate', property.governorateName),
          if (property.area != null)
            _buildDetailRow(
              context,
              'Area',
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
