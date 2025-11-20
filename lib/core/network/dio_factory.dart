import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../di/injection.dart';

class DioFactory {
  static Dio? _dio;
  static final StreamController<bool> _authErrorController = StreamController<bool>.broadcast();
  
  // Stream to notify when authentication error occurs
  static Stream<bool> get authErrorStream => _authErrorController.stream;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (_dio == null) {
      _dio = Dio();
      _dio!.options.baseUrl = AppConstants.baseUrl;
      _dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      // Web-specific configurations for CORS
      if (kIsWeb) {
        _dio!.options.headers['Accept'] = '*/*';
        // Try to use credentials for CORS
        _dio!.options.extra['withCredentials'] = false;
      }

      if (kDebugMode) {
        _dio!.interceptors.add(
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            requestHeader: true,
            responseHeader: true,
          ),
        );
      }

      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Only set Content-Type if not already set (preserve multipart/form-data for uploads)
            if (!options.headers.containsKey('Content-Type')) {
              options.headers['Content-Type'] = 'application/json';
            }
            options.headers['accept'] = 'text/plain';

            // Add Authorization header
            try {
              final sharedPreferences = getIt<SharedPreferences>();
              final token = sharedPreferences.getString(
                AppConstants.accessTokenKey,
              );

              // Debug logging (can be removed in production)
              if (kDebugMode) {
                print('🔍 Request: ${options.path}');
                print('🔍 Full URL: ${options.uri}');
                print('🔍 Method: ${options.method}');
                print('🔍 Data: ${options.data}');
                if (token != null) {
                  print(
                    '🔍 Token: ${_isPlaceholderToken(token) ? 'PLACEHOLDER' : 'JWT'}',
                  );
                  print('🔍 Token length: ${token.length}');
                  print(
                    '🔍 Token preview: ${token.length > 10 ? '${token.substring(0, 10)}...' : token}',
                  );
                }
              }

              if (token != null &&
                  token.isNotEmpty &&
                  !_isPlaceholderToken(token)) {
                options.headers['Authorization'] = 'Bearer $token';
                if (kDebugMode) {
                  print('🔑 Auth header added for: ${options.path}');
                }
              } else {
                // For endpoints that require authentication, we should handle this
                if (_requiresAuthentication(options.path)) {
                }
              }

              // Print final headers after all modifications
              if (kDebugMode) {
                print('🔍 Final Headers: ${options.headers}');
              }
            } catch (e) {
            }

            handler.next(options);
          },
          onError: (error, handler) {
            if (error.response != null) {

              // Handle authentication and authorization errors
              if (error.response?.statusCode == 403) {
                _handleAuthenticationError();
              } else if (error.response?.statusCode == 401) {
                _handleAuthenticationError();
              }
            }
            handler.next(error);
          },
        ),
      );
    }
    return _dio!;
  }

  // Helper method to check if token is a placeholder
  static bool _isPlaceholderToken(String token) {
    const placeholderTokens = [
      'otp_verified_token',
      'google_token',
      'password_reset_token',
    ];
    return placeholderTokens.contains(token);
  }

  // Helper method to check if endpoint requires authentication
  static bool _requiresAuthentication(String path) {
    // List of endpoints that require authentication
    const authenticatedEndpoints = [
      'lookups/governates',
      'lookups/property-types',
      'lookups/property-features',
      'properties/search-property',
      'properties/create-step-one',
      'properties/create-step-two',
      'properties/add-availability',
      'properties/upload-one-media',
      'properties/upload-medias',
      'properties/set-price',
      'reservations/my-reservations',
      'reservations/user-reservations',
      'user-profiles/user-profile-details',
      'user-profiles/update-my-profile',
      'user-profiles/password-change',
    ];

    return authenticatedEndpoints.any((endpoint) => path.contains(endpoint));
  }

  // Handle authentication errors by clearing invalid tokens
  static void _handleAuthenticationError() {
    try {
      final sharedPreferences = getIt<SharedPreferences>();
      final token = sharedPreferences.getString(AppConstants.accessTokenKey);

      if (token != null) {
        // Check if it's an invalid token error (issuer not valid)
        sharedPreferences.remove(AppConstants.accessTokenKey);
        sharedPreferences.remove(AppConstants.refreshTokenKey);
        sharedPreferences.remove(AppConstants.userDataKey);
        sharedPreferences.remove(AppConstants.isLoggedInKey);
        
        // Notify listeners about authentication error
        _authErrorController.add(true);
      }
    } catch (e) {
    }
  }
}
