import '../../../../core/network/api_result.dart';
import '../entities/settings.dart';
import '../../data/models/create_ticket_request.dart';

abstract class HelpRepository {
  Future<ApiResult<Settings>> getSettings();
  Future<ApiResult<bool>> createTicket(CreateTicketRequest request);
}