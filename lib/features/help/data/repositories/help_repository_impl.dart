import '../../../../core/network/api_result.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/help_repository.dart';
import '../datasources/help_remote_data_source.dart';
import '../models/create_ticket_request.dart';

class HelpRepositoryImpl implements HelpRepository {
  final HelpRemoteDataSource _remoteDataSource;

  HelpRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<Settings>> getSettings() async {
    try {
      final response = await _remoteDataSource.getSettings();
      final settings = Settings(
        id: response.id,
        termsTitle: response.termsTitle,
        termsAnnotation: response.termsAnnotation,
        termsDescription: response.termsDescription,
        termsIcon: response.termsIcon,
        whoAreWeTitle: response.whoAreWeTitle,
        whoAreWeAnnotation: response.whoAreWeAnnotation,
        whoAreWeDescription: response.whoAreWeDescription,
        whoAreWeIcon: response.whoAreWeIcon,
        isActive: response.isActive,
      );
      return ApiResult.success(settings);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<ApiResult<bool>> createTicket(CreateTicketRequest request) async {
    try {
      await _remoteDataSource.createTicket(request);
      return const ApiResult.success(true);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.getErrorMessage(e));
    }
  }
}
