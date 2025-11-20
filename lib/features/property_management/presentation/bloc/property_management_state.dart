import 'package:equatable/equatable.dart';
import '../../domain/entities/managed_property.dart';
import '../../domain/entities/property_calendar_status.dart';

class PropertyManagementState extends Equatable {
  final List<ManagedProperty> properties;
  final List<PropertyCalendarStatus> calendarStatuses;
  final ManagedProperty? selectedProperty;
  final bool isLoadingProperties;
  final bool isLoadingCalendar;
  final bool isUpdating;
  final String? error;

  const PropertyManagementState({
    this.properties = const [],
    this.calendarStatuses = const [],
    this.selectedProperty,
    this.isLoadingProperties = false,
    this.isLoadingCalendar = false,
    this.isUpdating = false,
    this.error,
  });

  PropertyManagementState copyWith({
    List<ManagedProperty>? properties,
    List<PropertyCalendarStatus>? calendarStatuses,
    ManagedProperty? selectedProperty,
    bool? isLoadingProperties,
    bool? isLoadingCalendar,
    bool? isUpdating,
    String? error,
  }) {
    return PropertyManagementState(
      properties: properties ?? this.properties,
      calendarStatuses: calendarStatuses ?? this.calendarStatuses,
      selectedProperty: selectedProperty ?? this.selectedProperty,
      isLoadingProperties: isLoadingProperties ?? this.isLoadingProperties,
      isLoadingCalendar: isLoadingCalendar ?? this.isLoadingCalendar,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        properties,
        calendarStatuses,
        selectedProperty,
        isLoadingProperties,
        isLoadingCalendar,
        isUpdating,
        error,
      ];
}
