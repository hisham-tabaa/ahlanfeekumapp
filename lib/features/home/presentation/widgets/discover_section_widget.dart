import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/home_entities.dart';
import '../../../search/data/models/search_filter.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';

class DiscoverSectionWidget extends StatelessWidget {
  final List<Governorate> governorates;

  const DiscoverSectionWidget({super.key, required this.governorates});

  @override
  Widget build(BuildContext context) {
    if (governorates.isEmpty) return const SizedBox.shrink();

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
      mobile: 145,
      tablet: 170,
      desktop: 200,
    );
    final listPadding = ResponsiveUtils.spacing(
      context,
      mobile: 12,
      tablet: 16,
      desktop: 20,
    );
    final cardSeparator = ResponsiveUtils.spacing(
      context,
      mobile: 10,
      tablet: 12,
      desktop: 14,
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
                  Icons.sports_baseball_outlined,
                  color: Colors.redAccent,
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
                  'discover_places'.tr(),
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

          SizedBox(
            height: cardHeight,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: listPadding),
              scrollDirection: Axis.horizontal,
              itemCount: governorates.length.clamp(0, 8),
              cacheExtent: 500, // Preload items for smoother scrolling
              addAutomaticKeepAlives: true,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, __) => SizedBox(width: cardSeparator),
              itemBuilder: (context, index) {
                final governorate = governorates[index];
                final cardWidth = ResponsiveUtils.size(
                  context,
                  mobile: 110,
                  tablet: 130,
                  desktop: 150,
                );
                final cardRadius = ResponsiveUtils.radius(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                );

                return GestureDetector(
                  onTap: () => _onGovernorateSelected(context, governorate),
                  child: Container(
                    width: cardWidth,
                    height: cardHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(cardRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Full image background
                        ClipRRect(
                          borderRadius: BorderRadius.circular(cardRadius),
                          child: governorate.iconUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: governorate.iconUrl!,
                                  width: cardWidth,
                                  height: cardHeight,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: cardWidth,
                                    height: cardHeight,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.primary,
                                            ),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      width: cardWidth,
                                      height: cardHeight,
                                      color: AppColors.primary.withOpacity(0.1),
                                      child: Icon(
                                        Icons.location_city,
                                        color: AppColors.primary,
                                        size: ResponsiveUtils.size(
                                          context,
                                          mobile: 40,
                                          tablet: 48,
                                          desktop: 56,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: cardWidth,
                                  height: cardHeight,
                                  color: AppColors.primary.withOpacity(0.1),
                                  child: Icon(
                                    Icons.location_city,
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
                        // Gradient overlay
                        ClipRRect(
                          borderRadius: BorderRadius.circular(cardRadius),
                          child: Container(
                            width: cardWidth,
                            height: cardHeight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Title at bottom
                        Positioned(
                          bottom: ResponsiveUtils.spacing(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 16,
                          ),
                          left: ResponsiveUtils.spacing(
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
                          child: Text(
                            governorate.title,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
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
                            textAlign: TextAlign.center,
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

  void _onGovernorateSelected(
    BuildContext context,
    Governorate governorate,
  ) async {
    try {
      // Create a search filter with ONLY the governorate ID for focused filtering
      final searchFilter = SearchFilter(
        governorateId: governorate.id,
        // Remove filterText to avoid potential conflicts
        skipCount: 0,
        maxResultCount: 20,
      );

      // Navigate to search results screen
      await Navigator.of(
        context,
      ).pushNamed('/search-results', arguments: {'filter': searchFilter});
    } catch (e) {
      // Fallback navigation with minimal filter
      try {
        await Navigator.of(context).pushNamed(
          '/search-results',
          arguments: {
            'filter': SearchFilter(
              governorateId: governorate.id,
              skipCount: 0,
              maxResultCount: 20,
            ),
          },
        );
      } catch (fallbackError) {}
    }
  }
}
