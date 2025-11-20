import '../../../../core/network/api_result.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/reservation_entity.dart';
import '../../domain/repositories/reservation_repository.dart';
import '../datasources/reservation_remote_data_source.dart';
import '../models/reservation.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationRemoteDataSource _remoteDataSource;

  ReservationRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<ReservationListEntity>> getUpcomingReservations() async {
    try {

      final response = await _remoteDataSource.getUpcomingReservations();

      final entities = response.reservations
          .map((reservation) => _mapToEntity(reservation))
          .toList();

      final result = ReservationListEntity(
        reservations: entities,
        totalCount: response.totalCount,
      );

      return ApiResult.success(result);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.getErrorMessage(error));
    }
  }

  ReservationEntity _mapToEntity(Reservation reservation) {
    return ReservationEntity(
      id: reservation.id,
      fromDate: reservation.fromDate,
      toDate: reservation.toDate,
      checkInDate: reservation.checkInDate,
      checkOutDate: reservation.checkOutDate,
      numberOfGuest: reservation.numberOfGuest,
      price: reservation.price,
      discount: reservation.discount,
      reservationStatus: reservation.reservationStatus,
      reservationStatusAsString: reservation.reservationStatusAsString,
      notes: reservation.notes,
      userProfileId: reservation.userProfileId,
      userProfileName: reservation.userProfileName,
      userProfilePhoto: reservation.userProfilePhoto,
      ownerId: reservation.ownerId,
      ownerName: reservation.ownerName,
      ownerProfilePhoto: reservation.ownerProfilePhoto,
      propertyId: reservation.propertyId,
      propertyTitle: reservation.propertyTitle,
      propertyArea: reservation.propertyArea,
      propertyMainImage: reservation.propertyMainImage,
    );
  }
}
