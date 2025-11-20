import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/wasm_compatibility.dart';

/// Wasm-compatible storage service that falls back to SharedPreferences
/// when secure storage is not available
class WasmCompatibleStorage with WasmCompatibilityMixin {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'ahlanfeekum_secure_db',
      publicKey: 'ahlanfeekum_public_key',
    ),
  );
  
  /// Store a value securely, with Wasm fallback
  static Future<void> setSecureValue(String key, String value) async {
    if (kIsWeb && WasmCompatibility.isWasmSupported) {
      // For Wasm builds, use SharedPreferences with a prefix
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('secure_$key', value);
      
      if (kDebugMode) {
        print('⚠️ Using SharedPreferences fallback for secure storage in Wasm build');
      }
    } else {
      // Use secure storage for non-Wasm builds
      await _secureStorage.write(key: key, value: value);
    }
  }
  
  /// Retrieve a secure value, with Wasm fallback
  static Future<String?> getSecureValue(String key) async {
    if (kIsWeb && WasmCompatibility.isWasmSupported) {
      // For Wasm builds, use SharedPreferences with a prefix
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('secure_$key');
    } else {
      // Use secure storage for non-Wasm builds
      return await _secureStorage.read(key: key);
    }
  }
  
  /// Delete a secure value, with Wasm fallback
  static Future<void> deleteSecureValue(String key) async {
    if (kIsWeb && WasmCompatibility.isWasmSupported) {
      // For Wasm builds, use SharedPreferences with a prefix
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('secure_$key');
    } else {
      // Use secure storage for non-Wasm builds
      await _secureStorage.delete(key: key);
    }
  }
  
  /// Clear all secure values, with Wasm fallback
  static Future<void> clearAllSecureValues() async {
    if (kIsWeb && WasmCompatibility.isWasmSupported) {
      // For Wasm builds, clear all prefixed keys
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith('secure_'));
      for (final key in keys) {
        await prefs.remove(key);
      }
    } else {
      // Use secure storage for non-Wasm builds
      await _secureStorage.deleteAll();
    }
  }
}

