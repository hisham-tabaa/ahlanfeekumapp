import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/home_response.dart';

abstract class HomeRemoteDataSource {
  Future<HomeResponse> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<HomeResponse> getHomeData() async {
    try {
      final response = await _dio.get(AppConstants.homeEndpoint);

      return HomeResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle 500 errors gracefully
      if (e.response?.statusCode == 500) {
        // Server error - throw exception
        throw const ServerException(
          'Backend server error - please try again later',
        );
      }

      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw const UnauthorizedException();
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ServerException('Connection timeout');
      } else if (e.type == DioExceptionType.unknown) {
        throw const ServerException('No internet connection');
      } else {
        throw ServerException(
          e.response?.data['message'] ?? 'Server error occurred',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
