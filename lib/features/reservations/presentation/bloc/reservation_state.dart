import 'package:equatable/equatable.dart';
import '../../domain/entities/reservation_entity.dart';

abstract class ReservationState extends Equatable {
  const ReservationState();

  @override
  List<Object?> get props => [];
}

class ReservationInitial extends ReservationState {
  const ReservationInitial();
}

class ReservationLoading extends ReservationState {
  const ReservationLoading();
}

class ReservationLoaded extends ReservationState {
  final List<ReservationEntity> reservations;
  final int totalCount;

  const ReservationLoaded({
    required this.reservations,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [reservations, totalCount];
}

class ReservationError extends ReservationState {
  final String message;

  const ReservationError({required this.message});

  @override
  List<Object?> get props => [message];
}


