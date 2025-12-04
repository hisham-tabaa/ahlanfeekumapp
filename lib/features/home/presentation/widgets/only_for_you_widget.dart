import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/home_entities.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/web_compatible_network_image.dart';

class OnlyForYouWidget extends StatelessWidget {
  final OnlyForYouSection? onlyForYouSection;

  const OnlyForYouWidget({super.key, required this.onlyForYouSection});

  @override
  Widget build(BuildContext context) {
    if (onlyForYouSection == null) {
      return const SizedBox.shrink();
    }

    final verticalMargin = ResponsiveUtils.spacing(
      context,
      mobile: 8,
      tablet: 12,
      desktop: 16,
    );
    final horizontalPadding = ResponsiveUtils.spacing(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 24,
    );
    final titleFontSize = ResponsiveUtils.fontSize(
      context,
      mobile: 18,
      tablet: 20,
      desktop: 22,
    );
    final chevronSize = ResponsiveUtils.size(
      context,
      mobile: 22,
      tablet: 24,
      desktop: 26,
    );
    final verticalSpacing = ResponsiveUtils.spacing(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );
    final topRowHeight = ResponsiveUtils.size(
      context,
      mobile: 160,
      tablet: 190,
      desktop: 220,
    );
    final bottomRowHeight = ResponsiveUtils.size(
      context,
      mobile: 120,
      tablet: 140,
      desktop: 160,
    );
    final bottomMargin = ResponsiveUtils.spacing(
      context,
      mobile: 24,
      tablet: 28,
      desktop: 32,
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalMargin, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                SizedBox(
                  width: ResponsiveUtils.spacing(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
                Text(
                  'only_for_you'.tr(),
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[500],
                  size: chevronSize,
                ),
              ],
            ),
          ),

          SizedBox(height: verticalSpacing),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                Expanded(
                  child: _buildPhotoCard(
                    context,
                    onlyForYouSection!.firstPhotoUrl,
                    height: topRowHeight,
                  ),
                ),
                SizedBox(width: verticalSpacing),
                Expanded(
                  child: _buildPhotoCard(
                    context,
                    onlyForYouSection!.secondPhotoUrl,
                    height: topRowHeight,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: verticalSpacing),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: _buildPhotoCard(
              context,
              onlyForYouSection!.thirdPhotoUrl,
              height: bottomRowHeight,
            ),
          ),

          SizedBox(height: bottomMargin),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(
    BuildContext context,
    String imageUrl, {
    double? height,
  }) {
    final cardRadius = ResponsiveUtils.radius(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );
    final errorIconSize = ResponsiveUtils.size(
      context,
      mobile: 40,
      tablet: 48,
      desktop: 56,
    );

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius),
        child: WebCompatibleNetworkImage(
          imageUrl: imageUrl,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: double.infinity,
            height: height,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: double.infinity,
            height: height,
            color: AppColors.primary.withOpacity(0.1),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                color: AppColors.primary,
                size: errorIconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
