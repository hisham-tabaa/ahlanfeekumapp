import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../theming/colors.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../core/widgets/platform_image.dart';
import '../../../../../theming/text_styles.dart';
import '../../../../../core/widgets/map_viewer_page.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_state.dart';

class ReviewStep extends StatefulWidget {
  const ReviewStep({super.key});

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSlider(context, state),
              Padding(
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(
                    context,
                    mobile: 20,
                    tablet: 24,
                    desktop: 28,
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
                        desktop: 16, // Reduced for desktop
                      ),
                    ),
                    _buildPropertyTitle(context, state),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 20,
                        tablet: 24,
                        desktop: 20, // Reduced for desktop
                      ),
                    ),

                    // Use responsive layout for desktop
                    if (ResponsiveUtils.isDesktop(context))
                      _buildDesktopLayout(context, state)
                    else
                      _buildMobileLayout(context, state),

                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 120,
                        tablet: 140,
                        desktop: 160,
                      ),
                    ), // Space for floating buttons
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSlider(BuildContext context, RentCreateState state) {
    final images = state.formData.selectedImages;
    final imageFiles = state.formData.selectedImageFiles;
    final sliderHeight = ResponsiveUtils.responsive(
      context,
      mobile: 300.0,
      tablet: 400.0,
      desktop: 400.0, // Reduced from 500 to minimize scrolling
    );

    return SizedBox(
      height: sliderHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // Image PageView
          if (images.isNotEmpty)
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                // Use platform-compatible image loading
                return PlatformImage(
                  file: index < images.length ? images[index] : null,
                  xFile: index < imageFiles.length ? imageFiles[index] : null,
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            )
          else
            Container(
              color: Colors.grey[200],
              child: Center(
                child: Icon(
                  Icons.image,
                  size: ResponsiveUtils.fontSize(
                    context,
                    mobile: 60,
                    tablet: 66,
                    desktop: 72,
                  ),
                  color: Colors.grey[400],
                ),
              ),
            ),

          // Dots indicator
          if (images.length > 1)
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
                  (index) => Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        mobile: 2,
                        tablet: 3,
                        desktop: 4,
                      ),
                    ),
                    width: ResponsiveUtils.size(
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
                      color: index == _currentImageIndex
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

          // Image counter
          if (images.length > 1)
            Positioned(
              bottom: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              right: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 17,
                desktop: 18,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    mobile: 8,
                    tablet: 9,
                    desktop: 10,
                  ),
                  vertical: ResponsiveUtils.spacing(
                    context,
                    mobile: 4,
                    tablet: 5,
                    desktop: 6,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.radius(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 14,
                    ),
                  ),
                ),
                child: Text(
                  '${'view'.tr()} ${_currentImageIndex + 1} ${'image'.tr()}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, RentCreateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainDetailsSection(context, state),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 20, // Reduced for desktop
          ),
        ),
        _buildDetailsSection(context, state),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 20, // Reduced for desktop
          ),
        ),
        _buildPropertyFeaturesSection(context, state),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 20, // Reduced for desktop
          ),
        ),
        _buildLocationSection(context, state),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 20, // Reduced for desktop
          ),
        ),
        _buildHouseRulesSection(context, state),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 20, // Reduced for desktop
          ),
        ),
        _buildCancellationPolicySection(context),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 20, // Reduced for desktop
          ),
        ),
        _buildImportantToReadSection(context, state),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, RentCreateState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainDetailsSection(context, state),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 20, // Reduced for desktop
                ),
              ),
              _buildPropertyFeaturesSection(context, state),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 20, // Reduced for desktop
                ),
              ),
              _buildHouseRulesSection(context, state),
            ],
          ),
        ),
        SizedBox(width: 20), // Reduced from 24 for desktop
        // Right Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailsSection(context, state),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 20, // Reduced for desktop
                ),
              ),
              _buildLocationSection(context, state),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 20, // Reduced for desktop
                ),
              ),
              _buildCancellationPolicySection(context),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 20, // Reduced for desktop
                ),
              ),
              _buildImportantToReadSection(context, state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyTitle(BuildContext context, RentCreateState state) {
    return Text(
      state.formData.propertyTitle ?? 'property_title_not_set'.tr(),
      style: AppTextStyles.h4.copyWith(
        color: AppColors.textPrimary,
        fontSize: ResponsiveUtils.fontSize(
          context,
          mobile: 20,
          tablet: 22,
          desktop: 24,
        ),
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
    );
  }

  Widget _buildMainDetailsSection(BuildContext context, RentCreateState state) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 16, tablet: 17, desktop: 18),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 16, tablet: 17, desktop: 18),
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
            context,
            'price'.tr(),
            '${state.formData.pricePerNight ?? 0} ${'currency_symbol'.tr()} / ${'night'.tr()}',
          ),
          _buildDetailRow(
            context,
            'property_type'.tr(),
            state.formData.propertyTypeName ?? 'not_set'.tr(),
          ),
          _buildDetailRow(
            context,
            'bedrooms'.tr(),
            '${state.formData.bedrooms} ${'bedrooms'.tr()}',
          ),
          _buildDetailRow(
            context,
            'living_rooms'.tr(),
            '${state.formData.livingRooms} ${'rooms'.tr()}',
          ),
          _buildDetailRow(
            context,
            'bathrooms'.tr(),
            '${state.formData.bathrooms} ${'bathrooms'.tr()}',
          ),
          _buildDetailRow(
            context,
            'number_of_beds'.tr(),
            '${state.formData.numberOfBeds} ${'beds'.tr()}',
          ),
          _buildDetailRow(
            context,
            'maximum_guests'.tr(),
            '${state.formData.maximumNumberOfGuests} ${'guests'.tr()}',
          ),
          _buildDetailRow(
            context,
            'floor'.tr(),
            '${state.formData.floor}${_getFloorSuffix(state.formData.floor)} ${'floor'.tr()}',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, RentCreateState state) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 16, tablet: 17, desktop: 18),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 16, tablet: 17, desktop: 18),
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
            'property_description'.tr(),
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
          Text(
            state.formData.propertyDescription?.isNotEmpty == true
                ? state.formData.propertyDescription!
                : 'no_description_provided'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: ResponsiveUtils.fontSize(
                context,
                mobile: 14,
                tablet: 15,
                desktop: 16,
              ),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyFeaturesSection(
    BuildContext context,
    RentCreateState state,
  ) {
    // Get actual user-selected features or show defaults
    final userFeatures = state.formData.selectedFeatures;
    final features = userFeatures.isNotEmpty
        ? userFeatures
        : ['AC', 'Parking', 'Gym', 'Solar Panel'];

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
            tablet: 13,
            desktop: 14,
          ),
        ),
        Wrap(
          spacing: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 13,
            desktop: 14,
          ),
          runSpacing: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 13,
            desktop: 14,
          ),
          children: features.map((feature) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing(
                  context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
                vertical: ResponsiveUtils.spacing(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 12,
                    tablet: 13,
                    desktop: 14,
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
                      tablet: 17,
                      desktop: 18,
                    ),
                    color: AppColors.primary,
                  ),
                  SizedBox(
                    width: ResponsiveUtils.size(
                      context,
                      mobile: 6,
                      tablet: 7,
                      desktop: 8,
                    ),
                  ),
                  Text(
                    feature,
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

  Widget _buildLocationSection(BuildContext context, RentCreateState state) {
    final hasValidLocation =
        state.formData.latitude != null &&
        state.formData.longitude != null &&
        state.formData.latitude != 0.0 &&
        state.formData.longitude != 0.0;

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
            tablet: 13,
            desktop: 14,
          ),
        ),
        GestureDetector(
          onTap: hasValidLocation
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MapViewerPage(
                        latitude: state.formData.latitude!,
                        longitude: state.formData.longitude!,
                        address: state.formData.address,
                        title: 'property_location'.tr(),
                      ),
                    ),
                  );
                }
              : null,
          child: Container(
            height: ResponsiveUtils.size(
              context,
              mobile: 180,
              tablet: 190,
              desktop: 200,
            ),
            decoration: BoxDecoration(
              color: hasValidLocation
                  ? Colors.white
                  : AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.radius(
                  context,
                  mobile: 16,
                  tablet: 17,
                  desktop: 18,
                ),
              ),
              border: Border.all(
                color: AppColors.primary.withValues(
                  alpha: hasValidLocation ? 0.3 : 0.2,
                ),
                width: hasValidLocation ? 2 : 1,
              ),
            ),
            child: hasValidLocation
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.radius(
                        context,
                        mobile: 16,
                        tablet: 17,
                        desktop: 18,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Mini Map Preview
                        AbsorbPointer(
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                state.formData.latitude!,
                                state.formData.longitude!,
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
                                      state.formData.latitude!,
                                      state.formData.longitude!,
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
                                  state.formData.address?.isNotEmpty == true
                                      ? state.formData.address!
                                      : 'property_location'.tr(),
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
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          color: AppColors.textSecondary,
                          size: ResponsiveUtils.size(
                            context,
                            mobile: 40,
                            tablet: 44,
                            desktop: 48,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveUtils.spacing(
                            context,
                            mobile: 8,
                            tablet: 9,
                            desktop: 10,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.spacing(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 20,
                            ),
                          ),
                          child: Text(
                            'location_not_available'.tr(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildHouseRulesSection(BuildContext context, RentCreateState state) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 16, tablet: 17, desktop: 18),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 16, tablet: 17, desktop: 18),
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
            'house_rules'.tr(),
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
          _buildRuleItem(context, 'check_in_after_3pm'.tr()),
          _buildRuleItem(context, 'check_out_before_12am'.tr()),
          _buildRuleItem(context, 'minimum_age_to_rent_18'.tr()),
          _buildRuleItem(context, 'no_pets_allowed'.tr()),
          _buildRuleItem(context, 'smoking_not_permitted'.tr()),
          // Add user's custom house rules if provided
          if (state.formData.houseRules?.isNotEmpty == true) ...[
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
            ),
            Text(
              'additional_rules'.tr(),
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
            ),
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 8,
                tablet: 9,
                desktop: 10,
              ),
            ),
            Text(
              state.formData.houseRules!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRuleItem(BuildContext context, String rule) {
    return Padding(
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
          Icon(
            Icons.check_circle_outline,
            size: ResponsiveUtils.fontSize(
              context,
              mobile: 16,
              tablet: 17,
              desktop: 18,
            ),
            color: AppColors.primary,
          ),
          SizedBox(
            width: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
          ),
          Expanded(
            child: Text(
              rule,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
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
    );
  }

  Widget _buildCancellationPolicySection(BuildContext context) {
    return _buildWhiteSection(
      context,
      title: 'cancellation_policy'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'no_refund'.tr(),
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
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
          ),
          Text(
            'cancellation_policy_description'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: ResponsiveUtils.fontSize(
                context,
                mobile: 14,
                tablet: 15,
                desktop: 16,
              ),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantToReadSection(
    BuildContext context,
    RentCreateState state,
  ) {
    return _buildWhiteSection(
      context,
      title: 'important_to_read'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'you_need_to_know'.tr(),
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
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
          ),
          Text(
            state.formData.importantInformation?.isNotEmpty == true
                ? state.formData.importantInformation!
                : 'no_additional_information_provided'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: ResponsiveUtils.fontSize(
                context,
                mobile: 14,
                tablet: 15,
                desktop: 16,
              ),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 16, tablet: 17, desktop: 18),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 8, tablet: 9, desktop: 10),
        ),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveUtils.fontSize(
                context,
                mobile: 16,
                tablet: 17,
                desktop: 18,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 12,
              tablet: 13,
              desktop: 14,
            ),
          ),
          child,
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

  String _getFloorSuffix(int floor) {
    if (floor == 1) return 'st';
    if (floor == 2) return 'nd';
    if (floor == 3) return 'rd';
    return 'th';
  }
}
