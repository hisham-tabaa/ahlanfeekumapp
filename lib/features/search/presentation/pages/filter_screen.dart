import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../data/models/search_filter.dart';
import '../../domain/entities/search_entities.dart';
import '../../../rent_create/presentation/pages/map_picker_page.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'package:easy_localization/easy_localization.dart';

class FilterScreen extends StatefulWidget {
  final SearchFilter currentFilter;

  const FilterScreen({super.key, required this.currentFilter});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  String? _selectedPropertyTypeId;
  String? _selectedGovernorateId;
  int _selectedRooms = 1;
  int _selectedBathrooms = 1;
  int _selectedBedrooms = 1;
  int _selectedNumberOfBeds = 1;
  int _selectedGuestsMin = 1;
  int _selectedGuestsMax = 4;
  final List<String> _selectedFeatures = [];
  DateTime? _checkIn;
  DateTime? _checkOut;
  double? _selectedLatitude;
  double? _selectedLongitude;

  @override
  void initState() {
    super.initState();

    _initializeFromCurrentFilter();

    // Load lookups if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLookupsIfNeeded();
    });
  }

  void _loadLookupsIfNeeded() async {
    if (!mounted) return;

    try {
      final bloc = context.read<SearchBloc>();
      if (bloc.isClosed) return;

      final state = bloc.state;

      // Load lookups if they're not available
      if (state is SearchInitial ||
          (state is SearchLoaded && state.propertyTypes.isEmpty) ||
          (state is LookupsLoaded && state.propertyTypes.isEmpty)) {
        bloc.add(const LoadLookupsEvent());
      }
    } catch (e) {
      // Continue without lookups - UI will show loading states
    }
  }

  void _openMapPicker() async {
    try {
      // Use default location (Damascus, Syria) if no location is selected
      final defaultLat = _selectedLatitude ?? 33.5138;
      final defaultLng = _selectedLongitude ?? 36.2765;


      final result = await Navigator.of(context).push<Map<String, dynamic>>(
        MaterialPageRoute(
          builder: (context) =>
              MapPickerPage(initialLat: defaultLat, initialLng: defaultLng),
        ),
      );

      if (result != null && mounted) {
        final lat = result['lat'] as double?;
        final lng = result['lng'] as double?;
        final address = result['address'] as String?;

        if (lat != null && lng != null) {
          setState(() {
            _selectedLatitude = lat;
            _selectedLongitude = lng;
            if (address != null && address.isNotEmpty) {
              _locationController.text = address;
            }
          });

        }
      }
    } catch (e) {

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('could_not_open_map'.tr()),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _initializeFromCurrentFilter() {
    final filter = widget.currentFilter;

    _hotelNameController.text = filter.hotelName ?? '';
    // Use filterText first (from search screen "Where To?" field), fallback to address
    _locationController.text = filter.filterText ?? filter.address ?? '';
    _minPriceController.text = filter.pricePerNightMin?.toString() ?? '200';
    _maxPriceController.text = filter.pricePerNightMax?.toString() ?? '450';
    _selectedLatitude = filter.latitude;
    _selectedLongitude = filter.longitude;

    _selectedPropertyTypeId = filter.propertyTypeId;
    _selectedGovernorateId = filter.governorateId;

    if (filter.checkInDate != null) {
      _checkIn = DateTime.fromMillisecondsSinceEpoch(filter.checkInDate!);
    }
    if (filter.checkOutDate != null) {
      _checkOut = DateTime.fromMillisecondsSinceEpoch(filter.checkOutDate!);
    }

    if (filter.bedroomsMin != null) {
      _selectedBedrooms = filter.bedroomsMin!;
    }
    if (filter.bathroomsMin != null) {
      _selectedBathrooms = filter.bathroomsMin!;
    }
    if (filter.livingroomsMin != null) {
      _selectedRooms = filter.livingroomsMin!;
    }
    if (filter.numberOfBedMin != null) {
      _selectedNumberOfBeds = filter.numberOfBedMin!;
    }
    if (filter.maximumNumberOfGuestMin != null) {
      _selectedGuestsMin = filter.maximumNumberOfGuestMin!;
    }
    if (filter.maximumNumberOfGuestMax != null) {
      _selectedGuestsMax = filter.maximumNumberOfGuestMax!;
    }

    if (filter.selectedFeatures != null) {
      _selectedFeatures.addAll(filter.selectedFeatures!);
    } else {
      // Default selected features to match mockup
      _selectedFeatures.addAll(['Kitchen', 'Parking']);
    }
  }

  @override
  void dispose() {
    _hotelNameController.dispose();
    _locationController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filter By',
          style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is LookupsLoaded || state is SearchLoaded) {
            final propertyTypes = state is LookupsLoaded
                ? state.propertyTypes
                : (state as SearchLoaded).propertyTypes;
            final propertyFeatures = state is LookupsLoaded
                ? state.propertyFeatures
                : (state as SearchLoaded).propertyFeatures;
            final governates = state is LookupsLoaded
                ? state.governates
                : (state as SearchLoaded).governates;

            return Column(
              children: [
                Expanded(
                  child: ResponsiveLayout(
                    maxWidth: 700,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(
                        ResponsiveUtils.spacing(
                          context,
                          mobile: 24,
                          tablet: 28,
                          desktop: 32,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCategorySection(propertyTypes),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                          ),
                          _buildDateSection(),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                          ),
                          _buildHotelNameSection(),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                          ),
                          _buildPriceSection(),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                          ),
                          _buildLocationSection(),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                          ),
                          _buildNumberSelector(
                            'Number Of Rooms',
                            _selectedRooms,
                            (value) => setState(() => _selectedRooms = value),
                          ),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                          ),
                          _buildNumberSelector(
                            'Bedrooms',
                            _selectedBedrooms,
                            (value) =>
                                setState(() => _selectedBedrooms = value),
                          ),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                          ),
                          _buildNumberSelector(
                            'Bathrooms',
                            _selectedBathrooms,
                            (value) =>
                                setState(() => _selectedBathrooms = value),
                          ),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                          ),
                          _buildNumberSelector(
                            'Number Of Beds',
                            _selectedNumberOfBeds,
                            (value) =>
                                setState(() => _selectedNumberOfBeds = value),
                          ),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                          ),
                          _buildGuestRangeSection(),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                          ),
                          _buildGovernorateSection(governates),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 24,
                              tablet: 28,
                              desktop: 32,
                            ),
                          ),
                          _buildFeaturesSection(propertyFeatures),
                          SizedBox(
                            height: ResponsiveUtils.spacing(
                              context,
                              mobile: 32,
                              tablet: 36,
                              desktop: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ResponsiveLayout(maxWidth: 700, child: _buildFilterButton()),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCategorySection(List<LookupItemEntity> propertyTypes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose A Category',
          style: AppTextStyles.bodyLarge.copyWith(
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
          children: [
            if (propertyTypes.isNotEmpty) ...[
              Expanded(
                child: _buildCategoryCard(
                  propertyTypes.first.id,
                  propertyTypes.first.displayName,
                  Icons.home,
                ),
              ),
              if (propertyTypes.length > 1) ...[
                SizedBox(
                  width: ResponsiveUtils.spacing(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
                Expanded(
                  child: _buildCategoryCard(
                    propertyTypes[1].id,
                    propertyTypes[1].displayName,
                    Icons.apartment,
                  ),
                ),
              ],
              if (propertyTypes.length > 2) ...[
                SizedBox(
                  width: ResponsiveUtils.spacing(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
                Expanded(
                  child: _buildCategoryCard(
                    propertyTypes[2].id,
                    propertyTypes[2].displayName,
                    Icons.business,
                  ),
                ),
              ],
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String typeId, String title, IconData icon) {
    final isSelected = _selectedPropertyTypeId == typeId;
    return GestureDetector(
      onTap: () => setState(() => _selectedPropertyTypeId = typeId),
      child: Container(
        padding: EdgeInsets.all(
          ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.radius(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
          ),
          border: Border.all(
            color: isSelected ? AppColors.green : AppColors.border,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.green : AppColors.textSecondary,
              size: ResponsiveUtils.fontSize(
                context,
                mobile: 32,
                tablet: 36,
                desktop: 40,
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
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.green : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Row(
      children: [
        Expanded(
          child: _buildDateField('Check in', _checkIn, () => _selectDate(true)),
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
          child: _buildDateField(
            'Check Out',
            _checkOut,
            () => _selectDate(false),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    // Use today's date as default display if no date is selected
    final displayDate = date ?? DateTime.now();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
        ),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.radius(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
          ),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: AppColors.green,
              size: ResponsiveUtils.fontSize(
                context,
                mobile: 18,
                tablet: 20,
                desktop: 22,
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
              '${displayDate.day}/${displayDate.month}/${displayDate.year}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: date != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hotel Name',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
            ),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          ),
          child: TextFormField(
            controller: _hotelNameController,
            decoration: InputDecoration(
              hintText: 'Royal Samirames',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(
                ResponsiveUtils.spacing(
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
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range / Night',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
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
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.radius(
                      context,
                      mobile: 12,
                      tablet: 14,
                      desktop: 16,
                    ),
                  ),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
                ),
                child: TextFormField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Start From',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    suffixText: '\$',
                    suffixStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                    ),
                  ),
                ),
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
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.radius(
                      context,
                      mobile: 12,
                      tablet: 14,
                      desktop: 16,
                    ),
                  ),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
                ),
                child: TextFormField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'To',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    suffixText: '\$',
                    suffixStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
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
          onTap: _openMapPicker,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.radius(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
              border: Border.all(
                color: (_selectedLatitude != null && _selectedLongitude != null)
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.border.withValues(alpha: 0.3),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color:
                        (_selectedLatitude != null &&
                            _selectedLongitude != null)
                        ? AppColors.primary
                        : AppColors.textSecondary,
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
                          _locationController.text.isEmpty
                              ? 'Select location from map'
                              : _locationController.text,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _locationController.text.isEmpty
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (_selectedLatitude != null &&
                            _selectedLongitude != null)
                          Text(
                            'Lat: ${_selectedLatitude!.toStringAsFixed(4)}, Lng: ${_selectedLongitude!.toStringAsFixed(4)}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_selectedLatitude != null && _selectedLongitude != null)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLatitude = null;
                          _selectedLongitude = null;
                          _locationController.clear();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(
                          ResponsiveUtils.spacing(
                            context,
                            mobile: 4,
                            tablet: 5,
                            desktop: 6,
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                          size: ResponsiveUtils.fontSize(
                            context,
                            mobile: 18,
                            tablet: 20,
                            desktop: 22,
                          ),
                        ),
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
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: ResponsiveUtils.fontSize(
                      context,
                      mobile: 20,
                      tablet: 22,
                      desktop: 24,
                    ),
                  ),
                ],
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
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
            vertical: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 10,
              desktop: 12,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
            ),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            'The Closest',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberSelector(
    String title,
    int value,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
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
        Row(
          children: [
            _buildNumberOption(
              '1 - 3',
              value >= 1 && value <= 3,
              () => onChanged(3),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              ),
            ),
            _buildNumberOption(
              '3 - 6',
              value >= 4 && value <= 6,
              () => onChanged(6),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              ),
            ),
            _buildNumberOption(
              '6 - 9',
              value >= 7 && value <= 9,
              () => onChanged(9),
            ),
            SizedBox(
              width: ResponsiveUtils.spacing(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              ),
            ),
            _buildNumberOption('9+', value > 9, () => onChanged(10)),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberOption(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.spacing(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.green.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              ),
            ),
            border: Border.all(
              color: isSelected ? AppColors.green : AppColors.border,
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isSelected ? AppColors.green : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuestRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Guests',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
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
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minimum',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
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
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_selectedGuestsMin > 1) {
                              setState(() => _selectedGuestsMin--);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              ResponsiveUtils.spacing(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                            child: Icon(
                              Icons.remove,
                              color: _selectedGuestsMin > 1
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              size: ResponsiveUtils.fontSize(
                                context,
                                mobile: 20,
                                tablet: 22,
                                desktop: 24,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$_selectedGuestsMin',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_selectedGuestsMin < _selectedGuestsMax) {
                              setState(() => _selectedGuestsMin++);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              ResponsiveUtils.spacing(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: _selectedGuestsMin < _selectedGuestsMax
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              size: ResponsiveUtils.fontSize(
                                context,
                                mobile: 20,
                                tablet: 22,
                                desktop: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maximum',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
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
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_selectedGuestsMax > _selectedGuestsMin) {
                              setState(() => _selectedGuestsMax--);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              ResponsiveUtils.spacing(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                            child: Icon(
                              Icons.remove,
                              color: _selectedGuestsMax > _selectedGuestsMin
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              size: ResponsiveUtils.fontSize(
                                context,
                                mobile: 20,
                                tablet: 22,
                                desktop: 24,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$_selectedGuestsMax',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_selectedGuestsMax < 20) {
                              setState(() => _selectedGuestsMax++);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                              ResponsiveUtils.spacing(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              color: _selectedGuestsMax < 20
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              size: ResponsiveUtils.fontSize(
                                context,
                                mobile: 20,
                                tablet: 22,
                                desktop: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGovernorateSection(List<LookupItemEntity> governates) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Governorate',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.radius(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              ),
            ),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: _selectedGovernorateId,
            decoration: InputDecoration(
              hintText: 'Select Governorate',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
              ),
            ),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text(
                  'All Governorates',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              ...governates.map(
                (governorate) => DropdownMenuItem<String>(
                  value: governorate.id,
                  child: Text(
                    governorate.displayName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedGovernorateId = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(List<LookupItemEntity> propertyFeatures) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Features',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
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
          children: propertyFeatures
              .map(
                (feature) => _buildFeatureChip(feature.id, feature.displayName),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildFeatureChip(String featureId, String featureName) {
    final isSelected = _selectedFeatures.contains(featureId);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedFeatures.remove(featureId);
          } else {
            _selectedFeatures.add(featureId);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(
          right: ResponsiveUtils.spacing(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
          bottom: ResponsiveUtils.spacing(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
        ),
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
          color: isSelected ? AppColors.green.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.radius(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
          ),
          border: Border.all(
            color: isSelected ? AppColors.green : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.green : AppColors.textSecondary,
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
                mobile: 6,
                tablet: 7,
                desktop: 8,
              ),
            ),
            Text(
              featureName,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.green : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(
          context,
          mobile: 24,
          tablet: 28,
          desktop: 32,
        ),
        vertical: ResponsiveUtils.spacing(
          context,
          mobile: 16,
          tablet: 18,
          desktop: 20,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: ResponsiveUtils.size(
          context,
          mobile: 52,
          tablet: 56,
          desktop: 60,
        ),
        child: ElevatedButton(
          onPressed: () {

            // Apply filters and navigate back
            final locationText = _locationController.text.trim().isEmpty
                ? null
                : _locationController.text.trim();
            final filter = SearchFilter(
              // Basic filters
              filterText: locationText,
              propertyTypeId: _selectedPropertyTypeId,
              checkInDate: _checkIn?.millisecondsSinceEpoch,
              checkOutDate: _checkOut?.millisecondsSinceEpoch,

              // Price filters
              pricePerNightMin: int.tryParse(_minPriceController.text),
              pricePerNightMax: int.tryParse(_maxPriceController.text),

              // Location filters
              address: locationText,
              governorateId: _selectedGovernorateId,
              latitude: _selectedLatitude,
              longitude: _selectedLongitude,

              // Property details
              hotelName: _hotelNameController.text.trim().isEmpty
                  ? null
                  : _hotelNameController.text.trim(),

              // Room filters
              bedroomsMin: _selectedBedrooms,
              bedroomsMax: _selectedBedrooms + 2,
              bathroomsMin: _selectedBathrooms,
              bathroomsMax: _selectedBathrooms + 1,
              livingroomsMin: _selectedRooms,
              livingroomsMax: _selectedRooms + 2,

              // Bed filters
              numberOfBedMin: _selectedNumberOfBeds,
              numberOfBedMax: _selectedNumberOfBeds + 2,

              // Guest filters
              maximumNumberOfGuestMin: _selectedGuestsMin,
              maximumNumberOfGuestMax: _selectedGuestsMax,

              // Features
              selectedFeatures: _selectedFeatures.isEmpty
                  ? null
                  : _selectedFeatures,

              // Active status (always true for user searches)
              isActive: true,
            );


            // Update filter and trigger search
            context.read<SearchBloc>().add(UpdateFilterEvent(filter: filter));
            context.read<SearchBloc>().add(
              SearchPropertiesEvent(filter: filter),
            );

            // Navigate to search results with the new filter
            Navigator.of(context).pushReplacementNamed(
              '/search-results',
              arguments: {'filter': filter},
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
            elevation: 0,
          ),
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              String resultText = 'Filter';
              if (state is SearchLoaded) {
                resultText =
                    'Filter (${state.totalCount} Result${state.totalCount == 1 ? '' : 's'})';
              } else if (state is LookupsLoaded) {
                resultText = 'Filter';
              }
              return Text(
                resultText,
                style: AppTextStyles.buttonText.copyWith(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? _checkIn ?? DateTime.now()
          : _checkOut ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          // Adjust check-out if it's before check-in
          if (_checkOut != null && _checkOut!.isBefore(picked)) {
            _checkOut = picked.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }
}
