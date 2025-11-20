import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/settings_response.dart';
import '../models/create_ticket_request.dart';
import '../models/create_ticket_response.dart';

abstract class HelpRemoteDataSource {
  Future<SettingsResponse> getSettings();
  Future<CreateTicketResponse> createTicket(CreateTicketRequest request);
}

class HelpRemoteDataSourceImpl implements HelpRemoteDataSource {
  final Dio _dio;

  HelpRemoteDataSourceImpl(this._dio);

  @override
  Future<SettingsResponse> getSettings() async {
    const endpoint = AppConstants.settingsGetEndpoint;
    try {
      final response = await _dio.post(
        endpoint,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );
      return SettingsResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      if (error is DioException && error.response != null) {
      }
      rethrow;
    }
  }

  @override
  Future<CreateTicketResponse> createTicket(CreateTicketRequest request) async {
    const endpoint = AppConstants.createTicketEndpoint;
    try {
      final response = await _dio.post(
        endpoint,
        data: request.toJson(),
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        ),
      );
      return CreateTicketResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (error) {
      if (error is DioException && error.response != null) {
      }
      rethrow;
    }
  }
}
