// ignore_for_file: unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/web_scroll_behavior.dart';
import '../../../../core/widgets/map_viewer_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/auth_options_screen.dart';
import '../../domain/entities/property_detail.dart';
import '../../data/models/reservation_request.dart';
import '../../data/datasources/property_detail_remote_data_source.dart';
import '../../../../core/di/injection.dart';
import '../bloc/property_detail_bloc.dart';
import '../bloc/property_detail_event.dart';
import '../bloc/property_detail_state.dart';
import '../widgets/booking_bottom_sheet_with_availability.dart';
import '../widgets/property_rating_dialog.dart';
import '../widgets/property_header_widget.dart';
import '../widgets/property_main_details_widget.dart';
import '../widgets/property_features_widget.dart';
import '../../../payment/presentation/pages/payment_method_selection_screen.dart';
import '../../../payment/presentation/pages/card_payment_screen.dart';
import 'host_profile_screen.dart';

class PropertyDetailScreen extends StatelessWidget {
  const PropertyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PropertyDetailView();
  }
}

class _PropertyDetailView extends StatefulWidget {
  const _PropertyDetailView();

  @override
  State<_PropertyDetailView> createState() => _PropertyDetailViewState();
}

class _PropertyDetailViewState extends State<_PropertyDetailView> {
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
    // Reference locale to ensure widget rebuilds when language changes
    context.locale;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<PropertyDetailBloc, PropertyDetailState>(
          builder: (context, state) {
            if (state.isLoading && state.propertyDetail == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.propertyDetail == null) {
              return _buildErrorState(context, state.errorMessage!);
            }

            final property = state.propertyDetail;
            if (property == null) {
              return _buildErrorState(context, 'property_details_not_found'.tr());
            }

            return Stack(
              children: [
                Positioned.fill(
                  child: ResponsiveLayout(
                    maxWidth: 900,
                    centerContent: true,
                    child: WebScrollUtils.customScrollView(
                      slivers: [
                        _buildSliverAppBar(property, context),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.getHorizontalPadding(
                                context,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 16,
                                    tablet: 18,
                                    desktop: 20,
                                  ),
                                ),
                                PropertyHeaderWidget(
                                  property: property,
                                  onSignInPrompt: () => _showSignInPrompt(
                                    context,
                                    'save_to_favorites'.tr(),
                                  ),
                                ),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 24,
                                    tablet: 28,
                                    desktop: 32,
                                  ),
                                ),
                                PropertyMainDetailsWidget(property: property),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 24,
                                    tablet: 28,
                                    desktop: 32,
                                  ),
                                ),
                                PropertyFeaturesWidget(
                                  features: property.features,
                                ),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 24,
                                    tablet: 28,
                                    desktop: 32,
                                  ),
                                ),
                                _buildLocationSection(property, context),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 24,
                                    tablet: 28,
                                    desktop: 32,
                                  ),
                                ),
                                _buildRatesSection(property, context),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 24,
                                    tablet: 28,
                                    desktop: 32,
                                  ),
                                ),
                                _buildReviewsSection(
                                  property.evaluations,
                                  context,
                                ),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 24,
                                    tablet: 28,
                                    desktop: 32,
                                  ),
                                ),
                                _buildHouseRulesSection(property, context),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 24,
                                    tablet: 28,
                                    desktop: 32,
                                  ),
                                ),
                                _buildImportantInfoSection(property, context),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 24,
                                    tablet: 28,
                                    desktop: 32,
                                  ),
                                ),
                                _buildHostSection(property, context),
                                SizedBox(
                                  height: ResponsiveUtils.spacing(
                                    context,
                                    mobile: 120,
                                    tablet: 140,
                                    desktop: 160,
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
                _buildBottomBar(context, property),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
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
            message,
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
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('go_back'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(PropertyDetail property, BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: ResponsiveUtils.size(
        context,
        mobile: 320,
        tablet: 380,
        desktop: 440,
      ),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildImageCarousel(property, context),
      ),
    );
  }

  Widget _buildImageCarousel(PropertyDetail property, BuildContext context) {
    final media = property.media;
    final images = media.isNotEmpty
        ? media
        : [
            PropertyMedia(
              id: 'main',
              imageUrl: property.mainImageUrl,
              order: 0,
              isActive: true,
            ),
          ];

    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        final item = images[index];
        final imageUrl = item.imageUrl ?? property.mainImageUrl;
        return Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.border,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.border,
                child: Icon(
                  Icons.photo,
                  size: ResponsiveUtils.fontSize(
                    context,
                    mobile: 48,
                    tablet: 52,
                    desktop: 56,
                  ),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              left: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Positioned(
              bottom: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (dotIndex) => Container(
                    width: dotIndex == index
                        ? ResponsiveUtils.size(
                            context,
                            mobile: 24,
                            tablet: 28,
                            desktop: 32,
                          )
                        : ResponsiveUtils.size(
                            context,
                            mobile: 8,
                            tablet: 10,
                            desktop: 12,
                          ),
                    height: ResponsiveUtils.size(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        mobile: 4,
                        tablet: 5,
                        desktop: 6,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: dotIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderSection(PropertyDetail property, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  mobile: 10,
                  tablet: 12,
                  desktop: 14,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  mobile: 4,
                  tablet: 5,
                  desktop: 6,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
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
                children: [
                  Icon(
                    Icons.star,
                    size: ResponsiveUtils.fontSize(
                      context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                    color: AppColors.primary,
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
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
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
                    property.averageRating > 4.5 ? 'great'.tr() : 'good'.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return IconButton(
                  onPressed: () {
                    if (authState is AuthGuest) {
                      _showSignInPrompt(context, 'save_to_favorites'.tr());
                    } else {
                      context.read<PropertyDetailBloc>().add(
                        ToggleFavoriteEvent(
                          propertyId: property.id,
                          isFavorite: property.isFavorite,
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    property.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: property.isFavorite ? Colors.red : AppColors.primary,
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () {
                SharePlus.instance.share(
                  ShareParams(
                    text:
                        'Check out this amazing property: ${property.title}\n\nLocation: ${property.address}\n\nPrice: ${property.pricePerNight.toStringAsFixed(0)} \$ per night\n\nBedrooms: ${property.bedrooms} | Bathrooms: ${property.bathrooms}',
                    subject: property.title,
                  ),
                );
              },
              icon: Icon(Icons.share_outlined, color: AppColors.textPrimary),
            ),
          ],
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
          property.title,
          style: AppTextStyles.h2.copyWith(
            fontSize: ResponsiveUtils.fontSize(
              context,
              mobile: 22,
              tablet: 24,
              desktop: 26,
            ),
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: AppColors.textSecondary,
              size: ResponsiveUtils.fontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
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
                property.address ?? 'address_not_provided'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainDetailsSection(
    PropertyDetail property,
    BuildContext context,
  ) {
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
            'price'.tr(),
            '${property.pricePerNight.toStringAsFixed(0)} ${'currency_symbol'.tr()} / ${'night'.tr()}',
            context,
          ),
          _buildDetailRow('property_type'.tr(), property.propertyTypeName, context),
          _buildDetailRow('bedrooms'.tr(), '${property.bedrooms} ${'bedrooms'.tr()}', context),
          _buildDetailRow(
            'living_rooms'.tr(),
            '${property.livingrooms} ${'rooms'.tr()}',
            context,
          ),
          _buildDetailRow(
            'bathrooms'.tr(),
            '${property.bathrooms} ${'bathrooms'.tr()}',
            context,
          ),
          _buildDetailRow(
            'number_of_beds'.tr(),
            '${property.numberOfBeds} ${'beds'.tr()}',
            context,
          ),
          _buildDetailRow(
            'maximum_guests'.tr(),
            '${property.maxGuests} ${'guests'.tr()}',
            context,
          ),
          _buildDetailRow('floor'.tr(), '${property.floor} ${'floor'.tr()}', context),
          _buildDetailRow('posted_by'.tr(), property.ownerName, context),
          _buildDetailRow('governorate'.tr(), property.governorateName, context),
          if (property.area != null)
            _buildDetailRow(
              'area'.tr(),
              '${property.area!.toStringAsFixed(0)} ${'square_meters'.tr()}',
              context,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
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

  Widget _buildFeaturesSection(
    List<PropertyFeature> features,
    BuildContext context,
  ) {
    if (features.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'property_features'.tr(),
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
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
        Wrap(
          spacing: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
          runSpacing: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
          children: features.map((feature) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  mobile: 8,
                  tablet: 10,
                  desktop: 12,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: ResponsiveUtils.fontSize(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    color: AppColors.primary,
                  ),
                  SizedBox(
                    width: ResponsiveUtils.spacing(
                      context,
                      mobile: 6,
                      tablet: 7,
                      desktop: 8,
                    ),
                  ),
                  Text(
                    feature.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationSection(PropertyDetail property, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'property_location'.tr(),
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
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
        GestureDetector(
          onTap: () => _openLocationInMaps(context, property),
          child: Container(
            height: ResponsiveUtils.size(
              context,
              mobile: 180,
              tablet: 200,
              desktop: 220,
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
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
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
                  // Mini Map Preview
                  AbsorbPointer(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          double.tryParse(property.latitude ?? '0') ?? 0.0,
                          double.tryParse(property.longitude ?? '0') ?? 0.0,
                        ),
                        initialZoom: 14.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.ahlanfeekum.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                double.tryParse(property.latitude ?? '0') ??
                                    0.0,
                                double.tryParse(property.longitude ?? '0') ??
                                    0.0,
                              ),
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Bottom Overlay with Address
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            property.address ?? 'location_not_available'.tr(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.touch_app,
                                size: 14,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'tap_to_view_full_map'.tr(),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white70,
                                  fontSize: 12,
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
          ),
        ),
        if (property.landMark != null && property.landMark!.isNotEmpty) ...[
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 10,
              desktop: 12,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.place,
                size: ResponsiveUtils.fontSize(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
                color: AppColors.textSecondary,
              ),
              SizedBox(
                width: ResponsiveUtils.spacing(
                  context,
                  mobile: 6,
                  tablet: 7,
                  desktop: 8,
                ),
              ),
              Expanded(
                child: Text(
                  '${'landmark'.tr()}: ${property.landMark}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _openLocationInMaps(BuildContext context, PropertyDetail property) {
    // Parse latitude and longitude from strings
    final lat = double.tryParse(property.latitude ?? '') ?? 0.0;
    final lng = double.tryParse(property.longitude ?? '') ?? 0.0;

    if (lat == 0.0 || lng == 0.0) {
      // Show error message if coordinates are not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('location_coordinates_not_available'.tr()),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Navigate to in-app map viewer
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapViewerPage(
          latitude: lat,
          longitude: lng,
          address: property.address,
          title: property.title,
        ),
      ),
    );
  }

  Widget _buildRatesSection(PropertyDetail property, BuildContext context) {
    final ratings = [
      _RatingItem(title: 'cleanliness'.tr(), value: property.averageCleanliness),
      _RatingItem(title: 'price_value'.tr(), value: property.averagePriceAndValue),
      _RatingItem(title: 'location'.tr(), value: property.averageLocation),
      _RatingItem(title: 'accuracy'.tr(), value: property.averageAccuracy),
      _RatingItem(title: 'attitude'.tr(), value: property.averageAttitude),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'rates_reviews'.tr(),
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
        Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
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
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    property.averageRating.toStringAsFixed(1),
                    style: AppTextStyles.h2.copyWith(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 32,
                        tablet: 36,
                        desktop: 40,
                      ),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => Padding(
                            padding: EdgeInsets.only(
                              right: ResponsiveUtils.spacing(
                                context,
                                mobile: 2,
                                tablet: 3,
                                desktop: 4,
                              ),
                            ),
                            child: Icon(
                              index < property.averageRating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: ResponsiveUtils.fontSize(
                                context,
                                mobile: 18,
                                tablet: 20,
                                desktop: 22,
                              ),
                            ),
                          ),
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
                        '${'based_on'.tr()} ${property.evaluations.length} ${property.evaluations.length == 1 ? 'review'.tr() : 'reviews'.tr()}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 12,
                            tablet: 13,
                            desktop: 14,
                          ),
                        ),
                      ),
                    ],
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
              Wrap(
                spacing: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
                runSpacing: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
                children: ratings
                    .map(
                      (rating) => _RatingChip(
                        title: rating.title,
                        value: rating.value,
                        context: context,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(
    List<PropertyEvaluation> evaluations,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'all_reviews'.tr(),
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    return TextButton.icon(
                      onPressed: () {
                    if (authState is AuthGuest) {
                      _showSignInPrompt(context, 'rate_property'.tr());
                    } else {
                          final currentState = context
                              .read<PropertyDetailBloc>()
                              .state;
                          if (currentState.propertyDetail != null) {
                            _showRatingDialog(
                              context,
                              currentState.propertyDetail!.id,
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.star_border, size: 18),
                      label: Text('rate'.tr()),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),
                TextButton(onPressed: () {}, child: Text('show_all'.tr())),
              ],
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
        Column(
          children: evaluations.take(3).map((evaluation) {
            return Container(
              margin: EdgeInsets.only(
                bottom: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 14,
                    tablet: 16,
                    desktop: 18,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Icon(Icons.person, color: AppColors.primary),
                      ),
                      SizedBox(
                        width: ResponsiveUtils.spacing(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            evaluation.userProfileName,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                mobile: 14,
                                tablet: 15,
                                desktop: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 6,
                              tablet: 7,
                              desktop: 8,
                            ),
                          ),
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (index) => Padding(
                                  padding: EdgeInsets.only(
                                    right: ResponsiveUtils.spacing(
                                      context,
                                      mobile: 2,
                                      tablet: 3,
                                      desktop: 4,
                                    ),
                                  ),
                                  child: Icon(
                                    index < evaluation.cleanliness.round()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: ResponsiveUtils.fontSize(
                                      context,
                                      mobile: 14,
                                      tablet: 16,
                                      desktop: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveUtils.spacing(
                                  context,
                                  mobile: 6,
                                  tablet: 7,
                                  desktop: 8,
                                ),
                              ),
                              Text(
                                evaluation.cleanliness.toStringAsFixed(1),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: ResponsiveUtils.fontSize(
                                    context,
                                    mobile: 12,
                                    tablet: 13,
                                    desktop: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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
                    evaluation.comment ?? '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHouseRulesSection(
    PropertyDetail property,
    BuildContext context,
  ) {
    final rules = property.houseRules.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'house_rules'.tr(),
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
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
        ...rules.map(
          (rule) => Padding(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.spacing(
                context,
                mobile: 4,
                tablet: 5,
                desktop: 6,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: ResponsiveUtils.size(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                  height: ResponsiveUtils.size(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.size(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
                Expanded(
                  child: Text(
                    rule,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImportantInfoSection(
    PropertyDetail property,
    BuildContext context,
  ) {
    final infoItems = property.importantInformation.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'important_to_read'.tr(),
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
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
        ...infoItems.map(
          (info) => Padding(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.spacing(
                context,
                mobile: 4,
                tablet: 5,
                desktop: 6,
              ),
            ),
            child: Text(
              info,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHostSection(PropertyDetail property, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (property.ownerId != null && property.ownerId!.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HostProfileScreen(
                hostId: property.ownerId!,
                hostName: property.ownerName,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(
          ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
        ),
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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: ResponsiveUtils.radius(
                context,
                mobile: 28,
                tablet: 32,
                desktop: 36,
              ),
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                color: AppColors.primary,
                size: ResponsiveUtils.fontSize(
                  context,
                  mobile: 28,
                  tablet: 32,
                  desktop: 36,
                ),
              ),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.ownerName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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
                  Row(
                    children: [
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
                          color: AppColors.primary.withValues(alpha: 0.1),
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
                          children: [
                            Icon(
                              Icons.verified,
                              size: ResponsiveUtils.fontSize(
                                context,
                                mobile: 14,
                                tablet: 16,
                                desktop: 18,
                              ),
                              color: AppColors.primary,
                            ),
                            SizedBox(
                              width: ResponsiveUtils.spacing(
                                context,
                                mobile: 4,
                                tablet: 5,
                                desktop: 6,
                              ),
                            ),
                            Text('super_host'.tr()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, PropertyDetail property) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: BlocBuilder<PropertyDetailBloc, PropertyDetailState>(
        builder: (context, propertyState) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return BookingBottomSheetWithAvailability(
                pricePerNight: property.pricePerNight,
                propertyId: property.id,
                availabilityData: propertyState.availabilityData,
                onBook: (checkIn, checkOut, guests, notes) async {
                  if (authState is AuthGuest) {
                    _showSignInPrompt(context, 'book_this_property'.tr());
                    return;
                  }

                  // Handle booking with payment
                  await _handleBookingWithPayment(
                    context,
                    property,
                    checkIn,
                    checkOut,
                    guests,
                    notes,
                    authState,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleBookingWithPayment(
    BuildContext context,
    PropertyDetail property,
    DateTime checkIn,
    DateTime checkOut,
    int guests,
    String notes,
    AuthState authState,
  ) async {
    try {
      final totalNights = checkOut.difference(checkIn).inDays;
      final totalAmount = property.pricePerNight * totalNights;
      final totalAmountCents = (totalAmount * 100).toInt();

      String? userEmail;
      String? userName;

      if (authState is AuthAuthenticated) {
        userEmail = authState.user.email;
        userName = authState.user.name;
      }

      // Step 1: Show payment method selection screen
      final selectedPaymentMethod = await Navigator.push<int>(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentMethodSelectionScreen(
            totalAmount: totalAmount,
            currency: 'USD',
            nights: totalNights,
            propertyTitle: property.title,
          ),
        ),
      );

      if (selectedPaymentMethod == null) {
        return; // User cancelled
      }

      if (!context.mounted) return;

      // Step 2: Handle payment based on selected method
      bool paymentSuccess = false;

      if (selectedPaymentMethod == 1) {
        // Card payment via Stripe
        if (userEmail == null || userEmail.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('unable_to_process_payment'.tr()),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => CardPaymentScreen(
              amount: totalAmountCents,
              email: userEmail!,
              name: userName,
            ),
          ),
        );
        paymentSuccess = result == true;
      } else if (selectedPaymentMethod == 2) {
        // Cash payment - no payment processing needed
        paymentSuccess = true;
      }

      if (!paymentSuccess) {
        return;
      }

      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final dataSource = getIt<PropertyDetailRemoteDataSource>();
      final request = CreateReservationRequest(
        fromDate: checkIn.toIso8601String().split('T')[0],
        toDate: checkOut.toIso8601String().split('T')[0],
        numberOfGuests: guests,
        notes: notes,
        sitePropertyId: property.id,
        paymentMethod: selectedPaymentMethod, // 1 = Card, 2 = Cash
      );

      await dataSource.createReservation(request);

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // **IMPORTANT: Refresh availability data after successful booking**
        // This ensures other users can't book the same dates (prevents double-booking)
        context.read<PropertyDetailBloc>().add(
          LoadPropertyAvailabilityEvent(property.id),
        );

        // Show beautiful success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Icon with animation
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green.shade400,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Success Title
                  Text(
                    'booking_confirmed'.tr(),
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Success Message based on payment method
                  Text(
                    selectedPaymentMethod == 1
                        ? 'booking_confirmed_card'.tr()
                        : 'booking_confirmed_cash'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Booking Details Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${'check_in'.tr()}: ${checkIn.toString().split(' ')[0]}',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${'check_out'.tr()}: ${checkOut.toString().split(' ')[0]}',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$guests ${guests != 1 ? 'guests'.tr() : 'guest'.tr()}',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(
                          context,
                        ).pop(); // Go back to previous screen
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppColors.primary),
                      ),
                      child: Text(
                        'view_reservations'.tr(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('booking_failed'.tr()),
            content: Text('${'failed_create_reservation'.tr()}: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ok'.tr()),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showSignInPrompt(BuildContext context, String action) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(
          ResponsiveUtils.spacing(context, mobile: 24, tablet: 28, desktop: 32),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
            ),
            topRight: Radius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveUtils.size(
                context,
                mobile: 40,
                tablet: 45,
                desktop: 50,
              ),
              height: ResponsiveUtils.size(
                context,
                mobile: 4,
                tablet: 5,
                desktop: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 2,
                    tablet: 3,
                    desktop: 4,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
            ),
            Icon(
              Icons.login,
              size: ResponsiveUtils.fontSize(
                context,
                mobile: 48,
                tablet: 52,
                desktop: 56,
              ),
              color: AppColors.primary,
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
              'sign_in_required'.tr(),
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
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
              'sign_in_prompt_message'.tr().replaceAll('{0}', action),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 32,
                tablet: 36,
                desktop: 40,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: ResponsiveUtils.size(
                context,
                mobile: 50,
                tablet: 55,
                desktop: 60,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthOptionsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.radius(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                  ),
                ),
                child: Text(
                  'sign_in'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'continue_browsing'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context, String propertyId) {
    showDialog(
      context: context,
      builder: (dialogContext) => PropertyRatingDialog(
        propertyId: propertyId,
        onSubmit: (request) {
          context.read<PropertyDetailBloc>().add(RatePropertyEvent(request));
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }
}

class _RatingItem {
  final String title;
  final double value;

  const _RatingItem({required this.title, required this.value});
}

class _RatingChip extends StatelessWidget {
  final String title;
  final double value;
  final BuildContext context;

  const _RatingChip({
    required this.title,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        ),
        vertical: ResponsiveUtils.spacing(
          context,
          mobile: 10,
          tablet: 12,
          desktop: 14,
        ),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 12, tablet: 14, desktop: 16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toStringAsFixed(1),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(
              context,
              mobile: 6,
              tablet: 7,
              desktop: 8,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
