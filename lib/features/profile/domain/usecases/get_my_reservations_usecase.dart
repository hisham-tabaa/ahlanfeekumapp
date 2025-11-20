import 'package:dartz/dartz.dart';

import '../entities/reservation.dart';
import '../repositories/profile_repository.dart';

class GetMyReservationsUseCase {
  final ProfileRepository _repository;

  GetMyReservationsUseCase(this._repository);

  Future<Either<String, List<Reservation>>> call() async {
    return await _repository.getMyReservations();
  }
}
