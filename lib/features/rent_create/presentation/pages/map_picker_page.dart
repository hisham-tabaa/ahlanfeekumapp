import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';

class MapPickerPage extends StatefulWidget {
  final double initialLat;
  final double initialLng;

  const MapPickerPage({
    super.key,
    required this.initialLat,
    required this.initialLng,
  });

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  late final MapController _mapController;
  late LatLng _selectedLocation;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedAddress;
  String? _selectedStreet;
  String? _selectedLandmark;
  bool _isSearching = false;
  bool _isGettingLocation = false;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedLocation = LatLng(widget.initialLat, widget.initialLng);
    _getAddressFromCoordinates(_selectedLocation);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dio.close();
    super.dispose();
  }

  // Fallback reverse geocoding using Nominatim
  Future<String?> _fallbackReverseGeocode(double lat, double lng) async {
    // Check if widget is still mounted and Dio is not closed
    if (!mounted) return null;

    try {
      final response = await _dio
          .get(
            'https://nominatim.openstreetmap.org/reverse',
            queryParameters: {
              'format': 'json',
              'lat': lat.toString(),
              'lon': lng.toString(),
              'zoom': 18,
              'addressdetails': 1,
            },
            options: Options(
              headers: {'User-Agent': 'AhlanFeekum/1.0.0 (Flutter App)'},
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
            ),
          )
          .timeout(
            const Duration(seconds: 12),
            onTimeout: () => throw Exception('Nominatim request timeout'),
          );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final displayName = data['display_name'] as String?;

        if (displayName != null && displayName.isNotEmpty) {
          // Clean up the display name to make it more readable
          final parts = displayName.split(', ');
          if (parts.length > 4) {
            // Take the first 4 most relevant parts
            return parts.take(4).join(', ');
          }
          return displayName;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _getAddressFromCoordinates(LatLng location) async {
    if (!mounted) return;

    setState(() {
      _selectedAddress = 'Getting address...';
    });

    // Try fallback first (Nominatim) as it's more reliable
    try {
      final fallbackAddress = await _fallbackReverseGeocode(
        location.latitude,
        location.longitude,
      );
      if (fallbackAddress != null && mounted) {
        setState(() {
          _selectedAddress = fallbackAddress;
          _selectedStreet = null;
          _selectedLandmark = null;
        });
        return;
      }
    } catch (fallbackError) {}

    // If fallback fails, try the geocoding package
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Address lookup timeout'),
          );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final addressParts = <String>[];

        // Extract street
        String? street;
        if (placemark.street != null && placemark.street!.isNotEmpty) {
          street = placemark.street;
        }

        // Extract landmark (using name or thoroughfare)
        String? landmark;
        if (placemark.name != null &&
            placemark.name!.isNotEmpty &&
            placemark.name != placemark.street) {
          landmark = placemark.name;
        } else if (placemark.thoroughfare != null &&
            placemark.thoroughfare!.isNotEmpty) {
          landmark = placemark.thoroughfare;
        }

        // Build address with better formatting
        if (placemark.name != null && placemark.name!.isNotEmpty) {
          addressParts.add(placemark.name!);
        }
        if (placemark.street != null &&
            placemark.street!.isNotEmpty &&
            placemark.street != placemark.name) {
          addressParts.add(placemark.street!);
        }
        if (placemark.locality != null && placemark.locality!.isNotEmpty) {
          addressParts.add(placemark.locality!);
        }
        if (placemark.administrativeArea != null &&
            placemark.administrativeArea!.isNotEmpty) {
          addressParts.add(placemark.administrativeArea!);
        }
        if (placemark.country != null && placemark.country!.isNotEmpty) {
          addressParts.add(placemark.country!);
        }

        if (mounted) {
          setState(() {
            _selectedAddress = addressParts.isNotEmpty
                ? addressParts.join(', ')
                : 'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}';
            _selectedStreet = street;
            _selectedLandmark = landmark;
          });
        }
      } else {
        // Show coordinates if no address found
        if (mounted) {
          setState(() {
            _selectedAddress =
                'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}';
            _selectedStreet = null;
            _selectedLandmark = null;
          });
        }
      }
    } catch (e) {
      // If both methods fail, show coordinates
      if (mounted) {
        setState(() {
          _selectedAddress =
              'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}';
          _selectedStreet = null;
          _selectedLandmark = null;
        });
      }
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    if (mounted) {
      setState(() {
        _isSearching = true;
      });
    }

    try {
      List<Location> locations = await locationFromAddress(query).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Search timeout'),
      );

      if (locations.isNotEmpty) {
        final location = locations.first;
        final newLocation = LatLng(location.latitude, location.longitude);

        if (mounted) {
          setState(() {
            _selectedLocation = newLocation;
          });
        }

        _mapController.move(newLocation, 15.0);
        await _getAddressFromCoordinates(newLocation);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No results found for "$query"'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString().contains('timeout')
            ? 'Search timeout. Please check your internet connection.'
            : 'Location not found. Please try a different search term.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng location) {
    if (mounted) {
      setState(() {
        _selectedLocation = location;
      });
    }
    _getAddressFromCoordinates(location);
  }

  Future<void> _getCurrentLocation() async {
    if (_isGettingLocation) return;

    // Check if we're on web - geolocator has issues on web
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Current location is not available on web. Please manually select your location on the map.',
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isGettingLocation = true;
      });
    }

    try {
      // Check if the geolocator plugin is available
      bool serviceEnabled;
      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } catch (e) {
        // Plugin not available (platform issue)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Location services are not available on this platform. Please manually select your location on the map.',
              ),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Location services are disabled. Please enable them to use this feature.',
              ),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      // Check location permission
      LocationPermission permission;
      try {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Location permissions are denied. Please grant permission in settings.',
                  ),
                  backgroundColor: AppColors.error,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
            return;
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not check location permissions. Please manually select your location on the map.',
              ),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Location permissions are permanently denied. Please enable them in app settings.',
              ),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Settings',
                textColor: Colors.white,
                onPressed: () {
                  Geolocator.openAppSettings();
                },
              ),
            ),
          );
        }
        return;
      }

      // Get current position
      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 15),
          ),
        );
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Could not get current position.';
          if (e.toString().contains('timeout')) {
            errorMessage =
                'Location request timed out. Please try again or select location manually.';
          } else if (e.toString().contains('permanently_denied')) {
            errorMessage =
                'Location access permanently denied. Please enable in settings.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      final currentLocation = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          _selectedLocation = currentLocation;
        });
      }

      // Move map to current location
      _mapController.move(currentLocation, 16.0);

      // Get address for current location
      await _getAddressFromCoordinates(currentLocation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Current location found!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Could not get current location.';
        if (e.toString().contains('timeout')) {
          errorMessage = 'Location request timed out. Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  void _confirmLocation() {
    Navigator.of(context).pop({
      'lat': _selectedLocation.latitude,
      'lng': _selectedLocation.longitude,
      'address': _selectedAddress,
      'street': _selectedStreet,
      'landmark': _selectedLandmark,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          _buildMap(context),
          _buildSearchOverlay(context),
          _buildMyLocationButton(context),
          _buildBottomSheet(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Select Location',
        style: AppTextStyles.h3.copyWith(
          color: AppColors.textPrimary,
          fontSize: ResponsiveUtils.fontSize(
            context,
            mobile: 18,
            tablet: 20,
            desktop: 22,
          ),
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildMap(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _selectedLocation,
        initialZoom: 15.0,
        onTap: _onMapTap,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
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
              point: _selectedLocation,
              child: SizedBox(
                width: ResponsiveUtils.size(
                  context,
                  mobile: 48,
                  tablet: 54,
                  desktop: 60,
                ),
                height: ResponsiveUtils.size(
                  context,
                  mobile: 48,
                  tablet: 54,
                  desktop: 60,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Shadow/Glow effect
                    Container(
                      width: ResponsiveUtils.size(
                        context,
                        mobile: 24,
                        tablet: 27,
                        desktop: 30,
                      ),
                      height: ResponsiveUtils.size(
                        context,
                        mobile: 24,
                        tablet: 27,
                        desktop: 30,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    // Main location pin
                    Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: ResponsiveUtils.fontSize(
                        context,
                        mobile: 48,
                        tablet: 50,
                        desktop: 52,
                      ),
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    // Inner dot
                    Positioned(
                      top: ResponsiveUtils.spacing(
                        context,
                        mobile: 10,
                        tablet: 11,
                        desktop: 12,
                      ),
                      child: Container(
                        width: ResponsiveUtils.size(
                          context,
                          mobile: 12,
                          tablet: 13,
                          desktop: 14,
                        ),
                        height: ResponsiveUtils.size(
                          context,
                          mobile: 12,
                          tablet: 13,
                          desktop: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Pulsing animation ring
                    Positioned(
                      bottom: ResponsiveUtils.spacing(
                        context,
                        mobile: 4,
                        tablet: 5,
                        desktop: 6,
                      ),
                      child: Container(
                        width: ResponsiveUtils.size(
                          context,
                          mobile: 20,
                          tablet: 21,
                          desktop: 22,
                        ),
                        height: ResponsiveUtils.size(
                          context,
                          mobile: 6,
                          tablet: 7,
                          desktop: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 10,
                              tablet: 11,
                              desktop: 12,
                            ),
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
      ],
    );
  }

  Widget _buildMyLocationButton(BuildContext context) {
    return Positioned(
      top: ResponsiveUtils.spacing(
        context,
        mobile: 80,
        tablet: 85,
        desktop: 90,
      ),
      right: ResponsiveUtils.spacing(
        context,
        mobile: 16,
        tablet: 17,
        desktop: 18,
      ),
      child: Container(
        width: ResponsiveUtils.size(
          context,
          mobile: 56,
          tablet: 58,
          desktop: 60,
        ),
        height: ResponsiveUtils.size(
          context,
          mobile: 56,
          tablet: 58,
          desktop: 60,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 28,
                tablet: 29,
                desktop: 30,
              ),
            ),
            onTap: _isGettingLocation || kIsWeb ? null : _getCurrentLocation,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: (_isGettingLocation || kIsWeb)
                      ? AppColors.border
                      : AppColors.primary,
                  width: 2,
                ),
              ),
              child: _isGettingLocation
                  ? Padding(
                      padding: EdgeInsets.all(
                        ResponsiveUtils.spacing(
                          context,
                          mobile: 16,
                          tablet: 17,
                          desktop: 18,
                        ),
                      ),
                      child: SizedBox(
                        width: ResponsiveUtils.size(
                          context,
                          mobile: 20,
                          tablet: 21,
                          desktop: 22,
                        ),
                        height: ResponsiveUtils.size(
                          context,
                          mobile: 20,
                          tablet: 21,
                          desktop: 22,
                        ),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    )
                  : Icon(
                      Icons.my_location,
                      color: kIsWeb ? AppColors.border : AppColors.primary,
                      size: ResponsiveUtils.fontSize(
                        context,
                        mobile: 24,
                        tablet: 25,
                        desktop: 26,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchOverlay(BuildContext context) {
    return Positioned(
      top: ResponsiveUtils.spacing(
        context,
        mobile: 16,
        tablet: 17,
        desktop: 18,
      ),
      left: ResponsiveUtils.spacing(
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.radius(
              context,
              mobile: 12,
              tablet: 13,
              desktop: 14,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for a location',
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            suffixIcon: _isSearching
                ? Padding(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 12,
                        tablet: 13,
                        desktop: 14,
                      ),
                    ),
                    child: SizedBox(
                      width: ResponsiveUtils.size(
                        context,
                        mobile: 20,
                        tablet: 21,
                        desktop: 22,
                      ),
                      height: ResponsiveUtils.size(
                        context,
                        mobile: 20,
                        tablet: 21,
                        desktop: 22,
                      ),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.clear, color: AppColors.textSecondary),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.radius(
                  context,
                  mobile: 12,
                  tablet: 13,
                  desktop: 14,
                ),
              ),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 17,
                desktop: 18,
              ),
              vertical: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 17,
                desktop: 18,
              ),
            ),
          ),
          onSubmitted: _searchLocation,
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 20,
                tablet: 21,
                desktop: 22,
              ),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.all(
          ResponsiveUtils.spacing(context, mobile: 20, tablet: 21, desktop: 22),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: ResponsiveUtils.size(
                    context,
                    mobile: 40,
                    tablet: 42,
                    desktop: 44,
                  ),
                  height: ResponsiveUtils.size(
                    context,
                    mobile: 4,
                    tablet: 5,
                    desktop: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.border,
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
              ),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 16,
                  tablet: 17,
                  desktop: 18,
                ),
              ),

              // Selected location info
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: ResponsiveUtils.fontSize(
                      context,
                      mobile: 24,
                      tablet: 25,
                      desktop: 26,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Location',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
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
                            mobile: 4,
                            tablet: 5,
                            desktop: 6,
                          ),
                        ),
                        Text(
                          _selectedAddress ?? 'Loading address...',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              mobile: 16,
                              tablet: 17,
                              desktop: 18,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                          'Lat: ${_selectedLocation.latitude.toStringAsFixed(6)}, '
                          'Lng: ${_selectedLocation.longitude.toStringAsFixed(6)}',
                          style: AppTextStyles.caption.copyWith(
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
                ],
              ),

              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 25,
                  desktop: 26,
                ),
              ),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 12,
                              tablet: 13,
                              desktop: 14,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.spacing(
                            context,
                            mobile: 16,
                            tablet: 17,
                            desktop: 18,
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 16,
                            tablet: 17,
                            desktop: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 17,
                      desktop: 18,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _confirmLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 12,
                              tablet: 13,
                              desktop: 14,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUtils.spacing(
                            context,
                            mobile: 16,
                            tablet: 17,
                            desktop: 18,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Confirm Location',
                        style: AppTextStyles.buttonText.copyWith(
                          color: Colors.white,
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 16,
                            tablet: 17,
                            desktop: 18,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
