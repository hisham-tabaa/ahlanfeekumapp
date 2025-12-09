import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';
import '../../domain/entities/managed_property.dart';
import '../../domain/entities/property_calendar_status.dart';
import '../bloc/property_management_bloc.dart';
import '../bloc/property_management_event.dart';
import '../bloc/property_management_state.dart';

class PropertyCalendarScreen extends StatefulWidget {
  final ManagedProperty property;

  const PropertyCalendarScreen({
    super.key,
    required this.property,
  });

  @override
  State<PropertyCalendarScreen> createState() => _PropertyCalendarScreenState();
}

class _PropertyCalendarScreenState extends State<PropertyCalendarScreen> {
  late final ValueNotifier<DateTime> _focusedDay;
  late final ValueNotifier<DateTime?> _selectedDay;
  late final ValueNotifier<CalendarFormat> _calendarFormat;
  late DateTime _firstDay;
  late DateTime _lastDay;
  
  final Map<DateTime, List<PropertyCalendarStatus>> _events = {};
  final Set<DateTime> _selectedDates = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = ValueNotifier(now);
    _selectedDay = ValueNotifier(now);
    _calendarFormat = ValueNotifier(CalendarFormat.month);
    _firstDay = DateTime(now.year - 1, now.month, now.day);
    _lastDay = DateTime(now.year + 2, now.month, now.day);
    
    // Load calendar data
    context.read<PropertyManagementBloc>().add(
          LoadPropertyCalendarEvent(
            propertyId: widget.property.id,
          ),
        );
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedDay.dispose();
    _calendarFormat.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay.value = selectedDay;
      _focusedDay.value = focusedDay;
      
