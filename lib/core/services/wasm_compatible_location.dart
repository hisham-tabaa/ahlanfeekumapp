import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/wasm_compatibility.dart';

/// Wasm-compatible location service with fallbacks
class WasmCompatibleLocation with WasmCompatibilityMixin {
  
  /// Get current position with Wasm compatibility
  static Future<Position?> getCurrentPosition() async {
    if (kIsWeb && WasmCompatibility.isWasmSupported) {
      // For Wasm builds, return null or use alternative location method
      if (kDebugMode) {
        print('⚠️ Geolocation not available in Wasm build');
      }
      return null;
    }
    
    try {
      // Check permissions first
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
      
      // Get position for non-Wasm builds
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
      return null;
    }
  }
  
  /// Check if location services are available
  static Future<bool> isLocationServiceAvailable() async {
    if (kIsWeb && WasmCompatibility.isWasmSupported) {
      return false; // Not available in Wasm builds
    }
    
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }
  
  /// Get location permission status
  static Future<LocationPermission> getPermissionStatus() async {
    if (kIsWeb && WasmCompatibility.isWasmSupported) {
      return LocationPermission.denied; // Not available in Wasm builds
    }
    
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      return LocationPermission.denied;
    }
  }
  
  /// Request location permission
  static Future<LocationPermission> requestPermission() async {
    if (kIsWeb && WasmCompatibility.isWasmSupported) {
      return LocationPermission.denied; // Not available in Wasm builds
    }
    
    try {
      return await Geolocator.requestPermission();
    } catch (e) {
      return LocationPermission.denied;
    }
  }
}

