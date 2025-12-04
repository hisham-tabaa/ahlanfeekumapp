import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service to manage app performance optimizations
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  /// Initialize performance optimizations
  static Future<void> initialize() async {
    // Enable performance overlay in debug mode if needed
    if (kDebugMode) {
      debugPrintRebuildDirtyWidgets = false; // Reduce debug console noise
    }

    // Optimize image caching
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024; // 50MB

    // Preload commonly used assets
    await _preloadAssets();
  }

  /// Preload commonly used assets for faster access
  static Future<void> _preloadAssets() async {
    final assets = [
      'assets/images/Background1.png',
      'assets/images/BackgroundDark.png',
      'assets/icons/google.png',
      'assets/icons/start.png',
    ];

    for (final asset in assets) {
      try {
        await rootBundle.load(asset);
      } catch (e) {
        debugPrint('Failed to preload asset: $asset');
      }
    }
  }

  /// Clear image cache to free memory
  static void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// Optimize widget rebuilds
  static void optimizeRebuildPerformance(BuildContext context) {
    // Use const constructors wherever possible
    // This is handled at compile time
  }

  /// Memory management utilities
  static void performMemoryCleanup() {
    // Clear image cache if it's too large
    final cache = PaintingBinding.instance.imageCache;
    if (cache.currentSizeBytes > 30 * 1024 * 1024) {
      cache.clear();
    }
  }

  /// Network optimization configurations
  static Map<String, dynamic> getOptimizedNetworkConfig() {
    return {
      'connectTimeout': const Duration(seconds: 30),
      'receiveTimeout': const Duration(seconds: 30),
      'sendTimeout': const Duration(seconds: 30),
      'maxConnectionsPerHost': 5,
      'idleTimeout': const Duration(seconds: 15),
    };
  }
}