      // Toggle selection
      if (_selectedDates.contains(selectedDay)) {
        _selectedDates.remove(selectedDay);
      } else {
        _selectedDates.add(selectedDay);
      }
    });
  }

  void _updateAvailability(bool isAvailable) {
    if (_selectedDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select dates to update'),
        ),
      );
      return;
    }

    final availabilities = _selectedDates.map((date) {
      return PropertyCalendarStatus(
        propertyId: widget.property.id,
        date: date,
        isAvailable: isAvailable,
        price: widget.property.price,
      );
    }).toList();

    context.read<PropertyManagementBloc>().add(
          UpdatePropertyAvailabilityEvent(
            availabilities: availabilities,
          ),
        );

    // Clear selection after update
    setState(() {
      _selectedDates.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property.title),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: AppColors.textPrimary,
          fontSize: ResponsiveUtils.fontSize(
            context,
            mobile: 18,
            tablet: 20,
            desktop: 22,
          ),
        ),
        actions: [
          // Property Status Toggle
          Padding(
            padding: EdgeInsets.only(
              right: ResponsiveUtils.spacing(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              ),
            ),
            child: Row(
              children: [
                Text(
                  widget.property.isActive ? 'Active' : 'Inactive',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: widget.property.isActive
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                Switch(
                  value: widget.property.isActive,
                  onChanged: (value) {
                    context.read<PropertyManagementBloc>().add(
                          TogglePropertyStatusEvent(
                            propertyId: widget.property.id,
                            isActive: value,
                          ),
                        );
                  },
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<PropertyManagementBloc, PropertyManagementState>(
        builder: (context, state) {
          if (state.isLoadingCalendar) {
            return const Center(child: CircularProgressIndicator());
          }

          // Process calendar data
          _events.clear();
          for (final status in state.calendarStatuses) {
            final dateKey = DateTime(
              status.date.year,
              status.date.month,
              status.date.day,
            );
            if (!_events.containsKey(dateKey)) {
              _events[dateKey] = [];
            }
            _events[dateKey]!.add(status);
          }

          return Column(
            children: [
              // Calendar
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Calendar Widget
                      Container(
                        margin: EdgeInsets.all(
                          ResponsiveUtils.spacing(
                            context,
                            mobile: 16,
                            tablet: 20,
                            desktop: 24,
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
                              color: Colors.grey.withValues(alpha: 0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ValueListenableBuilder<CalendarFormat>(
                          valueListenable: _calendarFormat,
                          builder: (context, format, _) {
                            return TableCalendar<PropertyCalendarStatus>(
                              key: ValueKey(state.calendarStatuses.length), // Force rebuild when data changes
                              firstDay: _firstDay,
                              lastDay: _lastDay,
                              focusedDay: _focusedDay.value,
                              calendarFormat: format,
                              selectedDayPredicate: (day) {
                                return _selectedDates.contains(day);
                              },
                              eventLoader: (day) {
                                final normalizedDay = DateTime(day.year, day.month, day.day);
                                final events = _events[normalizedDay] ?? [];
                                if (events.isNotEmpty) {
                                }
                                return events;
                              },
                              startingDayOfWeek: StartingDayOfWeek.sunday,
                              calendarStyle: CalendarStyle(
                                outsideDaysVisible: false,
                                selectedDecoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                todayDecoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                markerDecoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                                cellMargin: EdgeInsets.all(
                                  ResponsiveUtils.spacing(
                                    context,
                                    mobile: 4,
                                    tablet: 5,
                                    desktop: 6,
                                  ),
                                ),
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: true,
                                titleCentered: true,
                                formatButtonDecoration: BoxDecoration(
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
                                formatButtonTextStyle: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: ResponsiveUtils.fontSize(
                                    context,
                                    mobile: 14,
                                    tablet: 15,
                                    desktop: 16,
                                  ),
                                ),
                              ),
                              onDaySelected: _onDaySelected,
                              onFormatChanged: (format) {
                                _calendarFormat.value = format;
                              },
                              onPageChanged: (focusedDay) {
                                _focusedDay.value = focusedDay;
                              },
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, day, focusedDay) {
                                  final normalizedDay = DateTime(day.year, day.month, day.day);
                                  final events = _events[normalizedDay] ?? [];
                                  
                                  if (events.isEmpty) return null;
                                  
                                  final status = events.first;
                                  Color backgroundColor;
                                  Color textColor = Colors.white;
                                  
                                  if (status.isBooked) {
                                    backgroundColor = Colors.red.withValues(alpha: 0.7);
                                  } else if (status.isAvailable) {
                                    backgroundColor = Colors.green.withValues(alpha: 0.7);
                                  } else {
                                    backgroundColor = Colors.grey.withValues(alpha: 0.7);
                                  }
                                  
                                  return Container(
                                    margin: EdgeInsets.all(
                                      ResponsiveUtils.spacing(
                                        context,
                                        mobile: 4,
                                        tablet: 5,
                                        desktop: 6,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Legend
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.spacing(
                            context,
                            mobile: 16,
                            tablet: 20,
                            desktop: 24,
                          ),
                        ),
                        padding: EdgeInsets.all(
                          ResponsiveUtils.spacing(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildLegendItem('Available', Colors.green),
                            _buildLegendItem('Unavailable', Colors.grey),
                            _buildLegendItem('Booked', Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Action Buttons
              if (_selectedDates.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 20,
                      desktop: 24,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Text(
                          '${_selectedDates.length} dates selected',
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
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: state.isUpdating
                                    ? null
                                    : () => _updateAvailability(false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(
                                    vertical: ResponsiveUtils.spacing(
                                      context,
                                      mobile: 12,
                                      tablet: 14,
                                      desktop: 16,
                                    ),
                                  ),
                                ),
                                child: state.isUpdating
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Mark Unavailable'),
                              ),
                            ),
                            SizedBox(
                              width: ResponsiveUtils.spacing(
                                context,
                                mobile: 12,
                                tablet: 16,
                                desktop: 20,
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: state.isUpdating
                                    ? null
                                    : () => _updateAvailability(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                    vertical: ResponsiveUtils.spacing(
                                      context,
                                      mobile: 12,
                                      tablet: 14,
                                      desktop: 16,
                                    ),
                                  ),
                                ),
                                child: state.isUpdating
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Mark Available'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: ResponsiveUtils.size(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
          height: ResponsiveUtils.size(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
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
          label,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}
