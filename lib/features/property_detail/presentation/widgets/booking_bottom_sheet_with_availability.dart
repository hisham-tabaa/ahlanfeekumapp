import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../data/models/property_availability_models.dart';
import 'availability_calendar_widget.dart';

class BookingBottomSheetWithAvailability extends StatefulWidget {
  final double pricePerNight;
  final String propertyId;
  final List<PropertyAvailabilityItem> availabilityData;
  final Function(DateTime checkIn, DateTime checkOut, int guests, String notes)
  onBook;

  const BookingBottomSheetWithAvailability({
    super.key,
    required this.pricePerNight,
    required this.propertyId,
    required this.availabilityData,
    required this.onBook,
  });

  @override
  State<BookingBottomSheetWithAvailability> createState() =>
      _BookingBottomSheetWithAvailabilityState();
}

class _BookingBottomSheetWithAvailabilityState
    extends State<BookingBottomSheetWithAvailability> {
  bool _isExpanded = false;
  bool _agreeToTerms = false;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _adults = 2;
  int _children = 0;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _totalNights {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    final nights = _checkOutDate!.difference(_checkInDate!).inDays;
    // Minimum 1 night for same day or consecutive day bookings
    return nights < 1 ? 1 : nights;
  }

  double get _subtotal => widget.pricePerNight * _totalNights;
  double get _total => _subtotal;

  int get _totalGuests => _adults + _children;

  /// Validates that all dates in the selected range are available.
  ///
  /// **IMPORTANT:** This is a client-side validation as an extra safety measure.
  /// The backend should ALSO validate availability before creating the reservation.
  ///
  /// This prevents users from booking dates that:
  /// - Are marked as unavailable by the host
  /// - Have existing approved reservations (if backend is fixed)
  bool _validateDateAvailability() {
    if (_checkInDate == null || _checkOutDate == null) {
      return false;
    }

    // Create a map of available dates for quick lookup
    final availabilityMap = <String, bool>{};
    for (var item in widget.availabilityData) {
      // Only consider dates for this property
      if (item.propertyId == widget.propertyId) {
        availabilityMap[item.date] = item.isAvailable;
      }
    }

    // Check each date in the range
    DateTime currentDate = _checkInDate!;
    final dateFormat = DateFormat('yyyy-MM-dd');

    while (currentDate.isBefore(_checkOutDate!) ||
        currentDate.isAtSameMomentAs(_checkOutDate!)) {
      final dateStr = dateFormat.format(currentDate);
      // CRITICAL FIX: Default to false (unavailable) if not in API response
      // Only dates explicitly marked as available should be bookable
      final isAvailable = availabilityMap[dateStr] ?? false;

      if (!isAvailable) {
        return false;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return true;
  }

  /// Shows an error dialog when dates are not available
  void _showUnavailableDatesError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 8),
            Text('dates_not_available'.tr()),
          ],
        ),
        content: const Text(
          'Some of the selected dates are no longer available. '
          'Please select different dates.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }

  void _showCalendarDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'select_dates'.tr(),
                    style: AppTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Calendar
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                ),
                child: AvailabilityCalendarWidget(
                  propertyId: widget.propertyId,
                  availabilityData: widget.availabilityData,
                  initialCheckIn: _checkInDate,
                  initialCheckOut: _checkOutDate,
                  onDatesSelected: (checkIn, checkOut) {
                    setState(() {
                      _checkInDate = checkIn;
                      _checkOutDate = checkOut;
                    });
                  },
                ),
              ),
            ),

            // Done button
            Padding(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkInDate != null
                      ? () {
                          // If only check-in selected, auto-set checkout to next day for 1-night booking
                          if (_checkOutDate == null) {
                            final nextDay = _checkInDate!.add(
                              const Duration(days: 1),
                            );
                            setState(() {
                              _checkOutDate = nextDay;
                            });
                          }
                          Navigator.pop(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 20,
                      ),
                    ),
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
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(
                    _checkInDate != null && _checkOutDate != null
                        ? '${'confirm'.tr()} ($_totalNights ${'night'.tr()}${_totalNights != 1 ? 's' : ''})'
                        : _checkInDate != null
                        ? '${'confirm'.tr()} (1 ${'night'.tr()})'
                        : 'select_dates'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGuestsSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            ResponsiveUtils.radius(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
          ),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.all(
              ResponsiveUtils.spacing(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 28,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'select_guests'.tr(),
                  style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                ),
                _buildGuestCounter('adults'.tr(), _adults, (value) {
                  setModalState(() => _adults = value);
                  setState(() {});
                }),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                ),
                _buildGuestCounter('children'.tr(), _children, (value) {
                  setModalState(() => _children = value);
                  setState(() {});
                }),
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.spacing(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        ),
                      ),
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
                    child: Text('done'.tr()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGuestCounter(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            IconButton(
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
              icon: Container(
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(
                    context,
                    mobile: 4,
                    tablet: 5,
                    desktop: 6,
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.radius(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                  ),
                ),
                child: const Icon(Icons.remove, size: 20),
              ),
            ),
            SizedBox(
              width: ResponsiveUtils.size(
                context,
                mobile: 40,
                tablet: 45,
                desktop: 50,
              ),
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () => onChanged(value + 1),
              icon: Container(
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(
                    context,
                    mobile: 4,
                    tablet: 5,
                    desktop: 6,
                  ),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.radius(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 12,
                    ),
                  ),
                ),
                child: const Icon(Icons.add, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with price and expand button
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.pricePerNight.toStringAsFixed(2)} \$ / Night',
                        style: AppTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    icon: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              // Expanded content
              if (_isExpanded) ...[
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                ),

                // Date selection button
                GestureDetector(
                  onTap: _showCalendarDialog,
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
                      border: Border.all(color: AppColors.primary, width: 2),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                      color: AppColors.primary.withValues(alpha: 0.05),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: AppColors.primary,
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
                                'select_your_dates'.tr(),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _checkInDate != null && _checkOutDate != null
                                    ? '${DateFormat('MMM d').format(_checkInDate!)} - ${DateFormat('MMM d, yyyy').format(_checkOutDate!)} ($_totalNights ${'night'.tr()}${_totalNights != 1 ? 's' : ''})'
                                    : 'tap_view_dates'.tr(),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ],
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

                // Guests selector
                GestureDetector(
                  onTap: _showGuestsSelector,
                  child: Container(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'guests'.tr(),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
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
                              '$_adults Adult${_adults != 1 ? 's' : ''}, $_children Child${_children != 1 ? 'ren' : ''}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary,
                        ),
                      ],
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

                // Notes field
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'special_requests'.tr(),
                    hintText: 'add_special_requests'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                  ),
                  maxLines: 3,
                ),

                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                ),

                // Price breakdown
                if (_totalNights > 0) ...[
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 12,
                          tablet: 14,
                          desktop: 16,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'price_breakdown'.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
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
                        _buildPriceRow(
                          '${widget.pricePerNight.toStringAsFixed(0)} × $_totalNights ${'night'.tr()}${_totalNights != 1 ? 's' : ''}',
                          '${_total.toStringAsFixed(2)} \$',
                          isBold: true,
                        ),
                      ],
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
                ],

                // Agreement checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                    Expanded(child: Text('i_agree_terms'.tr())),
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

                // Book Now Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (_checkInDate != null &&
                            _checkOutDate != null &&
                            _agreeToTerms &&
                            _totalGuests > 0)
                        ? () {
                            // CRITICAL: Validate date availability before booking
                            // This is a client-side safety check
                            if (!_validateDateAvailability()) {
                              _showUnavailableDatesError();
                              return;
                            }

                            // Proceed with booking
                            widget.onBook(
                              _checkInDate!,
                              _checkOutDate!,
                              _totalGuests,
                              _notesController.text,
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.spacing(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                      ),
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
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_online,
                          color: Colors.white,
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
                        Text('book_now'.tr()),
                      ],
                    ),
                  ),
                ),
              ],

              // See Details button (when collapsed)
              if (!_isExpanded) ...[
                SizedBox(
                  height: ResponsiveUtils.spacing(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.spacing(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 18,
                        ),
                      ),
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
                    child: Text('see_details'.tr()),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isBold = false,
    bool isDiscount = false,
  }) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDiscount ? Colors.red : AppColors.textPrimary,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
