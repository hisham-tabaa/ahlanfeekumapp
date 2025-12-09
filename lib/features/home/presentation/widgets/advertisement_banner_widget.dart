import 'package:flutter/material.dart';
import '../../domain/entities/home_entities.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/web_compatible_network_image.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class AdvertisementBannerWidget extends StatefulWidget {
  final List<SpecialAdvertisement> ads;

  const AdvertisementBannerWidget({super.key, required this.ads});

  @override
  State<AdvertisementBannerWidget> createState() =>
      _AdvertisementBannerWidgetState();
}

class _AdvertisementBannerWidgetState extends State<AdvertisementBannerWidget> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.ads.isEmpty) return const SizedBox.shrink();

    return Container(
      height: ResponsiveUtils.size(
        context,
        mobile: 160,
        tablet: 200,
        desktop: 240,
      ),
      margin: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.spacing(
          context,
          mobile: 8,
          tablet: 12,
          desktop: 16,
        ),
        horizontal: ResponsiveUtils.spacing(
          context,
          mobile: 16,
          tablet: 24,
          desktop: 32,
        ),
      ),
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: widget.ads.length,
            itemBuilder: (context, index) {
              final ad = widget.ads[index];
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    mobile: 4,
                    tablet: 6,
                    desktop: 8,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.radius(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.radius(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background Image
                      WebCompatibleNetworkImage(
                        imageUrl: ad.imageUrl,
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
                        errorWidget: (context, url, error) {
                          return Container(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            child: Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: AppColors.primary,
                                size: ResponsiveUtils.size(
                                  context,
                                  mobile: 50,
                                  tablet: 60,
                                  desktop: 70,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),

                      // Content
                      Positioned(
                        bottom: ResponsiveUtils.spacing(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 28,
                        ),
                        left: ResponsiveUtils.spacing(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 28,
                        ),
                        right: ResponsiveUtils.spacing(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 28,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ad.propertyTitle.isNotEmpty
                                  ? ad.propertyTitle
                                  : 'Special\nAdvertisement Goes\nHere',
                              style: AppTextStyles.h4.copyWith(
                                color: Colors.white,
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 18,
                                  tablet: 20,
                                  desktop: 22,
                                ),
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 12,
              desktop: 16,
            ),
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.ads.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.spacing(
                      context,
                      mobile: 3,
                      tablet: 4,
                      desktop: 5,
                    ),
                  ),
                  width: _currentPage == i
                      ? ResponsiveUtils.size(
                          context,
                          mobile: 18,
                          tablet: 20,
                          desktop: 22,
                        )
                      : ResponsiveUtils.size(
                          context,
                          mobile: 6,
                          tablet: 7,
                          desktop: 8,
                        ),
                  height: ResponsiveUtils.size(
                    context,
                    mobile: 6,
                    tablet: 7,
                    desktop: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.radius(
                        context,
                        mobile: 4,
                        tablet: 5,
                        desktop: 6,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
