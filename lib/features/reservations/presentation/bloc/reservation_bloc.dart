import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/reservation_repository.dart';
import 'reservation_event.dart';
import 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final ReservationRepository _reservationRepository;

  ReservationBloc({
    required ReservationRepository reservationRepository,
  }) : _reservationRepository = reservationRepository,
       super(const ReservationInitial()) {
    on<LoadUpcomingReservationsEvent>(_onLoadUpcomingReservations);
    on<RefreshReservationsEvent>(_onRefreshReservations);
  }

  Future<void> _onLoadUpcomingReservations(
    LoadUpcomingReservationsEvent event,
    Emitter<ReservationState> emit,
  ) async {
    
    emit(const ReservationLoading());

    final result = await _reservationRepository.getUpcomingReservations();
    
    result.when(
      success: (reservationList) {
        emit(ReservationLoaded(
          reservations: reservationList.reservations,
          totalCount: reservationList.totalCount,
        ));
      },
      failure: (message) {
        emit(ReservationError(message: message));
      },
    );
  }

  Future<void> _onRefreshReservations(
    RefreshReservationsEvent event,
    Emitter<ReservationState> emit,
  ) async {
    
    // Don't show loading state for refresh, just update data
    final result = await _reservationRepository.getUpcomingReservations();
    
    result.when(
      success: (reservationList) {
        emit(ReservationLoaded(
          reservations: reservationList.reservations,
          totalCount: reservationList.totalCount,
        ));
      },
      failure: (message) {
        emit(ReservationError(message: message));
      },
    );
  }
}


