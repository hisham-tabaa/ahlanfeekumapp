import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/home_entities.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/web_compatible_network_image.dart';

class HighlyRatedPropertiesWidget extends StatelessWidget {
  final List<Property> properties;

  const HighlyRatedPropertiesWidget({super.key, required this.properties});

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
      mobile: 24,
      tablet: 26,
      desktop: 28,
    );
    final titleFontSize = ResponsiveUtils.fontSize(
      context,
      mobile: 18,
      tablet: 20,
      desktop: 22,
    );
    final chevronSize = ResponsiveUtils.size(
      context,
      mobile: 20,
      tablet: 22,
      desktop: 24,
    );
    final verticalSpacing = ResponsiveUtils.spacing(
      context,
      mobile: 16,
      tablet: 18,
      desktop: 20,
    );
    final cardHeight = ResponsiveUtils.size(
      context,
      mobile: 200,
      tablet: 240,
      desktop: 280,
    );
    final listPadding = ResponsiveUtils.spacing(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 24,
    );
    final cardSeparator = ResponsiveUtils.spacing(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
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
                Icon(
                  Icons.star_border_outlined,
                  color: AppColors.primary,
                  size: iconSize,
                ),
                SizedBox(
                  width: ResponsiveUtils.spacing(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
                Text(
                  'highly_rated_properties'.tr(),
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
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey[500],
                    size: chevronSize,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: verticalSpacing),

          SizedBox(
            height: cardHeight,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: listPadding),
              scrollDirection: Axis.horizontal,
              itemCount: properties.length,
              cacheExtent: 500, // Preload items for smoother scrolling
              addAutomaticKeepAlives: true,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, __) => SizedBox(width: cardSeparator),
              itemBuilder: (context, index) {
                final property = properties[index];
                final cardWidth = ResponsiveUtils.size(
                  context,
                  mobile: 160,
                  tablet: 190,
                  desktop: 220,
                );
                final cardRadius = ResponsiveUtils.radius(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                );
                final imageHeight = ResponsiveUtils.size(
                  context,
                  mobile: 110,
                  tablet: 130,
                  desktop: 150,
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(cardRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(cardRadius),
                          ),
                          child: Stack(
                            children: [
                              WebCompatibleNetworkImage(
                                imageUrl:
                                    property.mainImageUrl ??
                                    'https://via.placeholder.com/300x200',
                                width: double.infinity,
                                height: imageHeight,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey[200]),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.primary.withOpacity(0.1),
                                  child: Icon(
                                    Icons.home_outlined,
                                    color: AppColors.primary,
                                    size: ResponsiveUtils.size(
                                      context,
                                      mobile: 28,
                                      tablet: 32,
                                      desktop: 36,
                                    ),
                                  ),
                                ),
                              ),
                              if (property.averageRating != null &&
                                  property.averageRating! > 0)
                                Positioned(
                                  top: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 8,
                                    tablet: 10,
                                    desktop: 12,
                                  ),
                                  left: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 8,
                                    tablet: 10,
                                    desktop: 12,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveUtils.spacing(
                                        context,
                                        mobile: 10,
                                        tablet: 11,
                                        desktop: 12,
                                      ),
                                      vertical: ResponsiveUtils.spacing(
                                        context,
                                        mobile: 5,
                                        tablet: 6,
                                        desktop: 7,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.warning,
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveUtils.radius(
                                          context,
                                          mobile: 14,
                                          tablet: 15,
                                          desktop: 16,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.warning.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: ResponsiveUtils.size(
                                            context,
                                            mobile: 14,
                                            tablet: 15,
                                            desktop: 16,
                                          ),
                                          color: Colors.white,
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
                                          property.averageRating!
                                              .toStringAsFixed(1),
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize:
                                                    ResponsiveUtils.fontSize(
                                                      context,
                                                      mobile: 12,
                                                      tablet: 13,
                                                      desktop: 14,
                                                    ),
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              // Heart icon (favorite) in top right
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
                                      mobile: 4,
                                      tablet: 5,
                                      desktop: 6,
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
                                      mobile: 16,
                                      tablet: 18,
                                      desktop: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(
                              ResponsiveUtils.spacing(
                                context,
                                mobile: 8,
                                tablet: 10,
                                desktop: 12,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    property.title,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: ResponsiveUtils.fontSize(
                                        context,
                                        mobile: 12,
                                        tablet: 14,
                                        desktop: 16,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 4,
                                    tablet: 5,
                                    desktop: 6,
                                  ),
                                ),
                                // Property type and distance row
                                Row(
                                  children: [
                                    // Property type icon
                                    Icon(
                                      property.hotelName != null
                                          ? Icons.hotel
                                          : Icons.apartment,
                                      size: ResponsiveUtils.size(
                                        context,
                                        mobile: 12,
                                        tablet: 14,
                                        desktop: 16,
                                      ),
                                      color: Colors.grey[600],
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
                                      property.hotelName != null
                                          ? 'Hotel'
                                          : 'Apartment',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: ResponsiveUtils.fontSize(
                                          context,
                                          mobile: 10,
                                          tablet: 11,
                                          desktop: 12,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ResponsiveUtils.spacing(
                                        context,
                                        mobile: 8,
                                        tablet: 9,
                                        desktop: 10,
                                      ),
                                    ),
                                    // Distance/Area
                                    SizedBox(
                                      width: ResponsiveUtils.spacing(
                                        context,
                                        mobile: 2,
                                        tablet: 3,
                                        desktop: 4,
                                      ),
                                    ),
                                    Text(
                                      (property.area != null &&
                                              property.area! > 0)
                                          ? '${property.area!.toInt()} M²'
                                          : '?? M', // Default distance when area is null or 0
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.primary,
                                        fontSize: ResponsiveUtils.fontSize(
                                          context,
                                          mobile: 10,
                                          tablet: 11,
                                          desktop: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
