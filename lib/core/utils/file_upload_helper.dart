import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Helper class to handle file uploads for both web and mobile platforms
class FileUploadHelper {
  /// Converts an XFile to a MultipartFile that works on both web and mobile
  ///
  /// On web, it reads the file bytes and creates a MultipartFile from bytes
  /// On mobile, it uses the file path directly
  static Future<MultipartFile> createMultipartFile(
    XFile file, {
    String? filename,
  }) async {
    final name = filename ?? file.name;

    if (kIsWeb) {
      // Web: Read bytes from the file
      final bytes = await file.readAsBytes();
      return MultipartFile.fromBytes(bytes, filename: name);
    } else {
      // Mobile/Desktop: Use file path
      return await MultipartFile.fromFile(file.path, filename: name);
    }
  }

  /// Creates a MultipartFile from a file path (mobile/desktop only)
  /// For web compatibility, use createMultipartFile with XFile instead
  static Future<MultipartFile?> createMultipartFileFromPath(
    String? filePath, {
    String? filename,
  }) async {
    if (filePath == null || filePath.isEmpty) {
      return null;
    }

    if (kIsWeb) {
      // On web, file paths don't work - return null
      // The calling code should use XFile instead
      return null;
    } else {
      // Mobile/Desktop: Use file path
      return await MultipartFile.fromFile(
        filePath,
        filename: filename ?? filePath.split('/').last,
      );
    }
  }
}
