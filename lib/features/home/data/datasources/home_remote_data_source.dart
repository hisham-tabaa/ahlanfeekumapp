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
    const endpoint = AppConstants.homeEndpoint;
    try {
      final response = await _dio.get(endpoint);
      return HomeResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Check for 401 Unauthorized status code
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException(
          'Your session has expired. Please login again.',
        );
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
