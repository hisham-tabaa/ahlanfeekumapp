import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Custom scroll behavior that enables mouse wheel scrolling on web
/// and improves touch scrolling across all platforms
class WebScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Use different physics based on platform
    if (kIsWeb) {
      // On web, use clamping physics for better mouse wheel experience
      return const ClampingScrollPhysics();
    }
    // On mobile, use bouncing physics for iOS-like behavior
    return const BouncingScrollPhysics();
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Show scrollbars on web and desktop platforms
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return Scrollbar(
        controller: details.controller,
        thumbVisibility: kIsWeb ? true : null,
        trackVisibility: kIsWeb ? true : null,
        child: child,
      );
    }
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Remove overscroll glow on web for cleaner appearance
    if (kIsWeb) {
      return child;
    }
    return super.buildOverscrollIndicator(context, child, details);
  }
}

/// Extension to easily wrap widgets with web-compatible scrolling
extension WebScrollExtension on Widget {
  /// Wraps the widget with WebScrollBehavior for better web scrolling
  Widget withWebScroll() {
    return ScrollConfiguration(
      behavior: WebScrollBehavior(),
      child: this,
    );
  }
}

/// Utility class for creating web-compatible scrollable widgets
class WebScrollUtils {
  /// Creates a ListView with web-compatible scrolling
  static Widget listView({
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    IndexedWidgetBuilder? separatorBuilder,
  }) {
    Widget listView;
    
    if (separatorBuilder != null) {
      listView = ListView.separated(
        key: key,
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder,
      );
    } else {
      listView = ListView.builder(
        key: key,
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    }

    return ScrollConfiguration(
      behavior: WebScrollBehavior(),
      child: listView,
    );
  }

  /// Creates a GridView with web-compatible scrolling
  static Widget gridView({
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    required SliverGridDelegate gridDelegate,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    final gridView = GridView.builder(
      key: key,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      gridDelegate: gridDelegate,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );

    return ScrollConfiguration(
      behavior: WebScrollBehavior(),
      child: gridView,
    );
  }

  /// Creates a SingleChildScrollView with web-compatible scrolling
  static Widget singleChildScrollView({
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    EdgeInsetsGeometry? padding,
    bool? primary,
    ScrollPhysics? physics,
    ScrollController? controller,
    required Widget child,
  }) {
    final scrollView = SingleChildScrollView(
      key: key,
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      primary: primary,
      physics: physics,
      controller: controller,
      child: child,
    );

    return ScrollConfiguration(
      behavior: WebScrollBehavior(),
      child: scrollView,
    );
  }

  /// Creates a CustomScrollView with web-compatible scrolling
  static Widget customScrollView({
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    Key? center,
    double anchor = 0.0,
    double? cacheExtent,
    required List<Widget> slivers,
  }) {
    final scrollView = CustomScrollView(
      key: key,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      center: center,
      anchor: anchor,
      cacheExtent: cacheExtent,
      slivers: slivers,
    );

    return ScrollConfiguration(
      behavior: WebScrollBehavior(),
      child: scrollView,
    );
  }
}
