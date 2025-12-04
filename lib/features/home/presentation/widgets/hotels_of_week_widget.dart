import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/web_scroll_behavior.dart';
import '../../domain/entities/home_entities.dart';

class HotelsOfWeekWidget extends StatelessWidget {
  final List<HotelOfTheWeek>? hotels;
  const HotelsOfWeekWidget({super.key, this.hotels});

  @override
  Widget build(BuildContext context) {
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
    final cardHeight = ResponsiveUtils.size(
      context,
      mobile: 75,
      tablet: 85,
      desktop: 95,
    );
    final cardSeparator = ResponsiveUtils.spacing(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                Icon(
                  Icons.local_attraction_outlined,
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
                  'hotels_of_week'.tr(),
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

          if (hotels != null && hotels!.isNotEmpty)
            SizedBox(
              height: cardHeight,
              child: WebScrollUtils.listView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final h = hotels![index];
                  return _buildHostCard(
                    context,
                    h.averageRating,
                    h.name,
                    h.profilePhotoUrl,
                  );
                },
                separatorBuilder: (_, __) => SizedBox(width: cardSeparator),
                itemCount: hotels!.length,
              ),
            )
          else
            // Show empty state or loading
            SizedBox(
              height: cardHeight,
              child: Center(
                child: Text(
                  'No hotels available',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHostCard(
    BuildContext context,
    double? rating,
    String name,
    String? avatarUrl,
  ) {
    final cardWidth = ResponsiveUtils.size(
      context,
      mobile: 170,
      tablet: 200,
      desktop: 230,
    );
    final cardHeight = ResponsiveUtils.size(
      context,
      mobile: 70,
      tablet: 80,
      desktop: 90,
    );
    final cardRadius = ResponsiveUtils.radius(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );
    final cardPadding = ResponsiveUtils.spacing(
      context,
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );
    final avatarRadius = ResponsiveUtils.radius(
      context,
      mobile: 25,
      tablet: 28,
      desktop: 32,
    );
    final iconSize = ResponsiveUtils.size(
      context,
      mobile: 20,
      tablet: 22,
      desktop: 24,
    );

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Row(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: avatarRadius,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              child: avatarUrl == null || avatarUrl.isEmpty
                  ? Icon(Icons.person, color: AppColors.primary, size: iconSize)
                  : null,
            ),

            SizedBox(
              width: ResponsiveUtils.spacing(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
            ),

            // Name and Rating Column
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating with star
                  if (rating != null)
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: ResponsiveUtils.size(
                            context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 18,
                          ),
                          color: Colors.amber,
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
                          rating.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              mobile: 13,
                              tablet: 14,
                              desktop: 15,
                            ),
                            fontWeight: FontWeight.w600,
                            color: Colors.amber.shade600,
                          ),
                        ),
                      ],
                    ),

                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 4,
                      tablet: 5,
                      desktop: 6,
                    ),
                  ),

                  // Host Name
                  Text(
                    name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 14,
                        tablet: 15,
                        desktop: 16,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
