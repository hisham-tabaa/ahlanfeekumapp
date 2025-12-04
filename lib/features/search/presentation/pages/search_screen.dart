import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../data/models/search_filter.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _locationController = TextEditingController();
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 1;

  @override
  void initState() {
    super.initState();
    // Load lookups when the screen initializes
    context.read<SearchBloc>().add(const LoadLookupsEvent());
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
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
          return ResponsiveLayout(
            maxWidth: 600,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(ResponsiveUtils.spacing(
                      context,
                      mobile: 24,
                      tablet: 28,
                      desktop: 32,
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchForm(),
                        SizedBox(height: ResponsiveUtils.spacing(
                          context,
                          mobile: 32,
                          tablet: 36,
                          desktop: 40,
                        )),
                        if (state is LookupsLoaded &&
                            state.recentSearches.isNotEmpty)
                          _buildRecentSearches(state.recentSearches),
                      ],
                    ),
                  ),
                ),
                _buildSearchButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchForm() {
    return Column(
      children: [
        _buildLocationField(),
        SizedBox(height: ResponsiveUtils.spacing(
          context,
          mobile: 16,
          tablet: 18,
          desktop: 20,
        )),
        _buildDateSection(),
        SizedBox(height: ResponsiveUtils.spacing(
          context,
          mobile: 16,
          tablet: 18,
          desktop: 20,
        )),
        _buildGuestsField(),
        SizedBox(height: ResponsiveUtils.spacing(
          context,
          mobile: 20,
          tablet: 24,
          desktop: 28,
        )),
        _buildFilterButton(),
      ],
    );
  }

  Widget _buildLocationField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        )),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: _locationController,
        decoration: InputDecoration(
          hintText: 'Where To?',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: AppColors.green,
            size: ResponsiveUtils.fontSize(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
            vertical: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Row(
      children: [
        Expanded(
          child: _buildDateField('Check In', _checkIn, () => _selectDate(true)),
        ),
        SizedBox(width: ResponsiveUtils.spacing(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        )),
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
        padding: EdgeInsets.all(ResponsiveUtils.spacing(
          context,
          mobile: 16,
          tablet: 18,
          desktop: 20,
        )),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          )),
          border: Border.all(color: AppColors.border.withOpacity(0.3)),
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
            SizedBox(width: ResponsiveUtils.spacing(
              context,
              mobile: 8,
              tablet: 10,
              desktop: 12,
            )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(
                    context,
                    mobile: 2,
                    tablet: 3,
                    desktop: 4,
                  )),
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
          ],
        ),
      ),
    );
  }

  Widget _buildGuestsField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        )),
        border: Border.all(color: AppColors.border.withOpacity(0.3)),
      ),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: '$_guests Guest${_guests > 1 ? 's' : ''}',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          prefixIcon: Icon(
            Icons.person_outline,
            color: AppColors.green,
            size: ResponsiveUtils.fontSize(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
            vertical: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
        ),
        onTap: () => _showGuestSelector(),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _openFilterScreen,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
            vertical: ResponsiveUtils.spacing(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 16,
            )),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune,
                color: AppColors.textSecondary,
                size: ResponsiveUtils.fontSize(
                  context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
              ),
              SizedBox(width: ResponsiveUtils.spacing(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              )),
              Text(
                'filter'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
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
            color: Colors.grey.withOpacity(0.1),
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
          onPressed: _onSearchButtonPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius(
                context,
                mobile: 12,
                tablet: 14,
                desktop: 16,
              )),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                color: Colors.white,
                size: ResponsiveUtils.fontSize(
                  context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
              ),
              SizedBox(width: ResponsiveUtils.spacing(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              )),
              Text(
                'Search',
                style: AppTextStyles.buttonText.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches(List<RecentSearch> recentSearches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Search',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing(
          context,
          mobile: 16,
          tablet: 18,
          desktop: 20,
        )),
        ...recentSearches
            .take(3)
            .map((search) => _buildRecentSearchItem(search))
            ,
      ],
    );
  }

  Widget _buildRecentSearchItem(RecentSearch search) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing(
        context,
        mobile: 12,
        tablet: 14,
        desktop: 16,
      )),
      child: Row(
        children: [
          Icon(
            Icons.history,
            color: AppColors.textSecondary,
            size: ResponsiveUtils.fontSize(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
          ),
          SizedBox(width: ResponsiveUtils.spacing(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatRecentSearchTitle(search),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatRecentSearchSubtitle(search),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _removeRecentSearch(search),
            child: Icon(
              Icons.close,
              color: AppColors.primary,
              size: ResponsiveUtils.fontSize(
                context,
                mobile: 18,
                tablet: 20,
                desktop: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatRecentSearchTitle(RecentSearch search) {
    if (search.location != null && search.location!.isNotEmpty) {
      return search.location!;
    }
    return 'Search';
  }

  String _formatRecentSearchSubtitle(RecentSearch search) {
    List<String> parts = [];

    if (search.checkIn != null && search.checkOut != null) {
      final checkInStr =
          '${search.checkIn!.day}/${search.checkIn!.month}/${search.checkIn!.year}';
      final checkOutStr =
          '${search.checkOut!.day}/${search.checkOut!.month}/${search.checkOut!.year}';
      parts.add('$checkInStr - $checkOutStr');
    }

    if (search.guests != null && search.guests! > 0) {
      parts.add('${search.guests} Guest${search.guests! > 1 ? 's' : ''}');
    }

    return parts.join(', ');
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

  Future<void> _showGuestSelector() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveUtils.radius(
            context,
            mobile: 20,
            tablet: 22,
            desktop: 24,
          )),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing(
            context,
            mobile: 24,
            tablet: 28,
            desktop: 32,
          )),
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
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius(
                    context,
                    mobile: 2,
                    tablet: 3,
                    desktop: 4,
                  )),
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 28,
              )),
              Text(
                'Guests',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number of Guests',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_guests > 1) {
                            setState(() => _guests = _guests - 1);
                            setModalState(() {}); // Update modal UI
                          }
                        },
                        child: Container(
                          width: ResponsiveUtils.size(
                            context,
                            mobile: 40,
                            tablet: 45,
                            desktop: 50,
                          ),
                          height: ResponsiveUtils.size(
                            context,
                            mobile: 40,
                            tablet: 45,
                            desktop: 50,
                          ),
                          decoration: BoxDecoration(
                            color: _guests > 1
                                ? AppColors.primary
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.radius(
                              context,
                              mobile: 8,
                              tablet: 10,
                              desktop: 12,
                            )),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: _guests > 1
                                ? Colors.white
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
                      SizedBox(
                        width: ResponsiveUtils.size(
                          context,
                          mobile: 60,
                          tablet: 65,
                          desktop: 70,
                        ),
                        child: Text(
                          '$_guests',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_guests < 10) {
                            setState(() => _guests = _guests + 1);
                            setModalState(() {}); // Update modal UI
                          }
                        },
                        child: Container(
                          width: ResponsiveUtils.size(
                            context,
                            mobile: 40,
                            tablet: 45,
                            desktop: 50,
                          ),
                          height: ResponsiveUtils.size(
                            context,
                            mobile: 40,
                            tablet: 45,
                            desktop: 50,
                          ),
                          decoration: BoxDecoration(
                            color: _guests < 10
                                ? AppColors.primary
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(ResponsiveUtils.radius(
                              context,
                              mobile: 8,
                              tablet: 10,
                              desktop: 12,
                            )),
                          ),
                          child: Icon(
                            Icons.add,
                            color: _guests < 10
                                ? Colors.white
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
                ],
              ),
              SizedBox(height: ResponsiveUtils.spacing(
                context,
                mobile: 32,
                tablet: 36,
                desktop: 40,
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _openFilterScreen() async {

    if (!mounted) {
      return;
    }

    try {
      final bloc = context.read<SearchBloc>();

      if (bloc.isClosed) {
        return;
      }

      final currentState = bloc.state;

      SearchFilter currentFilter = const SearchFilter();

      // Extract current filter from state
      if (currentState is LookupsLoaded) {
        currentFilter = currentState.currentFilter;
      } else if (currentState is SearchLoaded) {
        currentFilter = currentState.currentFilter;
      } else {
      }

      // Update filter with current search screen values (only basic filters)
      currentFilter = currentFilter.copyWith(
        filterText: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        checkInDate: _checkIn?.millisecondsSinceEpoch,
        checkOutDate: _checkOut?.millisecondsSinceEpoch,
        maximumNumberOfGuestMax: _guests,
      );


      // Navigate immediately
      if (mounted) {
        await Navigator.of(
          context,
        ).pushNamed('/filter', arguments: {'filter': currentFilter});
      }
    } catch (e) {

      // Fallback: navigate with default filter
      if (mounted) {
        try {
          await Navigator.of(
            context,
          ).pushNamed('/filter', arguments: {'filter': const SearchFilter()});
        } catch (fallbackError) {
        }
      }
    }
  }

  void _removeRecentSearch(RecentSearch search) {
    // TODO: Implement remove recent search functionality
    // This would require adding a new event to the bloc
  }

  void _onSearchButtonPressed() {

    // Save to recent searches
    final recentSearch = RecentSearch(
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      checkIn: _checkIn,
      checkOut: _checkOut,
      guests: _guests,
      timestamp: DateTime.now(),
    );


    context.read<SearchBloc>().add(
      SaveRecentSearchEvent(
        location: recentSearch.location,
        checkIn: recentSearch.checkIn,
        checkOut: recentSearch.checkOut,
        guests: recentSearch.guests,
      ),
    );

    // Create search filter with ONLY the 4 basic filters from search screen
    // FilterText, CheckInDate, CheckOutDate, MaximumNumberOfGuestMax
    final filter = SearchFilter(
      filterText: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      checkInDate: _checkIn?.millisecondsSinceEpoch,
      checkOutDate: _checkOut?.millisecondsSinceEpoch,
      maximumNumberOfGuestMax: _guests,
      // Only these 4 basic filters are set from search screen
      // All other filters (address, price, rooms, features, etc.) are null
      // Additional filters should only be set via the filter screen
    );


    // Update the filter in BLoC before navigation
    context.read<SearchBloc>().add(UpdateFilterEvent(filter: filter));

    // Navigate to results
    Navigator.of(
      context,
    ).pushNamed('/search-results', arguments: {'filter': filter});
  }
}