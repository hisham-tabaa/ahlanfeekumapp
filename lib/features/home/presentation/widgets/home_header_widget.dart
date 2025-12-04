import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/web_compatible_network_image.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../domain/entities/home_entities.dart';

class HomeHeaderWidget extends StatelessWidget {
  final UserProfile? userProfile;

  const HomeHeaderWidget({super.key, this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Container(
          constraints: BoxConstraints(
            minHeight: ResponsiveUtils.size(
              context,
              mobile: 140,
              tablet: 160,
              desktop: 180,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                mobile: 20,
                tablet: 32,
                desktop: 40,
              ),
              vertical: ResponsiveUtils.spacing(
                context,
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top row with logo and profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // App Logo
                    SizedBox(
                      width: ResponsiveUtils.size(
                        context,
                        mobile: 120,
                        tablet: 150,
                        desktop: 180,
                      ),
                      height: ResponsiveUtils.size(
                        context,
                        mobile: 60,
                        tablet: 75,
                        desktop: 90,
                      ),
                      child: Image.asset(
                        'assets/images/home_icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Profile Picture
                    GestureDetector(
                      onTap: () {
                        // Navigate to profile settings
                        Navigator.pushNamed(context, '/main-navigation');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: ResponsiveUtils.size(
                            context,
                            mobile: 18,
                            tablet: 22,
                            desktop: 26,
                          ),
                          backgroundColor: Colors.white,
                          child: userProfile?.profilePhotoUrl != null
                              ? ClipOval(
                                  child: WebCompatibleNetworkImage(
                                    imageUrl: userProfile!.profilePhotoUrl!,
                                    width: ResponsiveUtils.size(
                                      context,
                                      mobile: 36,
                                      tablet: 44,
                                      desktop: 52,
                                    ),
                                    height: ResponsiveUtils.size(
                                      context,
                                      mobile: 36,
                                      tablet: 44,
                                      desktop: 52,
                                    ),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => SizedBox(
                                      width: ResponsiveUtils.size(
                                        context,
                                        mobile: 36,
                                        tablet: 44,
                                        desktop: 52,
                                      ),
                                      height: ResponsiveUtils.size(
                                        context,
                                        mobile: 36,
                                        tablet: 44,
                                        desktop: 52,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.primary,
                                              ),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) {
                                      return Icon(
                                        Icons.person,
                                        color: AppColors.primary,
                                        size: ResponsiveUtils.size(
                                          context,
                                          mobile: 20,
                                          tablet: 24,
                                          desktop: 28,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: ResponsiveUtils.size(
                                    context,
                                    mobile: 20,
                                    tablet: 24,
                                    desktop: 28,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 20,
                    desktop: 24,
                  ),
                ),

                // Search Bar
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  child: Container(
                    height: ResponsiveUtils.size(
                      context,
                      mobile: 48,
                      tablet: 52,
                      desktop: 56,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                      vertical: ResponsiveUtils.spacing(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                      border: Border.all(color: Colors.grey[200]!, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey[500],
                          size: ResponsiveUtils.size(
                            context,
                            mobile: 20,
                            tablet: 22,
                            desktop: 24,
                          ),
                        ),
                        SizedBox(
                          width: ResponsiveUtils.spacing(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 16,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Search for properties...',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.grey[500],
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                mobile: 14,
                                tablet: 15,
                                desktop: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
