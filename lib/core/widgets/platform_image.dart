import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/universal_io.dart' if (dart.library.html) '../utils/universal_io_stub.dart';
import 'dart:io' as io show File;

/// A widget that displays images in a platform-compatible way
/// On web, it uses Image.network with XFile
/// On mobile/desktop, it uses Image.file with File
class PlatformImage extends StatelessWidget {
  final File? file;
  final XFile? xFile;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;

  const PlatformImage({
    super.key,
    this.file,
    this.xFile,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && xFile != null) {
      return Image.network(
        xFile!.path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return placeholder ??
              Container(
                width: width,
                height: height,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 50),
              );
        },
      );
    } else if (!kIsWeb && file != null) {
      // Only use Image.file on non-web platforms
      // Convert our File to dart:io File
      return Image.file(
        io.File(file!.path),
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      return placeholder ??
          Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.image, size: 50),
          );
    }
  }
}
