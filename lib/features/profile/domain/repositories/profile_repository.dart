import 'package:dartz/dartz.dart';

import '../entities/profile.dart';
import '../entities/reservation.dart';
import '../../data/models/update_profile_request.dart';
import '../../data/models/change_password_request.dart';

abstract class ProfileRepository {
  Future<Either<String, Profile>> getProfileDetails();
  Future<Either<String, Unit>> updateProfile(UpdateProfileRequest request);
  Future<Either<String, Unit>> changePassword(ChangePasswordRequest request);
  Future<Either<String, List<Reservation>>> getMyReservations();
  Future<Either<String, List<Reservation>>> getUserReservations(String userId);
}
