import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../data/models/property_availability_models.dart';

class AvailabilityCalendarWidget extends StatefulWidget {
  final String propertyId;
  final List<PropertyAvailabilityItem> availabilityData;
  final Function(DateTime? checkIn, DateTime? checkOut) onDatesSelected;
  final DateTime? initialCheckIn;
  final DateTime? initialCheckOut;

  const AvailabilityCalendarWidget({
    super.key,
    required this.propertyId,
    required this.availabilityData,
    required this.onDatesSelected,
    this.initialCheckIn,
    this.initialCheckOut,
  });

  @override
  State<AvailabilityCalendarWidget> createState() =>
      _AvailabilityCalendarWidgetState();
}

class _AvailabilityCalendarWidgetState
    extends State<AvailabilityCalendarWidget> {
  late DateTime _focusedDay;
  DateTime? _selectedCheckIn;
  DateTime? _selectedCheckOut;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Cache for availability lookup
  late Map<String, bool> _availabilityMap;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedCheckIn = widget.initialCheckIn;
    _selectedCheckOut = widget.initialCheckOut;
    _buildAvailabilityMap();
  }

  @override
  void didUpdateWidget(AvailabilityCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.availabilityData != widget.availabilityData) {
      _buildAvailabilityMap();
    }
  }

  void _buildAvailabilityMap() {
    _availabilityMap = {};
    for (var item in widget.availabilityData) {
      _availabilityMap[item.date] = item.isAvailable;
    }
  }

  bool _isDateAvailable(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    // CRITICAL FIX: If no explicit availability data, assume UNAVAILABLE
    // Only dates explicitly marked as available by the API should be bookable
    // This prevents booking dates that:
    // - Have approved reservations (when backend is fixed)
    // - Are not set by the host as available
    return _availabilityMap[dateStr] ?? false;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Don't allow selecting past dates
    if (selectedDay.isBefore(
      DateTime.now().subtract(const Duration(days: 1)),
    )) {
      return;
    }

    // Check if date is available
    if (!_isDateAvailable(selectedDay)) {
      _showUnavailableDialog(selectedDay);
      return;
    }

    setState(() {
      _focusedDay = focusedDay;

      // Logic for check-in and check-out selection
      if (_selectedCheckIn == null ||
          (_selectedCheckIn != null && _selectedCheckOut != null)) {
        // Start new selection
        _selectedCheckIn = selectedDay;
        _selectedCheckOut = null;
      } else if (_selectedCheckIn != null && _selectedCheckOut == null) {
        // Select check-out date
        // Allow same day selection for one-night booking (checkout next day is implicit)
        if (selectedDay.isAfter(_selectedCheckIn!) ||
            selectedDay.isAtSameMomentAs(_selectedCheckIn!)) {
          // For same day: checkout is next day (1 night stay)
          if (selectedDay.isAtSameMomentAs(_selectedCheckIn!)) {
            // Same day selected - set checkout to next day
            final nextDay = selectedDay.add(const Duration(days: 1));
            if (_isDateAvailable(nextDay) ||
                !_availabilityMap.containsKey(
                  DateFormat('yyyy-MM-dd').format(nextDay),
                )) {
              _selectedCheckOut = nextDay;
            } else {
              _showUnavailableDialog(nextDay);
              return;
            }
          } else {
            // Validate all dates in range are available
            if (_areAllDatesAvailableInRange(_selectedCheckIn!, selectedDay)) {
              _selectedCheckOut = selectedDay;
            } else {
              _showRangeUnavailableDialog();
              return;
            }
          }
        } else {
          // If selected date is before check-in, make it the new check-in
          _selectedCheckIn = selectedDay;
          _selectedCheckOut = null;
        }
      }
    });

    widget.onDatesSelected(_selectedCheckIn, _selectedCheckOut);
  }

  bool _areAllDatesAvailableInRange(DateTime start, DateTime end) {
    DateTime current = start;
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if (!_isDateAvailable(current)) {
        return false;
      }
      current = current.add(const Duration(days: 1));
    }
    return true;
  }

  void _showUnavailableDialog(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.event_busy, color: Colors.red[700]),
            const SizedBox(width: 8),
            const Text('Date Unavailable'),
          ],
        ),
        content: const Text(
          'Sorry, the selected date is not available for booking.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRangeUnavailableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.event_busy, color: Colors.red[700]),
            const SizedBox(width: 8),
            const Text('Range Unavailable'),
          ],
        ),
        content: const Text(
          'Some dates in the selected range are not available. Please choose different dates.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 16, tablet: 18, desktop: 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 16, tablet: 18, desktop: 20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Legend
          _buildLegend(),
          SizedBox(
            height: ResponsiveUtils.spacing(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),

          // Calendar
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedCheckIn, day) ||
                  isSameDay(_selectedCheckOut, day);
            },
            rangeStartDay: _selectedCheckIn,
            rangeEndDay: _selectedCheckOut,
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              // Available dates (default)
              defaultDecoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: const TextStyle(color: Colors.black87),

              // Unavailable dates
              disabledDecoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              disabledTextStyle: TextStyle(color: Colors.red.shade300),

              // Today
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),

              // Selected dates (check-in/check-out)
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              // Range
              rangeStartDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              rangeHighlightColor: AppColors.primary.withValues(alpha: 0.2),

              // Weekend
              weekendTextStyle: const TextStyle(color: Colors.black87),

              // Outside month
              outsideDecoration: const BoxDecoration(),
              outsideTextStyle: TextStyle(color: Colors.grey.shade400),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              formatButtonTextStyle: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              titleTextStyle: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              weekendStyle: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isAvailable = _isDateAvailable(day);
                return _buildCalendarDay(day, isAvailable, false, false);
              },
              todayBuilder: (context, day, focusedDay) {
                final isAvailable = _isDateAvailable(day);
                return _buildCalendarDay(day, isAvailable, true, false);
              },
              disabledBuilder: (context, day, focusedDay) {
                return _buildCalendarDay(day, false, false, true);
              },
            ),
            enabledDayPredicate: (day) {
              // Disable past dates
              if (day.isBefore(
                DateTime.now().subtract(const Duration(days: 1)),
              )) {
                return false;
              }
              // CRITICAL FIX: Check if date is available from API
              // This prevents users from selecting unavailable/booked dates
              return _isDateAvailable(day);
            },
          ),

          // Selected dates info
          if (_selectedCheckIn != null) ...[
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
            _buildSelectedDatesInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(Colors.green.shade100, 'Available'),
        _buildLegendItem(Colors.red.shade100, 'Unavailable'),
        _buildLegendItem(AppColors.primary, 'Selected'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarDay(
    DateTime day,
    bool isAvailable,
    bool isToday,
    bool isDisabled,
  ) {
    Color backgroundColor;
    if (isDisabled) {
      backgroundColor = Colors.grey.shade200;
    } else if (!isAvailable) {
      backgroundColor = Colors.red.shade50;
    } else {
      backgroundColor = Colors.green.shade50;
    }

    if (isToday) {
      backgroundColor = AppColors.primary.withValues(alpha: 0.3);
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: isDisabled
                ? Colors.grey.shade400
                : !isAvailable
                ? Colors.red.shade400
                : Colors.black87,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDatesInfo() {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.spacing(context, mobile: 12, tablet: 14, desktop: 16),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.radius(context, mobile: 12, tablet: 14, desktop: 16),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check-in',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy').format(_selectedCheckIn!),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (_selectedCheckOut != null) ...[
                const Icon(Icons.arrow_forward, color: AppColors.primary),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Check-out',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d, yyyy').format(_selectedCheckOut!),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          if (_selectedCheckOut != null) ...[
            const SizedBox(height: 8),
            Text(
              '${_selectedCheckOut!.difference(_selectedCheckIn!).inDays} night(s)',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
