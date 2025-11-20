import 'package:dartz/dartz.dart';

import '../entities/reservation.dart';
import '../repositories/profile_repository.dart';

class GetUserReservationsUseCase {
  final ProfileRepository _repository;

  GetUserReservationsUseCase(this._repository);

  Future<Either<String, List<Reservation>>> call(String userId) async {
    return await _repository.getUserReservations(userId);
  }
}
