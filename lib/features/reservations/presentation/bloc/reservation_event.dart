import 'package:equatable/equatable.dart';

abstract class ReservationEvent extends Equatable {
  const ReservationEvent();

  @override
  List<Object?> get props => [];
}

class LoadUpcomingReservationsEvent extends ReservationEvent {
  const LoadUpcomingReservationsEvent();
}

class RefreshReservationsEvent extends ReservationEvent {
  const RefreshReservationsEvent();
}


