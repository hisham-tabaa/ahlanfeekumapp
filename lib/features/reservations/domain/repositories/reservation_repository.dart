import '../../../../core/network/api_result.dart';
import '../entities/reservation_entity.dart';

abstract class ReservationRepository {
  Future<ApiResult<ReservationListEntity>> getUpcomingReservations();
}


