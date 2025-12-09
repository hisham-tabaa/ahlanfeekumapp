import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../theming/colors.dart';
import '../../../../../core/utils/responsive_utils.dart';
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
                // Use web-compatible image loading
                if (kIsWeb && index < imageFiles.length) {
                  return Image.network(
                    imageFiles[index].path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to file if network fails
                      return Image.file(
                        images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  );
                } else {
                  return Image.file(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                }
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
                  'View ${_currentImageIndex + 1} Image',
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
      state.formData.propertyTitle ?? 'Property Title Not Set',
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
            'Main Details',
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
            'Price',
            '${state.formData.pricePerNight ?? 0} \$ / Night',
          ),
          _buildDetailRow(
            context,
            'Property Type',
            state.formData.propertyTypeName ?? 'Not Set',
          ),
          _buildDetailRow(
            context,
            'Bedrooms',
            '${state.formData.bedrooms} Bedrooms',
          ),
          _buildDetailRow(
            context,
            'Living Rooms',
            '${state.formData.livingRooms} Rooms',
          ),
          _buildDetailRow(
            context,
            'Bathrooms',
            '${state.formData.bathrooms} Bathrooms',
          ),
          _buildDetailRow(
            context,
            'Number Of Beds',
            '${state.formData.numberOfBeds} Beds',
          ),
          _buildDetailRow(
            context,
            'Maximum Guests',
            '${state.formData.maximumNumberOfGuests} Guests',
          ),
          _buildDetailRow(
            context,
            'Floor',
            '${state.formData.floor}${_getFloorSuffix(state.formData.floor)} Floor',
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
            'Property Description',
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
                : 'No description provided',
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
          'Property Features',
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
          'Property Location',
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
                        title: 'Property Location',
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
                color: AppColors.primary.withValues(alpha: 
                  hasValidLocation ? 0.3 : 0.2,
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
                                      : 'Property Location',
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
                                      'Tap to view full map',
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
                            'Location not available',
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
            'House Rules',
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
          _buildRuleItem(context, 'Check In After 3:00 PM'),
          _buildRuleItem(context, 'Check Out Before 12:00 AM'),
          _buildRuleItem(context, 'Minimum Age To Rent : 18'),
          _buildRuleItem(context, 'No Pets Allowed'),
          _buildRuleItem(context, 'Smoking Is Not Permitted'),
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
              'Additional Rules:',
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
      title: 'Cancellation Policy',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Refund',
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
            'A Policy Of No Refund And Cancel Your Booking You Will Not Get A Refund Or Credit For Future Stay.',
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
      title: 'Important To Read',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You Need To Know',
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
                : 'No additional information provided.',
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
