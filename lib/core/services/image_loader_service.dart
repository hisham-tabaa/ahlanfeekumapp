import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Service to load images, especially for web where CORS can be an issue
class ImageLoaderService {
  final Dio _dio;

  ImageLoaderService(this._dio);

  /// Fetch image bytes from URL using Dio (bypasses direct browser CORS issues)
  Future<Uint8List> fetchImageBytes(String imageUrl) async {
    try {
      if (kDebugMode) {
        print('📥 Fetching image: $imageUrl');
      }

      // Use a separate Dio instance for images to avoid baseUrl conflicts
      final imageDio = Dio();
      imageDio.options.connectTimeout = _dio.options.connectTimeout;
      imageDio.options.receiveTimeout = _dio.options.receiveTimeout;

      // Apply web-specific configurations
      if (kIsWeb) {
        imageDio.options.extra['withCredentials'] = false;
      }

      final response = await imageDio.get(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status != null && status < 400,
          headers: {
            'Accept': 'image/png,image/jpeg,image/jpg,image/webp,image/*',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (kDebugMode) {
          print(
            '✅ Image loaded successfully: $imageUrl (${response.data.runtimeType})',
          );
          print('📊 Data length: ${response.data.length}');
        }

        // Handle different response data types
        if (response.data is Uint8List) {
          return response.data as Uint8List;
        } else if (response.data is List<int>) {
          return Uint8List.fromList(response.data as List<int>);
        } else {
          throw Exception('Unexpected data type: ${response.data.runtimeType}');
        }
      } else {
        throw Exception(
          'Failed to load image: ${response.statusCode} - $imageUrl',
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DioException loading image: ${e.message}');
        print('🔗 URL: $imageUrl');
        print('📍 Error type: ${e.type}');
        if (e.response != null) {
          print('📍 Response status: ${e.response?.statusCode}');
        }
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading image: $e');
        print('🔗 URL: $imageUrl');
      }
      rethrow;
    }
  }
}
