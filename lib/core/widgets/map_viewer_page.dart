import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../theming/colors.dart';
import '../../theming/text_styles.dart';
import '../utils/responsive_utils.dart';

class MapViewerPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String? address;
  final String? title;

  const MapViewerPage({
    super.key,
    required this.latitude,
    required this.longitude,
    this.address,
    this.title,
  });

  @override
  State<MapViewerPage> createState() => _MapViewerPageState();
}

class _MapViewerPageState extends State<MapViewerPage> {
  late final MapController _mapController;
  late LatLng _location;
  Locale? _previousLocale;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _location = LatLng(widget.latitude, widget.longitude);
  }

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? 'property_location'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Map View
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _location,
              initialZoom: 15.0,
              minZoom: 5.0,
              maxZoom: 18.0,
              // Disable interactions if you want it to be completely read-only
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ahlanfeekum.app',
                maxZoom: 19,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _location,
                    width: ResponsiveUtils.size(
                      context,
                      mobile: 40,
                      tablet: 44,
                      desktop: 48,
                    ),
                    height: ResponsiveUtils.size(
                      context,
                      mobile: 40,
                      tablet: 44,
                      desktop: 48,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: ResponsiveUtils.size(
                        context,
                        mobile: 40,
                        tablet: 44,
                        desktop: 48,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Address Info Card at the bottom
          if (widget.address != null && widget.address!.isNotEmpty)
            Positioned(
              bottom: ResponsiveUtils.spacing(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 28,
              ),
              left: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 20,
                desktop: 24,
              ),
              right: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 20,
                desktop: 24,
              ),
              child: Container(
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
                      mobile: 12,
                      tablet: 14,
                      desktop: 16,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.primary,
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
                            mobile: 8,
                            tablet: 9,
                            desktop: 10,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.address!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                mobile: 14,
                                tablet: 15,
                                desktop: 16,
                              ),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
                      'coordinates'.tr().replaceAll('{0}', widget.latitude.toStringAsFixed(6)).replaceAll('{1}', widget.longitude.toStringAsFixed(6)),
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
              ),
            ),

          // Zoom Controls
          Positioned(
            right: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
            top: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
            child: Column(
              children: [
                _buildZoomButton(
                  icon: Icons.add,
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_location, currentZoom + 1);
                  },
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 8,
                    tablet: 9,
                    desktop: 10,
                  ),
                ),
                _buildZoomButton(
                  icon: Icons.remove,
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_location, currentZoom - 1);
                  },
                ),
              ],
            ),
          ),

          // Center on location button
          Positioned(
            right: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
            bottom: widget.address != null && widget.address!.isNotEmpty
                ? ResponsiveUtils.spacing(
                    context,
                    mobile: 140,
                    tablet: 160,
                    desktop: 180,
                  )
                : ResponsiveUtils.spacing(
                    context,
                    mobile: 20,
                    tablet: 24,
                    desktop: 28,
                  ),
            child: _buildZoomButton(
              icon: Icons.my_location,
              onPressed: () {
                _mapController.move(_location, 15.0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 8, tablet: 9, desktop: 10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: AppColors.primary,
          size: ResponsiveUtils.size(
            context,
            mobile: 24,
            tablet: 26,
            desktop: 28,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
