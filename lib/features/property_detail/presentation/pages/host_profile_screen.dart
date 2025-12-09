import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/web_scroll_behavior.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../domain/entities/host_profile.dart';
import '../bloc/host_profile_bloc.dart';
import '../bloc/host_profile_event.dart';
import '../bloc/host_profile_state.dart';

class HostProfileScreen extends StatefulWidget {
  final String hostId;
  final String? hostName;

  const HostProfileScreen({super.key, required this.hostId, this.hostName});

  @override
  State<HostProfileScreen> createState() => _HostProfileScreenState();
}

class _HostProfileScreenState extends State<HostProfileScreen> {
  Locale? _previousLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = context.locale;
    if (_previousLocale != null && _previousLocale != currentLocale) {
      setState(() {
        _previousLocale = currentLocale;
      });
    } else {
      _previousLocale = currentLocale;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<HostProfileBloc>()..add(LoadHostProfile(widget.hostId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'host_profile'.tr(),
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.outlined_flag, color: AppColors.error),
              onPressed: () {
              },
            ),
          ],
        ),
        body: BlocBuilder<HostProfileBloc, HostProfileState>(
          builder: (context, state) {
            if (state is HostProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HostProfileError) {
              return _buildErrorState(context, state.message);
            } else if (state is HostProfileLoaded) {
              return _buildContent(context, state.hostProfile);
            }
            return Center(child: Text('no_data_available'.tr()));
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: ResponsiveUtils.fontSize(
              context,
              mobile: 48,
              tablet: 52,
              desktop: 56,
            ),
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
            errorMessage,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
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
          ElevatedButton(
            onPressed: () {
              context.read<HostProfileBloc>().add(LoadHostProfile(widget.hostId));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('retry'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, HostProfile profile) {
    return ResponsiveLayout(
      maxWidth: 900,
      centerContent: true,
      child: WebScrollUtils.customScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getHorizontalPadding(context),
                vertical: ResponsiveUtils.spacing(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGetToKnowSection(context, profile),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 24,
                      tablet: 28,
                      desktop: 32,
                    ),
                  ),
                  _buildDetailsSection(context, profile),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 24,
                      tablet: 28,
                      desktop: 32,
                    ),
                  ),
                  _buildAdvertisementsSection(context, profile),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 80,
                      tablet: 100,
                      desktop: 120,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetToKnowSection(BuildContext context, HostProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'get_to_know_your_host'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile photo
            CircleAvatar(
              radius: ResponsiveUtils.radius(
                context,
                mobile: 30,
                tablet: 34,
                desktop: 38,
              ),
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundImage: profile.profilePhotoUrl != null
                  ? CachedNetworkImageProvider(profile.profilePhotoUrl!)
                  : null,
              child: profile.profilePhotoUrl == null
                  ? Icon(
                      Icons.person,
                      size: ResponsiveUtils.fontSize(
                        context,
                        mobile: 30,
                        tablet: 34,
                        desktop: 38,
                      ),
                      color: AppColors.primary,
                    )
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name ?? 'unknown_host'.tr(),
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
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
                  Text(
                    'property_posted_count'.tr().replaceAll('{0}', profile.properties.length.toString()),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (profile.isSuperHost)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                  vertical: ResponsiveUtils.spacing(
                    context,
                    mobile: 4,
                    tablet: 5,
                    desktop: 6,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified,
                      size: ResponsiveUtils.fontSize(
                        context,
                        mobile: 14,
                        tablet: 16,
                        desktop: 18,
                      ),
                      color: Colors.green,
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
                      'super_host'.tr(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        Text(
          'platform_description'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(BuildContext context, HostProfile profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'email_address'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
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
              Text(
                'owner_of'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                profile.email ?? 'Example@Gmail.Com',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
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
              Text(
                'apartments'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvertisementsSection(
    BuildContext context,
    HostProfile profile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'all_advertisements'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
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
        if (profile.properties.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
              ),
              child: Text(
                'no_properties_available'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveUtils.getGridColumnCount(
                context,
                mobile: 2, // 2 columns on mobile (was 3)
                tablet: 3,
                desktop: 4,
              ),
              crossAxisSpacing: ResponsiveUtils.spacing(
                context,
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
              mainAxisSpacing: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 20,
                desktop: 24,
              ),
              childAspectRatio:
                  0.68, // Width to height ratio for better cards (taller)
            ),
            itemCount: profile.properties.length,
            itemBuilder: (context, index) {
              final property = profile.properties[index];
              return _buildPropertyCard(context, property);
            },
          ),
      ],
    );
  }

  Widget _buildPropertyCard(BuildContext context, HostProperty property) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/property-detail',
          arguments: property.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container with aspect ratio
            AspectRatio(
              aspectRatio: 1.3, // Optimized for card layout
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                      ),
                      topRight: Radius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                      ),
                    ),
                    child: property.mainImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: property.mainImageUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[500],
                                size: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 40,
                                  tablet: 48,
                                  desktop: 56,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[500],
                              size: ResponsiveUtils.fontSize(
                                context,
                                mobile: 40,
                                tablet: 48,
                                desktop: 56,
                              ),
                            ),
                          ),
                  ),
                  // Rating badge at bottom left
                  Positioned(
                    bottom: ResponsiveUtils.spacing(
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
                          mobile: 8,
                          tablet: 10,
                          desktop: 12,
                        ),
                        vertical: ResponsiveUtils.spacing(
                          context,
                          mobile: 4,
                          tablet: 5,
                          desktop: 6,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: ResponsiveUtils.fontSize(
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
                          Text(
                            property.averageRating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Favorite button on top right
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
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        property.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: property.isFavorite
                            ? AppColors.error
                            : Colors.grey[600],
                        size: ResponsiveUtils.fontSize(
                          context,
                          mobile: 18,
                          tablet: 20,
                          desktop: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Property details below image
            Padding(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 10,
                  tablet: 12,
                  desktop: 14,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    property.title ?? 'untitled_property'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 13,
                        tablet: 14,
                        desktop: 15,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 6,
                      tablet: 8,
                      desktop: 10,
                    ),
                  ),
                  // Price
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: ResponsiveUtils.fontSize(
                          context,
                          mobile: 13,
                          tablet: 15,
                          desktop: 17,
                        ),
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(
                        width: ResponsiveUtils.spacing(
                          context,
                          mobile: 2,
                          tablet: 3,
                          desktop: 4,
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${property.pricePerNight.toStringAsFixed(0)} \$',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 14,
                                  tablet: 16,
                                  desktop: 18,
                                ),
                              ),
                            ),
                            Text(
                              ' /${'night'.tr()}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  mobile: 11,
                                  tablet: 12,
                                  desktop: 13,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
