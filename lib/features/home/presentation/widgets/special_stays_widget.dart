import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/home_entities.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/web_compatible_network_image.dart';

class SpecialStaysWidget extends StatelessWidget {
  final List<Property> properties;

  const SpecialStaysWidget({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) return const SizedBox.shrink();

    final topBottomMargin = ResponsiveUtils.spacing(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 24,
    );
    final horizontalPadding = ResponsiveUtils.spacing(
      context,
      mobile: 20,
      tablet: 24,
      desktop: 32,
    );
    final iconSize = ResponsiveUtils.size(
      context,
      mobile: 18,
      tablet: 20,
      desktop: 22,
    );
    final titleFontSize = ResponsiveUtils.fontSize(
      context,
      mobile: 18,
      tablet: 20,
      desktop: 22,
    );
    final seeAllFontSize = ResponsiveUtils.fontSize(
      context,
      mobile: 14,
      tablet: 15,
      desktop: 16,
    );
    final verticalSpacing = ResponsiveUtils.spacing(
      context,
      mobile: 16,
      tablet: 18,
      desktop: 20,
    );
    final cardHeight = ResponsiveUtils.size(
      context,
      mobile: 220,
      tablet: 260,
      desktop: 300,
    );
    final listPadding = ResponsiveUtils.spacing(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 24,
    );

    return Container(
      margin: EdgeInsets.only(top: topBottomMargin, bottom: topBottomMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: iconSize),
                SizedBox(
                  width: ResponsiveUtils.spacing(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
                Text(
                  'special_stays'.tr(),
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Navigate to search screen
                    Navigator.pushNamed(context, '/search');
                  },
                  child: Text(
                    'see_all'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: seeAllFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: verticalSpacing),

          SizedBox(
            height: cardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: listPadding),
              itemCount: properties.length,
              cacheExtent: 500, // Preload items for smoother scrolling
              addAutomaticKeepAlives: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final property = properties[index];
                final cardWidth = ResponsiveUtils.size(
                  context,
                  mobile: 165,
                  tablet: 200,
                  desktop: 240,
                );
                final cardMargin = ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                );
                final cardRadius = ResponsiveUtils.radius(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                );

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/property-detail',
                      arguments: property.id,
                    );
                  },
                  child: Container(
                    width: cardWidth,
                    margin: EdgeInsets.only(right: cardMargin),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(cardRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(cardRadius),
                      child: Stack(
                        children: [
                          // Property Image (full card)
                          WebCompatibleNetworkImage(
                            imageUrl:
                                property.mainImageUrl ??
                                'https://via.placeholder.com/300x200',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.primary.withOpacity(0.1),
                              child: Center(
                                child: Icon(
                                  Icons.home_outlined,
                                  color: AppColors.primary,
                                  size: ResponsiveUtils.size(
                                    context,
                                    mobile: 40,
                                    tablet: 48,
                                    desktop: 56,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),

                          // Heart icon overlay
                          Positioned(
                            top: ResponsiveUtils.spacing(
                              context,
                              mobile: 8,
                              tablet: 10,
                              desktop: 12,
                            ),
                            right: ResponsiveUtils.spacing(
                              context,
                              mobile: 8,
                              tablet: 10,
                              desktop: 12,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(
                                ResponsiveUtils.spacing(
                                  context,
                                  mobile: 6,
                                  tablet: 7,
                                  desktop: 8,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                property.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: property.isFavorite
                                    ? Colors.red
                                    : Colors.grey[600],
                                size: ResponsiveUtils.size(
                                  context,
                                  mobile: 14,
                                  tablet: 16,
                                  desktop: 18,
                                ),
                              ),
                            ),
                          ),

                          // Text content overlay at bottom
                          Positioned(
                            bottom: ResponsiveUtils.spacing(
                              context,
                              mobile: 12,
                              tablet: 14,
                              desktop: 16,
                            ),
                            left: ResponsiveUtils.spacing(
                              context,
                              mobile: 12,
                              tablet: 14,
                              desktop: 16,
                            ),
                            right: ResponsiveUtils.spacing(
                              context,
                              mobile: 12,
                              tablet: 14,
                              desktop: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  property.title,
                                  style: AppTextStyles.h5.copyWith(
                                    color: Colors.white,
                                    fontSize: ResponsiveUtils.fontSize(
                                      context,
                                      mobile: 14,
                                      tablet: 16,
                                      desktop: 18,
                                    ),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 4,
                                    tablet: 5,
                                    desktop: 6,
                                  ),
                                ),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.white70,
                                      size: ResponsiveUtils.size(
                                        context,
                                        mobile: 12,
                                        tablet: 14,
                                        desktop: 16,
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
                                        property.displayLocation,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white70,
                                          fontSize: ResponsiveUtils.fontSize(
                                            context,
                                            mobile: 10,
                                            tablet: 12,
                                            desktop: 14,
                                          ),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 6,
                                    tablet: 7,
                                    desktop: 8,
                                  ),
                                ),

                                // Price
                                Row(
                                  children: [
                                    Text(
                                      '${property.pricePerNight.toStringAsFixed(0)} \$',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: Colors.white,
                                        fontSize: ResponsiveUtils.fontSize(
                                          context,
                                          mobile: 16,
                                          tablet: 18,
                                          desktop: 20,
                                        ),
                                        fontWeight: FontWeight.w800,
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
                                      '/ Night',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white70,
                                        fontSize: ResponsiveUtils.fontSize(
                                          context,
                                          mobile: 11,
                                          tablet: 13,
                                          desktop: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
