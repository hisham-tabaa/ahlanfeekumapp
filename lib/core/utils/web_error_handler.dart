import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Web-specific error handler to manage JavaScript interop issues
class WebErrorHandler {
  /// Handles web-specific errors gracefully
  static void handleWebError(dynamic error, StackTrace? stackTrace) {
    if (kIsWeb) {
      // Log web-specific errors without crashing the app
      debugPrint('🌐 Web Error: $error');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
      
      // Check for common web errors
      if (error.toString().contains('LegacyJavaScriptObject')) {
        debugPrint('⚠️ JavaScript interop error detected - this is usually harmless');
      } else if (error.toString().contains('DiagnosticsNode')) {
        debugPrint('⚠️ Flutter web diagnostics error - continuing normally');
      }
    } else {
      // On non-web platforms, handle normally
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'WebErrorHandler',
      ));
    }
  }

  /// Wraps a widget with web error boundary
  static Widget withErrorBoundary({
    required Widget child,
    Widget? fallback,
  }) {
    if (!kIsWeb) return child;

    return ErrorBoundary(
      child: child,
      fallback: fallback,
    );
  }
}

/// Error boundary widget for web-specific error handling
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget? fallback;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    
    // Set up error handling for web
    if (kIsWeb) {
      FlutterError.onError = (FlutterErrorDetails details) {
        WebErrorHandler.handleWebError(details.exception, details.stack);
        
        // Don't set error state for JavaScript interop errors
        if (!details.exception.toString().contains('LegacyJavaScriptObject') &&
            !details.exception.toString().contains('DiagnosticsNode')) {
          setState(() {
            _hasError = true;
          });
        }
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.fallback ?? _buildDefaultErrorWidget();
    }

    return widget.child;
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            kIsWeb 
              ? 'This appears to be a web-specific issue. Please refresh the page.'
              : 'Please try again.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
          setState(() {
            _hasError = false;
          });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Mixin for widgets that need web error handling
mixin WebErrorHandlingMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    
    if (kIsWeb) {
      // Handle uncaught errors in web context
      FlutterError.onError = (FlutterErrorDetails details) {
        WebErrorHandler.handleWebError(details.exception, details.stack);
      };
    }
  }

  /// Safe method to execute code that might throw web-specific errors
  void safeExecute(VoidCallback callback, {VoidCallback? onError}) {
    try {
      callback();
    } catch (error, stackTrace) {
      WebErrorHandler.handleWebError(error, stackTrace);
      onError?.call();
    }
  }
}
