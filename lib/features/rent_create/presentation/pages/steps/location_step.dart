import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../theming/colors.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../theming/text_styles.dart';

import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_event.dart';
import '../../bloc/rent_create_state.dart';
import '../map_picker_page.dart';

class LocationStep extends StatefulWidget {
  const LocationStep({super.key});

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  final _addressController = TextEditingController();
  final _streetController = TextEditingController();
  final _landMarkController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _streetController.dispose();
    _landMarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        // Update controllers when form data changes
        if (_addressController.text != (state.formData.address ?? '')) {
          _addressController.text = state.formData.address ?? '';
        }
        if (_streetController.text !=
            (state.formData.streetAndBuildingNumber ?? '')) {
          _streetController.text = state.formData.streetAndBuildingNumber ?? '';
        }
        if (_landMarkController.text != (state.formData.landMark ?? '')) {
          _landMarkController.text = state.formData.landMark ?? '';
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            ),
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
              _buildHeader(context),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 28,
                ),
              ),
              _buildMapSection(context, state),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 32,
                ),
              ),
              _buildLocationForm(context),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 80,
                  tablet: 90,
                  desktop: 100,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: ResponsiveUtils.fontSize(
                context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
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
              'Location',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontSize: ResponsiveUtils.fontSize(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
                fontWeight: FontWeight.w600,
              ),
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
          'Property Location',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontSize: ResponsiveUtils.fontSize(
              context,
              mobile: 24,
              tablet: 26,
              desktop: 28,
            ),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection(BuildContext context, RentCreateState state) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20),
        ),
        border: Border.all(color: AppColors.divider),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: ResponsiveUtils.size(
                      context,
                      mobile: 32,
                      tablet: 36,
                      desktop: 40,
                    ),
                    width: ResponsiveUtils.size(
                      context,
                      mobile: 32,
                      tablet: 36,
                      desktop: 40,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                      color: AppColors.primary.withValues(alpha: 0.08),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: ResponsiveUtils.fontSize(
                        context,
                        mobile: 18,
                        tablet: 20,
                        desktop: 22,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveUtils.spacing(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 14,
                    ),
                  ),
                  Text(
                    'Property Location',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.read<RentCreateBloc>().add(
                    const ClearLocationEvent(),
                  );
                  _addressController.clear();
                  _streetController.clear();
                  _landMarkController.clear();
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  textStyle: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Clear'),
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 17,
              desktop: 18,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final formState = context.read<RentCreateBloc>().state;
              final initLat = formState.formData.latitude ?? 33.5138;
              final initLng = formState.formData.longitude ?? 36.2765;
              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MapPickerPage(initialLat: initLat, initialLng: initLng),
                ),
              );

              if (!mounted) return;

              if (result != null) {
                if (!mounted) return;
                context.read<RentCreateBloc>().add(
                  UpdateLocationEvent(result['lat']!, result['lng']!),
                );

                final address = result['address'] as String?;
                if (address != null && address.isNotEmpty) {
                  _addressController.text = address;
                  if (!mounted) return;
                  context.read<RentCreateBloc>().add(
                    UpdateAddressEvent(address),
                  );
                }

                final street = result['street'] as String?;
                if (street != null && street.isNotEmpty) {
                  _streetController.text = street;
                  if (!mounted) return;
                  context.read<RentCreateBloc>().add(UpdateStreetEvent(street));
                }

                final landMark = result['landmark'] as String?;
                if (landMark != null && landMark.isNotEmpty) {
                  _landMarkController.text = landMark;
                  if (!mounted) return;
                  context.read<RentCreateBloc>().add(
                    UpdateLandMarkEvent(landMark),
                  );
                }
              }
            },
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
                  SizedBox(
                    height: ResponsiveUtils.size(
                      context,
                      mobile: 160,
                      tablet: 170,
                      desktop: 180,
                    ),
                    width: double.infinity,
                    child: _buildMiniMapPreview(context, state),
                  ),
                  Positioned(
                    top: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 17,
                      desktop: 18,
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
                          mobile: 12,
                          tablet: 13,
                          desktop: 14,
                        ),
                        vertical: ResponsiveUtils.spacing(
                          context,
                          mobile: 6,
                          tablet: 7,
                          desktop: 8,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.radius(
                            context,
                            mobile: 20,
                            tablet: 21,
                            desktop: 22,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_location_alt,
                            color: AppColors.primary,
                            size: ResponsiveUtils.fontSize(
                              context,
                              mobile: 16,
                              tablet: 17,
                              desktop: 18,
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
                            'Edit',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                mobile: 12,
                                tablet: 13,
                                desktop: 14,
                              ),
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.divider.withValues(alpha: 0.4),
                        ),
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.radius(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 17,
              desktop: 18,
            ),
          ),
          BlocBuilder<RentCreateBloc, RentCreateState>(
            builder: (context, blocState) {
              final address = blocState.formData.address;
              final street = blocState.formData.streetAndBuildingNumber;
              final landMark = blocState.formData.landMark;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (address != null && address.isNotEmpty)
                    Text(
                      address,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          mobile: 14,
                          tablet: 15,
                          desktop: 16,
                        ),
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
                  Text(
                    [street, landMark]
                        .where((value) => value != null && value.isNotEmpty)
                        .join(' • '),
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 12,
                        tablet: 13,
                        desktop: 14,
                      ),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMapPreview(BuildContext context, RentCreateState state) {
    final latitude = state.formData.latitude;
    final longitude = state.formData.longitude;

    if (latitude == null || longitude == null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.primary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Map-like grid pattern
            Positioned.fill(child: CustomPaint(painter: _MapGridPainter())),
            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: ResponsiveUtils.fontSize(
                        context,
                        mobile: 40,
                        tablet: 44,
                        desktop: 48,
                      ),
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
                    'Location Required *',
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
                      mobile: 6,
                      tablet: 7,
                      desktop: 8,
                    ),
                  ),
                  Text(
                    'Tap to select location on map',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 13,
                        tablet: 14,
                        desktop: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return IgnorePointer(
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latitude, longitude),
          initialZoom: 15,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.none,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.ahlanfeekum.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(latitude, longitude),
                width: ResponsiveUtils.size(
                  context,
                  mobile: 48,
                  tablet: 52,
                  desktop: 56,
                ),
                height: ResponsiveUtils.size(
                  context,
                  mobile: 48,
                  tablet: 52,
                  desktop: 56,
                ),
                child: Icon(
                  Icons.location_on,
                  size: ResponsiveUtils.fontSize(
                    context,
                    mobile: 36,
                    tablet: 38,
                    desktop: 40,
                  ),
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationForm(BuildContext context) {
    // Use responsive layout - 2 columns on desktop for compact view
    if (ResponsiveUtils.isDesktop(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address takes full width
          _buildTextField(
            context,
            controller: _addressController,
            label: 'Address',
            hintText: 'Damascus, Al Qusor',
            onChanged: (value) {
              context.read<RentCreateBloc>().add(UpdateAddressEvent(value));
            },
          ),
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 17,
              desktop: 18,
            ),
          ),
          // Street and Landmark in 2 columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  context,
                  controller: _streetController,
                  label: 'Street, Building Number',
                  hintText: 'Street 123',
                  onChanged: (value) {
                    context.read<RentCreateBloc>().add(
                      UpdateStreetEvent(value),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  context,
                  controller: _landMarkController,
                  label: 'Land Mark',
                  hintText: 'Away From \'place\' 2 Km',
                  onChanged: (value) {
                    context.read<RentCreateBloc>().add(
                      UpdateLandMarkEvent(value),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Mobile/Tablet: Traditional single column
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          context,
          controller: _addressController,
          label: 'Address',
          hintText: 'Damascus, Al Qusor',
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateAddressEvent(value));
          },
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 16,
            tablet: 17,
            desktop: 18,
          ),
        ),
        _buildTextField(
          context,
          controller: _streetController,
          label: 'Street, Building Number',
          hintText: 'Street 123',
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateStreetEvent(value));
          },
        ),
        SizedBox(
          height: ResponsiveUtils.spacing(
            context,
            mobile: 16,
            tablet: 17,
            desktop: 18,
          ),
        ),
        _buildTextField(
          context,
          controller: _landMarkController,
          label: 'Land Mark',
          hintText: 'Away From \'place\' 2 Km',
          onChanged: (value) {
            context.read<RentCreateBloc>().add(UpdateLandMarkEvent(value));
          },
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hintText,
    required Function(String) onChanged,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveUtils.fontSize(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]
                : null,
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
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[400],
              fontSize: ResponsiveUtils.fontSize(
                context,
                mobile: 14,
                tablet: 15,
                desktop: 16,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.radius(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.radius(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.radius(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 17,
                desktop: 18,
              ),
              vertical: ResponsiveUtils.spacing(
                context,
                mobile: 12,
                tablet: 13,
                desktop: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for map-like grid pattern
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    const gridSpacing = 40.0;
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw some decorative "roads" (thicker lines)
    final roadPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.12)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Diagonal road 1
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint,
    );

    // Diagonal road 2
    canvas.drawLine(
      Offset(size.width * 0.6, 0),
      Offset(size.width * 0.6, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
