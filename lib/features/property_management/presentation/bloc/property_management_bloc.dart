import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/managed_property.dart';
import '../../domain/repositories/property_management_repository.dart';
import 'property_management_event.dart';
import 'property_management_state.dart';

class PropertyManagementBloc
    extends Bloc<PropertyManagementEvent, PropertyManagementState> {
  final PropertyManagementRepository repository;

  PropertyManagementBloc({required this.repository})
      : super(const PropertyManagementState()) {
    on<LoadHostPropertiesEvent>(_onLoadHostProperties);
    on<LoadPropertyCalendarEvent>(_onLoadPropertyCalendar);
    on<UpdatePropertyAvailabilityEvent>(_onUpdatePropertyAvailability);
    on<TogglePropertyStatusEvent>(_onTogglePropertyStatus);
    on<SelectPropertyEvent>(_onSelectProperty);
  }

  Future<void> _onLoadHostProperties(
    LoadHostPropertiesEvent event,
    Emitter<PropertyManagementState> emit,
  ) async {
    emit(state.copyWith(isLoadingProperties: true, error: null));

    final result = await repository.getHostProperties();

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingProperties: false,
        error: 'Failed to load properties',
      )),
      (properties) => emit(state.copyWith(
        isLoadingProperties: false,
        properties: properties,
      )),
    );
  }

  Future<void> _onLoadPropertyCalendar(
    LoadPropertyCalendarEvent event,
    Emitter<PropertyManagementState> emit,
  ) async {
    emit(state.copyWith(isLoadingCalendar: true, error: null));

    final result = await repository.getPropertyCalendarStatuses(
      event.propertyId,
      event.startDate,
      event.endDate,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingCalendar: false,
        error: 'Failed to load calendar',
      )),
      (statuses) => emit(state.copyWith(
        isLoadingCalendar: false,
        calendarStatuses: statuses,
      )),
    );
  }

  Future<void> _onUpdatePropertyAvailability(
    UpdatePropertyAvailabilityEvent event,
    Emitter<PropertyManagementState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true, error: null));

    final result = await repository.updatePropertyAvailability(
      event.availabilities,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isUpdating: false,
        error: 'Failed to update availability',
      )),
      (_) {
        emit(state.copyWith(isUpdating: false));
        // Reload calendar after successful update
        if (state.selectedProperty != null) {
          add(LoadPropertyCalendarEvent(
            propertyId: state.selectedProperty!.id,
          ));
        }
      },
    );
  }

  Future<void> _onTogglePropertyStatus(
    TogglePropertyStatusEvent event,
    Emitter<PropertyManagementState> emit,
  ) async {
    emit(state.copyWith(isUpdating: true, error: null));

    final result = await repository.togglePropertyStatus(
      event.propertyId,
      event.isActive,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isUpdating: false,
        error: 'Failed to update property status',
      )),
      (_) {
        // Update the property in the list
        final updatedProperties = state.properties.map((property) {
          if (property.id == event.propertyId) {
            return ManagedProperty(
              id: property.id,
              title: property.title,
              imageUrl: property.imageUrl,
              price: property.price,
              isActive: event.isActive,
              location: property.location,
              totalBookings: property.totalBookings,
              rating: property.rating,
            );
          }
          return property;
        }).toList();

        emit(state.copyWith(
          isUpdating: false,
          properties: updatedProperties,
        ));
      },
    );
  }

  void _onSelectProperty(
    SelectPropertyEvent event,
    Emitter<PropertyManagementState> emit,
  ) {
    final property = state.properties.firstWhere(
      (p) => p.id == event.propertyId,
      orElse: () => state.properties.first,
    );
    emit(state.copyWith(selectedProperty: property));
  }
}
