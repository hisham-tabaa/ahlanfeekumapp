import 'package:equatable/equatable.dart';
import '../../domain/entities/property_calendar_status.dart';

abstract class PropertyManagementEvent extends Equatable {
  const PropertyManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadHostPropertiesEvent extends PropertyManagementEvent {
  const LoadHostPropertiesEvent();
}

class LoadPropertyCalendarEvent extends PropertyManagementEvent {
  final String propertyId;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadPropertyCalendarEvent({
    required this.propertyId,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [propertyId, startDate, endDate];
}

class UpdatePropertyAvailabilityEvent extends PropertyManagementEvent {
  final List<PropertyCalendarStatus> availabilities;

  const UpdatePropertyAvailabilityEvent({required this.availabilities});

  @override
  List<Object?> get props => [availabilities];
}

class TogglePropertyStatusEvent extends PropertyManagementEvent {
  final String propertyId;
  final bool isActive;

  const TogglePropertyStatusEvent({
    required this.propertyId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [propertyId, isActive];
}

class SelectPropertyEvent extends PropertyManagementEvent {
  final String propertyId;

  const SelectPropertyEvent({required this.propertyId});

  @override
  List<Object?> get props => [propertyId];
}
