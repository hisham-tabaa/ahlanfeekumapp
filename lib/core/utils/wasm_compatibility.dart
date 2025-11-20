import 'package:flutter/foundation.dart';

/// Utility class to handle WebAssembly compatibility
class WasmCompatibility {
  /// Check if the current build supports WebAssembly
  static bool get isWasmSupported {
    // This is a placeholder - actual Wasm detection would be more complex
    return kIsWeb && !_usesIncompatibleFeatures();
  }
  
  /// Check if the app uses features incompatible with Wasm
  static bool _usesIncompatibleFeatures() {
    // Return true if using dart:html or dart:js dependent features
    // This can be configured based on your app's needs
    return false;
  }
  
  /// Provides a fallback message for Wasm-incompatible features
  static String get wasmIncompatibilityMessage => 
    'This feature is not available in WebAssembly builds. '
    'Please use the standard web version for full functionality.';
}

/// Mixin to add Wasm compatibility checks to widgets/services
mixin WasmCompatibilityMixin {
  /// Check if a feature is available in the current build
  bool isFeatureAvailable(String featureName) {
    switch (featureName) {
      case 'secure_storage':
        return !kIsWeb || !WasmCompatibility.isWasmSupported;
      case 'geolocation':
        return !kIsWeb || !WasmCompatibility.isWasmSupported;
      default:
        return true;
    }
  }
  
  /// Get fallback message for unavailable features
  String getUnavailableFeatureMessage(String featureName) {
    return 'The $featureName feature is not available in this build. '
           '${WasmCompatibility.wasmIncompatibilityMessage}';
  }
}

