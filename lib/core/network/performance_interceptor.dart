import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor to optimize network performance and caching
class PerformanceInterceptor extends Interceptor {
  final Map<String, CacheEntry> _cache = {};
  final Duration cacheDuration;
  final int maxCacheSize;

  PerformanceInterceptor({
    this.cacheDuration = const Duration(minutes: 5),
    this.maxCacheSize = 50,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add performance headers
    options.headers['Connection'] = 'keep-alive';
    options.headers['Keep-Alive'] = 'timeout=30, max=1000';

    // Enable gzip compression
    options.headers['Accept-Encoding'] = 'gzip, deflate';

    // Check cache for GET requests
    if (options.method == 'GET') {
      final cacheKey = _getCacheKey(options);
      final cachedEntry = _cache[cacheKey];

      if (cachedEntry != null && !cachedEntry.isExpired) {
        if (kDebugMode) {
          print('📦 Cache hit for: ${options.uri}');
        }

        handler.resolve(
          Response(
            data: cachedEntry.data,
            statusCode: 200,
            requestOptions: options,
            headers: Headers.fromMap({
              'from-cache': ['true'],
            }),
          ),
        );
        return;
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Cache successful GET responses
    if (response.requestOptions.method == 'GET' && response.statusCode == 200) {
      final cacheKey = _getCacheKey(response.requestOptions);

      // Manage cache size
      if (_cache.length >= maxCacheSize) {
        _removeOldestEntry();
      }

      _cache[cacheKey] = CacheEntry(
        data: response.data,
        timestamp: DateTime.now(),
        duration: cacheDuration,
      );

      if (kDebugMode) {
        print('💾 Cached response for: ${response.requestOptions.uri}');
      }
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log performance metrics in debug mode
    if (kDebugMode) {
      final duration = DateTime.now().difference(
        err.requestOptions.extra['start_time'] ?? DateTime.now(),
      );
      print(
        '❌ Request failed after ${duration.inMilliseconds}ms: ${err.requestOptions.uri}',
      );
    }

    super.onError(err, handler);
  }

  String _getCacheKey(RequestOptions options) {
    final queryParams = options.queryParameters.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    // Include HTTP method to prevent cache collisions between different methods
    return '${options.method}:${options.uri.path}?$queryParams';
  }

  void _removeOldestEntry() {
    if (_cache.isEmpty) return;

    String? oldestKey;
    DateTime? oldestTime;

    _cache.forEach((key, entry) {
      if (oldestTime == null || entry.timestamp.isBefore(oldestTime!)) {
        oldestTime = entry.timestamp;
        oldestKey = key;
      }
    });

    if (oldestKey != null) {
      _cache.remove(oldestKey);
    }
  }

  void clearCache() {
    _cache.clear();
  }

  void invalidateCacheForPath(String path) {
    _cache.removeWhere((key, _) => key.contains(path));
    if (kDebugMode) {
      print('🗑️ Cache invalidated for path: $path');
    }
  }
}

class CacheEntry {
  final dynamic data;
  final DateTime timestamp;
  final Duration duration;

  CacheEntry({
    required this.data,
    required this.timestamp,
    required this.duration,
  });

  bool get isExpired => DateTime.now().difference(timestamp) > duration;
}
