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
    print('🛰️ [Help] Request → POST $endpoint');
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
      print('✅ [Help] Response ← ${response.statusCode} $endpoint');
      print('✅ [Help] Payload: ${response.data}');
      return SettingsResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (error) {
      print('🚨 [Help] Error ↩ $endpoint :: $error');
      if (error is DioException && error.response != null) {
        print('🚨 [Help] Status: ${error.response?.statusCode}');
        print('🚨 [Help] Body: ${error.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<CreateTicketResponse> createTicket(CreateTicketRequest request) async {
    const endpoint = AppConstants.createTicketEndpoint;
    print('🛰️ [Help] Request → POST $endpoint');
    print('🛰️ [Help] Payload: ${request.toJson()}');
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
      print('✅ [Help] Response ← ${response.statusCode} $endpoint');
      print('✅ [Help] Payload: ${response.data}');
      return CreateTicketResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (error) {
      print('🚨 [Help] Error ↩ $endpoint :: $error');
      if (error is DioException && error.response != null) {
        print('🚨 [Help] Status: ${error.response?.statusCode}');
        print('🚨 [Help] Body: ${error.response?.data}');
      }
      rethrow;
    }
  }
}
