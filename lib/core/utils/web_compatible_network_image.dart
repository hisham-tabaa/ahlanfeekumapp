import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../di/injection.dart';
import '../services/image_loader_service.dart';

/// A web-compatible network image widget that handles CORS and encoding issues
/// on Flutter web while maintaining CachedNetworkImage functionality on mobile
class WebCompatibleNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Map<String, String>? httpHeaders;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final Color? color;
  final BlendMode? colorBlendMode;
  final FilterQuality filterQuality;

  const WebCompatibleNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.httpHeaders,
    this.fadeInDuration,
    this.fadeOutDuration,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.color,
    this.colorBlendMode,
    this.filterQuality = FilterQuality.low,
  });

  @override
  Widget build(BuildContext context) {
    // On web, use Image.network with web-specific configurations
    if (kIsWeb) {
      return _buildWebImage(context);
    }

    // On mobile, use CachedNetworkImage for better performance
    return _buildMobileImage(context);
  }

  Widget _buildWebImage(BuildContext context) {
    // Use ImageLoaderService to fetch images via Dio (bypasses CORS issues)
    final imageLoader = getIt<ImageLoaderService>();

    return FutureBuilder<Uint8List>(
      future: imageLoader.fetchImageBytes(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show placeholder while loading
          return placeholder?.call(context, imageUrl) ??
              Container(
                width: width,
                height: height,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
        }

        if (snapshot.hasError) {
          // Show error widget
          if (kDebugMode) {
            print('❌ Web image error: ${snapshot.error}');
            print('🔗 Failed URL: $imageUrl');
          }
          return errorWidget?.call(context, imageUrl, snapshot.error) ??
              _defaultErrorWidget(context);
        }

        if (snapshot.hasData && snapshot.data != null) {
          // Display the loaded image
          return Image.memory(
            snapshot.data!,
            width: width,
            height: height,
            fit: fit,
            alignment: alignment,
            repeat: repeat,
            matchTextDirection: matchTextDirection,
            color: color,
            colorBlendMode: colorBlendMode,
            filterQuality: filterQuality,
            errorBuilder: errorWidget != null
                ? (context, error, stackTrace) {
                    if (kDebugMode) {
                      print('❌ Web image decode error: $error');
                      print('🔗 Failed URL: $imageUrl');
                    }
                    return errorWidget!(context, imageUrl, error);
                  }
                : (context, error, stackTrace) {
                    if (kDebugMode) {
                      print('❌ Web image decode error: $error');
                      print('🔗 Failed URL: $imageUrl');
                    }
                    return _defaultErrorWidget(context);
                  },
          );
        }

        // Fallback for unexpected state
        return _defaultErrorWidget(context);
      },
    );
  }

  Widget _buildMobileImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      color: color,
      colorBlendMode: colorBlendMode,
      filterQuality: filterQuality,
      httpHeaders: httpHeaders,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 500),
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 1000),
      placeholder: placeholder,
      errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget!(context, url, error)
          : (context, url, error) {
              return _defaultErrorWidget(context);
            },
    );
  }


  Widget _defaultErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 32),
      ),
    );
  }
}

/// Extension to easily convert CachedNetworkImage to WebCompatibleNetworkImage
extension CachedNetworkImageExtension on CachedNetworkImage {
  WebCompatibleNetworkImage toWebCompatible() {
    return WebCompatibleNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder != null
          ? (context, url) => placeholder!(context, url)
          : null,
      errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget!(context, url, error)
          : null,
      httpHeaders: httpHeaders,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: fadeOutDuration,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      color: color,
      colorBlendMode: colorBlendMode,
      filterQuality: filterQuality,
    );
  }
}
