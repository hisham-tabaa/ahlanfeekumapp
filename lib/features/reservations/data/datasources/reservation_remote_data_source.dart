import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/reservation.dart';

abstract class ReservationRemoteDataSource {
  Future<ReservationResponse> getUpcomingReservations();
}

class ReservationRemoteDataSourceImpl implements ReservationRemoteDataSource {
  final Dio _dio;

  ReservationRemoteDataSourceImpl(this._dio);

  @override
  Future<ReservationResponse> getUpcomingReservations() async {
    try {
      
      final response = await _dio.get(AppConstants.upcomingReservationsEndpoint);
      
      
      return ReservationResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}


