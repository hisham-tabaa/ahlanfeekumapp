import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../error/exceptions.dart';

/// Utility class to convert technical exceptions to user-friendly error messages
class ErrorHandler {
  // Global navigator key for navigation from non-widget contexts
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Convert any exception to a user-friendly message
  static String getErrorMessage(dynamic error) {
    // Handle Dio network exceptions
    if (error is DioException) {
      return _handleDioError(error);
    }

    // Handle custom exceptions
    if (error is UnauthorizedException) {
      _handleUnauthorizedError();
      return error.message;
    }

    if (error is NetworkException) {
      return error.message;
    }

    if (error is ServerException) {
      return error.message;
    }

    if (error is AuthException) {
      return error.message;
    }

    if (error is ValidationException) {
      return error.message;
    }

    // Default generic error
    return 'Something went wrong. Please try again.';
  }

  /// Convert DioException to user-friendly message
  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection and try again.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network settings.';

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.unknown:
        // Check if it's a network issue
        if (error.message?.contains('SocketException') ?? false) {
          return 'No internet connection. Please check your network.';
        }
        if (error.message?.contains('Failed host lookup') ?? false) {
          return 'Unable to connect to server. Please check your internet connection.';
        }
        return 'Connection error. Please check your internet connection.';

      default:
        return 'Connection error. Please try again.';
    }
  }

  /// Handle HTTP response errors
  static String _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        // Trigger navigation to login screen
        _handleUnauthorizedError();
        return 'Session expired. Please login again.';
      case 403:
        return 'Access denied. You don\'t have permission.';
      case 404:
        return 'Resource not found.';
      case 408:
        return 'Request timeout. Please try again.';
      case 415:
        return 'Invalid data format.';
      case 422:
        return 'Invalid input. Please check your data.';
      case 429:
        return 'Too many requests. Please wait a moment.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
      case 503:
        return 'Service temporarily unavailable. Please try again later.';
      case 504:
        return 'Gateway timeout. Please try again.';
      default:
        if (statusCode != null && statusCode >= 500) {
          return 'Server error. Please try again later.';
        }
        return 'Something went wrong. Please try again.';
    }
  }

  /// Handle unauthorized error and navigate to login
  static void _handleUnauthorizedError() {
    // Use a short delay to ensure the error message is shown before navigation
    Future.delayed(const Duration(milliseconds: 500), () {
      final navigatorState = navigatorKey.currentState;
      if (navigatorState != null) {
        // Clear navigation stack and go to initial splash (which will redirect to login)
        navigatorState.pushNamedAndRemoveUntil('/', (route) => false);
      }
    });
  }

  /// Check if error is 401 Unauthorized
  static bool isUnauthorizedError(dynamic error) {
    if (error is UnauthorizedException) {
      return true;
    }
    if (error is DioException && error.response?.statusCode == 401) {
      return true;
    }
    return false;
  }

  /// Check if error is network-related
  static bool isNetworkError(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          (error.type == DioExceptionType.unknown &&
              (error.message?.contains('SocketException') ?? false)) ||
          (error.message?.contains('Failed host lookup') ?? false);
    }

    if (error is NetworkException) {
      return true;
    }

    return false;
  }

  /// Get a shorter error message for snackbars
  static String getShortErrorMessage(dynamic error) {
    if (error is DioException) {
      if (isNetworkError(error)) {
        return 'No internet connection';
      }

      if (error.type == DioExceptionType.badResponse) {
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) return 'Session expired';
        if (statusCode == 403) return 'Access denied';
        if (statusCode == 404) return 'Not found';
        if (statusCode != null && statusCode >= 500) return 'Server error';
      }

      return 'Connection error';
    }

    return 'Error occurred';
  }
}
