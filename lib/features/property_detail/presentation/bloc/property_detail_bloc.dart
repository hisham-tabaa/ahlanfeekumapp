import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_property_detail_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/rate_property_usecase.dart';
import '../../domain/usecases/get_property_availability_usecase.dart';
import 'property_detail_event.dart';
import 'property_detail_state.dart';

class PropertyDetailBloc
    extends Bloc<PropertyDetailEvent, PropertyDetailState> {
  final GetPropertyDetailUseCase _getPropertyDetailUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final RatePropertyUseCase _ratePropertyUseCase;
  final GetPropertyAvailabilityUseCase _getPropertyAvailabilityUseCase;

  PropertyDetailBloc({
    required GetPropertyDetailUseCase getPropertyDetailUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
    required RatePropertyUseCase ratePropertyUseCase,
    required GetPropertyAvailabilityUseCase getPropertyAvailabilityUseCase,
  }) : _getPropertyDetailUseCase = getPropertyDetailUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase,
       _ratePropertyUseCase = ratePropertyUseCase,
       _getPropertyAvailabilityUseCase = getPropertyAvailabilityUseCase,
       super(PropertyDetailState.initial()) {
    on<LoadPropertyDetailEvent>(_onLoadPropertyDetail);
    on<LoadPropertyAvailabilityEvent>(_onLoadPropertyAvailability);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<RatePropertyEvent>(_onRateProperty);
  }

  Future<void> _onLoadPropertyDetail(
    LoadPropertyDetailEvent event,
    Emitter<PropertyDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getPropertyDetailUseCase(event.propertyId);

    result.fold(
      (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
      (propertyDetail) {
        emit(state.copyWith(isLoading: false, propertyDetail: propertyDetail));
        // Automatically load availability data when property is loaded
        add(LoadPropertyAvailabilityEvent(event.propertyId));
      },
    );
  }

  Future<void> _onLoadPropertyAvailability(
    LoadPropertyAvailabilityEvent event,
    Emitter<PropertyDetailState> emit,
  ) async {
    emit(state.copyWith(isLoadingAvailability: true));

    final result = await _getPropertyAvailabilityUseCase(event.propertyId);

    result.fold(
      (error) => emit(state.copyWith(isLoadingAvailability: false)),
      (availabilityData) => emit(
        state.copyWith(
          isLoadingAvailability: false,
          availabilityData: availabilityData,
        ),
      ),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<PropertyDetailState> emit,
  ) async {
    // Optimistically update the UI
    if (state.propertyDetail != null) {
      final updatedProperty = state.propertyDetail!.copyWith(
        isFavorite: !event.isFavorite,
      );
      emit(state.copyWith(propertyDetail: updatedProperty));
    }

    // Call the appropriate API
    final result = event.isFavorite
        ? await _toggleFavoriteUseCase.removeFromFavorite(event.propertyId)
        : await _toggleFavoriteUseCase.addToFavorite(event.propertyId);

    result.fold(
      (error) {
        // Revert on error
        if (state.propertyDetail != null) {
          final revertedProperty = state.propertyDetail!.copyWith(
            isFavorite: event.isFavorite,
          );
          emit(
            state.copyWith(
              propertyDetail: revertedProperty,
              errorMessage: error,
            ),
          );
        }
      },
      (_) {
        // Success - the UI is already updated
      },
    );
  }

  Future<void> _onRateProperty(
    RatePropertyEvent event,
    Emitter<PropertyDetailState> emit,
  ) async {
    final result = await _ratePropertyUseCase(event.request);

    result.fold((error) => emit(state.copyWith(errorMessage: error)), (_) {
      // Rating submitted successfully
      // Optionally reload property details to get updated ratings
      if (state.propertyDetail != null) {
        add(LoadPropertyDetailEvent(state.propertyDetail!.id));
      }
    });
  }
}
