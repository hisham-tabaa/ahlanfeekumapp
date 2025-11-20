import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../theming/colors.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../../../theming/text_styles.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_event.dart';
import '../../bloc/rent_create_state.dart';

class AvailabilityStep extends StatefulWidget {
  const AvailabilityStep({super.key});

  @override
  State<AvailabilityStep> createState() => _AvailabilityStepState();
}

class _AvailabilityStepState extends State<AvailabilityStep> {
  DateTime _focusedDay = DateTime.now();
  final Set<String> _selectedWeekdays = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
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
              _buildHeader(context),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 32,
                  tablet: 36,
                  desktop: 24,
                ),
              ),
              _buildModifyDateButton(context, state),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 32,
                  tablet: 36,
                  desktop: 24,
                ),
              ),
              _buildWeekdaySelector(context, state),
              SizedBox(
                height: ResponsiveUtils.spacing(
                  context,
                  mobile: 24,
                  tablet: 28,
                  desktop: 20,
                ),
              ),
              _buildAvailableDatesList(context, state),
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
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Available In',
        style: AppTextStyles.h3.copyWith(
          color: AppColors.primary,
          fontSize: ResponsiveUtils.fontSize(
            context,
            mobile: 24,
            tablet: 26,
            desktop: 28,
          ),
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
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
      ),
    );
  }

  Widget _buildModifyDateButton(BuildContext context, RentCreateState state) {
    return GestureDetector(
      onTap: () => _showCalendarDialog(context, state),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.spacing(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
          horizontal: ResponsiveUtils.spacing(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 28,
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
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              'Modify Date',
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
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.all(
                ResponsiveUtils.spacing(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 8,
                    tablet: 9,
                    desktop: 10,
                  ),
                ),
              ),
              child: Icon(
                Icons.calendar_month,
                color: AppColors.primary,
                size: ResponsiveUtils.fontSize(
                  context,
                  mobile: 20,
                  tablet: 21,
                  desktop: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdaySelector(BuildContext context, RentCreateState state) {
    const weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available In These Days',
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
            mobile: 8,
            tablet: 9,
            desktop: 10,
          ),
          runSpacing: ResponsiveUtils.spacing(
            context,
            mobile: 8,
            tablet: 9,
            desktop: 10,
          ),
          children: weekdays.map((weekday) {
            final isSelected = _selectedWeekdays.contains(weekday);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedWeekdays.remove(weekday);
                  } else {
                    _selectedWeekdays.add(weekday);
                  }
                });
                _updateAvailabilityBasedOnWeekdays(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing(
                    context,
                    mobile: 16,
                    tablet: 17,
                    desktop: 18,
                  ),
                  vertical: ResponsiveUtils.spacing(
                    context,
                    mobile: 8,
                    tablet: 9,
                    desktop: 10,
                  ),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.radius(
                      context,
                      mobile: 20,
                      tablet: 21,
                      desktop: 22,
                    ),
                  ),
                ),
                child: Text(
                  weekday,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontSize: ResponsiveUtils.fontSize(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 14,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailableDatesList(BuildContext context, RentCreateState state) {
    final now = DateTime.now();
    final startOfNext7Days = now;
    final endOfNext7Days = now.add(const Duration(days: 6));

    // Get next 7 days that are NOT selected
    final unselectedNext7Days = <DateTime>[];
    for (
      var date = startOfNext7Days;
      date.isBefore(endOfNext7Days.add(const Duration(days: 1)));
      date = date.add(const Duration(days: 1))
    ) {
      // Check if this date is not selected
      final isSelected = state.formData.availableDates.any(
        (selectedDate) => isSameDay(selectedDate, date),
      );
      if (!isSelected) {
        unselectedNext7Days.add(date);
      }
    }

    // Get selected dates for display
    final selectedDates = List<DateTime>.from(state.formData.availableDates);
    selectedDates.sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show selected dates
        if (selectedDates.isNotEmpty) ...[
          Text(
            'Selected Dates',
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
          ...selectedDates.map((date) {
            final dayName = _getDayName(date);
            final formattedDate = _formatDate(date);

            return Container(
              margin: EdgeInsets.only(
                bottom: ResponsiveUtils.spacing(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              padding: EdgeInsets.symmetric(
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 8,
                    tablet: 9,
                    desktop: 10,
                  ),
                ),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 6,
                        tablet: 7,
                        desktop: 8,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 6,
                          tablet: 7,
                          desktop: 8,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: ResponsiveUtils.fontSize(
                        context,
                        mobile: 16,
                        tablet: 17,
                        desktop: 18,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayName,
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
                        Text(
                          formattedDate,
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
                  GestureDetector(
                    onTap: () {
                      context.read<RentCreateBloc>().add(
                        RemoveAvailableDateEvent(date),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(
                        ResponsiveUtils.spacing(
                          context,
                          mobile: 6,
                          tablet: 7,
                          desktop: 8,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: ResponsiveUtils.fontSize(
                          context,
                          mobile: 18,
                          tablet: 19,
                          desktop: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          if (unselectedNext7Days.isNotEmpty)
            SizedBox(
              height: ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
            ),
        ],

        // Show unselected dates from next 7 days
        if (unselectedNext7Days.isNotEmpty) ...[
          Text(
            'Available Next 7 Days',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
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
          ...unselectedNext7Days.map((date) {
            final dayName = _getDayName(date);
            final formattedDate = _formatDate(date);

            return Container(
              margin: EdgeInsets.only(
                bottom: ResponsiveUtils.spacing(
                  context,
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              padding: EdgeInsets.symmetric(
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
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 8,
                    tablet: 9,
                    desktop: 10,
                  ),
                ),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(
                        context,
                        mobile: 6,
                        tablet: 7,
                        desktop: 8,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius(
                          context,
                          mobile: 6,
                          tablet: 7,
                          desktop: 8,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey[500],
                      size: ResponsiveUtils.fontSize(
                        context,
                        mobile: 16,
                        tablet: 17,
                        desktop: 18,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.grey[600],
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              mobile: 14,
                              tablet: 15,
                              desktop: 16,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[500],
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
            );
          }).toList(),
        ],

        // Empty state
        if (selectedDates.isEmpty && unselectedNext7Days.isEmpty)
          Container(
            padding: EdgeInsets.all(
              ResponsiveUtils.spacing(
                context,
                mobile: 24,
                tablet: 26,
                desktop: 28,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: ResponsiveUtils.fontSize(
                      context,
                      mobile: 48,
                      tablet: 52,
                      desktop: 56,
                    ),
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    height: ResponsiveUtils.spacing(
                      context,
                      mobile: 16,
                      tablet: 17,
                      desktop: 18,
                    ),
                  ),
                  Text(
                    'No dates available in next 7 days',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 16,
                        tablet: 17,
                        desktop: 18,
                      ),
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
                    'Select weekdays or use the calendar for future dates',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[500],
                      fontSize: ResponsiveUtils.fontSize(
                        context,
                        mobile: 12,
                        tablet: 13,
                        desktop: 14,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _updateAvailabilityBasedOnWeekdays(BuildContext context) {
    final bloc = context.read<RentCreateBloc>();
    final now = DateTime.now();
    final startOfNext7Days = now;
    final endOfNext7Days = now.add(const Duration(days: 6));

    // Only remove dates from next 7 days that were added by weekday selection
    final currentDates = List<DateTime>.from(
      bloc.state.formData.availableDates,
    );
    for (final date in currentDates) {
      // Only remove if it's in next 7 days (likely added by weekday selection)
      if (date.isAfter(startOfNext7Days.subtract(const Duration(days: 1))) &&
          date.isBefore(endOfNext7Days.add(const Duration(days: 1)))) {
        final weekdayName = _getWeekdayName(date.weekday);
        if (!_selectedWeekdays.contains(weekdayName)) {
          bloc.add(RemoveAvailableDateEvent(date));
        }
      }
    }

    // Add dates for selected weekdays in next 7 days only
    for (
      var date = startOfNext7Days;
      date.isBefore(endOfNext7Days.add(const Duration(days: 1)));
      date = date.add(const Duration(days: 1))
    ) {
      final weekdayName = _getWeekdayName(date.weekday);
      if (_selectedWeekdays.contains(weekdayName)) {
        // Check if not already added
        final isAlreadySelected = bloc.state.formData.availableDates.any(
          (existingDate) => isSameDay(existingDate, date),
        );
        if (!isAlreadySelected) {
          bloc.add(AddAvailableDateEvent(date));
        }
      }
    }
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[weekday - 1];
  }

  String _getDayName(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[date.weekday - 1];
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} - ${months[date.month - 1]} - ${date.year}';
  }

  void _showCalendarDialog(BuildContext context, RentCreateState state) {
    // Get the bloc instance from the current context
    final bloc = context.read<RentCreateBloc>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtils.radius(
                    context,
                    mobile: 16,
                    tablet: 17,
                    desktop: 18,
                  ),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(
                    context,
                    mobile: 20,
                    tablet: 24,
                    desktop: 28,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.radius(
                      context,
                      mobile: 16,
                      tablet: 17,
                      desktop: 18,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Available Dates',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          mobile: 18,
                          tablet: 19,
                          desktop: 20,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 20,
                        tablet: 21,
                        desktop: 22,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.radius(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 16,
                          ),
                        ),
                        child: StreamBuilder<RentCreateState>(
                          stream: bloc.stream,
                          initialData: bloc.state,
                          builder: (context, snapshot) {
                            final currentState = snapshot.data ?? bloc.state;

                            return TableCalendar<DateTime>(
                              firstDay: DateTime.now(),
                              lastDay: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              focusedDay: _focusedDay,
                              selectedDayPredicate: (day) {
                                return currentState.formData.availableDates.any(
                                  (date) => isSameDay(date, day),
                                );
                              },
                              calendarFormat: CalendarFormat.month,
                              startingDayOfWeek: StartingDayOfWeek.sunday,
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                titleTextStyle: AppTextStyles.h4.copyWith(
                                  color: AppColors.primary,
                                  fontSize: ResponsiveUtils.fontSize(
                                    context,
                                    mobile: 16,
                                    tablet: 17,
                                    desktop: 18,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                                leftChevronIcon: Icon(
                                  Icons.chevron_left,
                                  color: AppColors.primary,
                                  size: ResponsiveUtils.fontSize(
                                    context,
                                    mobile: 20,
                                    tablet: 21,
                                    desktop: 22,
                                  ),
                                ),
                                rightChevronIcon: Icon(
                                  Icons.chevron_right,
                                  color: AppColors.primary,
                                  size: ResponsiveUtils.fontSize(
                                    context,
                                    mobile: 20,
                                    tablet: 21,
                                    desktop: 22,
                                  ),
                                ),
                              ),
                              daysOfWeekStyle: DaysOfWeekStyle(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                weekdayStyle: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: ResponsiveUtils.fontSize(
                                    context,
                                    mobile: 12,
                                    tablet: 13,
                                    desktop: 14,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                                weekendStyle: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: ResponsiveUtils.fontSize(
                                    context,
                                    mobile: 12,
                                    tablet: 13,
                                    desktop: 14,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              calendarStyle: CalendarStyle(
                                outsideDaysVisible: false,
                                tableBorder: TableBorder.all(
                                  color: Colors.transparent,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                todayDecoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                defaultTextStyle: AppTextStyles.bodySmall
                                    .copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: ResponsiveUtils.fontSize(
                                        context,
                                        mobile: 14,
                                        tablet: 15,
                                        desktop: 16,
                                      ),
                                    ),
                                weekendTextStyle: AppTextStyles.bodySmall
                                    .copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: ResponsiveUtils.fontSize(
                                        context,
                                        mobile: 14,
                                        tablet: 15,
                                        desktop: 16,
                                      ),
                                    ),
                                defaultDecoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                weekendDecoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _focusedDay = focusedDay;
                                });

                                final isAlreadySelected = currentState
                                    .formData
                                    .availableDates
                                    .any(
                                      (date) => isSameDay(date, selectedDay),
                                    );

                                if (isAlreadySelected) {
                                  bloc.add(
                                    RemoveAvailableDateEvent(selectedDay),
                                  );
                                } else {
                                  bloc.add(AddAvailableDateEvent(selectedDay));
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 20,
                        tablet: 21,
                        desktop: 22,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveUtils.spacing(
                              context,
                              mobile: 12,
                              tablet: 13,
                              desktop: 14,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.radius(
                                context,
                                mobile: 8,
                                tablet: 9,
                                desktop: 10,
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          'Done',
                          style: AppTextStyles.bodyMedium.copyWith(
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
              ),
            );
          },
        );
      },
    );
  }
}
