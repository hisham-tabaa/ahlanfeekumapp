import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive breakpoints for different screen sizes
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;
}

/// Responsive helper utilities
class ResponsiveUtils {
  /// Check if current device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobile;
  }

  /// Check if current device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= ResponsiveBreakpoints.mobile &&
        width < ResponsiveBreakpoints.desktop;
  }

  /// Check if current device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= ResponsiveBreakpoints.desktop;
  }

  /// Check if running on web platform
  static bool get isWeb => kIsWeb;

  /// Check if should use desktop navigation (side nav)
  static bool shouldUseDesktopNav(BuildContext context) {
    return isWeb && isDesktop(context);
  }

  /// Get responsive value based on screen size
  /// Automatically applies ScreenUtil scaling for mobile viewports
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    // Determine which value to use based on screen width
    T baseValue;
    if (width >= ResponsiveBreakpoints.desktop) {
      baseValue = desktop ?? tablet ?? mobile;
    } else if (width >= ResponsiveBreakpoints.tablet) {
      baseValue = tablet ?? mobile;
    } else {
      baseValue = mobile;
    }
    
    // Special handling for double values (font sizes, dimensions)
    if (T == double && baseValue is double) {
      // For web platform, NEVER apply ScreenUtil scaling
      if (kIsWeb) {
        return baseValue as T;
      }
      
      // For mobile apps, try to apply ScreenUtil scaling if initialized
      try {
        // For mobile app viewports (< 600px), apply ScreenUtil scaling
        if (width < ResponsiveBreakpoints.mobile) {
          // Font sizes are typically 10-60
          if (baseValue >= 10 && baseValue <= 60) {
            return baseValue.sp as T;
          }
          // Small dimensions (padding, margins, icons) typically 1-100
          else if (baseValue >= 1 && baseValue <= 100) {
            return baseValue.w as T;
          }
          // Larger dimensions (widths, heights) > 100
          else {
            return baseValue.w as T;
          }
        }
        
        // For mobile app on tablet size, apply scaling
        if (baseValue >= 10 && baseValue <= 60) {
          return baseValue.sp as T;
        }
        return baseValue.w as T;
      } catch (e) {
        // ScreenUtil not initialized, return base value
        return baseValue as T;
      }
    }
    
    // For non-double types, return the value as-is
    return baseValue;
  }
  
  /// Get responsive font size - optimized for web
  static double fontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (kIsWeb) {
      final width = MediaQuery.of(context).size.width;
      if (width >= ResponsiveBreakpoints.desktop) {
        return desktop ?? tablet ?? mobile;
      } else if (width >= ResponsiveBreakpoints.tablet) {
        return tablet ?? mobile;
      }
      return mobile;
    }
    // For mobile apps, use ScreenUtil
    return responsive(context, mobile: mobile, tablet: tablet, desktop: desktop);
  }
  
  /// Get responsive spacing (padding, margin, gaps) - optimized for web
  static double spacing(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (kIsWeb) {
      final width = MediaQuery.of(context).size.width;
      if (width >= ResponsiveBreakpoints.desktop) {
        return desktop ?? tablet ?? mobile;
      } else if (width >= ResponsiveBreakpoints.tablet) {
        return tablet ?? mobile;
      }
      return mobile;
    }
    // For mobile apps, use ScreenUtil
    return responsive(context, mobile: mobile, tablet: tablet, desktop: desktop);
  }
  
  /// Get responsive size (width, height) - optimized for web
  static double size(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (kIsWeb) {
      final width = MediaQuery.of(context).size.width;
      if (width >= ResponsiveBreakpoints.desktop) {
        return desktop ?? tablet ?? mobile;
      } else if (width >= ResponsiveBreakpoints.tablet) {
        return tablet ?? mobile;
      }
      return mobile;
    }
    // For mobile apps, use ScreenUtil
    return responsive(context, mobile: mobile, tablet: tablet, desktop: desktop);
  }
  
  /// Get responsive border radius - optimized for web
  static double radius(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (kIsWeb) {
      final width = MediaQuery.of(context).size.width;
      if (width >= ResponsiveBreakpoints.desktop) {
        return desktop ?? tablet ?? mobile;
      } else if (width >= ResponsiveBreakpoints.tablet) {
        return tablet ?? mobile;
      }
      return mobile;
    }
    // For mobile apps, use ScreenUtil
    return responsive(context, mobile: mobile, tablet: tablet, desktop: desktop);
  }

  /// Get max content width based on screen size
  static double getMaxContentWidth(BuildContext context, {bool allowFullWidth = true}) {
    if (allowFullWidth) {
      return double.infinity; // Allow full width on all devices
    }
    
    if (isDesktop(context)) {
      return 1200; // Desktop: wider content area
    } else if (isTablet(context)) {
      return 800; // Tablet: medium width
    } else {
      return double.infinity; // Mobile: full width
    }
  }

  /// Get horizontal padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return 40;
    } else if (isTablet(context)) {
      return 32;
    } else {
      return 20;
    }
  }

  /// Get grid column count based on screen size
  static int getGridColumnCount(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    return responsive(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get grid crossAxisCount for property cards
  static int getPropertyGridColumns(BuildContext context) {
    if (isDesktop(context)) {
      return 3;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 1;
    }
  }

  /// Get responsive width dimension
  /// Use this when you need explicit width scaling (e.g., for containers, images)
  static double responsiveWidth(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    // Determine the base size based on screen width
    double baseSize;
    if (width >= ResponsiveBreakpoints.desktop) {
      baseSize = desktop ?? tablet ?? mobile;
    } else if (width >= ResponsiveBreakpoints.tablet) {
      baseSize = tablet ?? mobile;
    } else {
      baseSize = mobile;
    }
    
    // For mobile viewports, apply width scaling
    if (width < ResponsiveBreakpoints.mobile) {
      try {
        return baseSize.w;
      } catch (e) {
        return baseSize;
      }
    }
    
    // For tablet and desktop on web, use fixed sizes
    if (kIsWeb) {
      return baseSize;
    }
    
    // For mobile app on tablet size, apply scaling
    try {
      return baseSize.w;
    } catch (e) {
      return baseSize;
    }
  }

  /// Get responsive height dimension
  /// Use this when you need explicit height scaling (e.g., for containers, images)
  static double responsiveHeight(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    // Determine the base size based on screen width
    double baseSize;
    if (width >= ResponsiveBreakpoints.desktop) {
      baseSize = desktop ?? tablet ?? mobile;
    } else if (width >= ResponsiveBreakpoints.tablet) {
      baseSize = tablet ?? mobile;
    } else {
      baseSize = mobile;
    }
    
    // For mobile viewports, apply height scaling
    if (width < ResponsiveBreakpoints.mobile) {
      try {
        return baseSize.h;
      } catch (e) {
        return baseSize;
      }
    }
    
    // For tablet and desktop on web, use fixed sizes
    if (kIsWeb) {
      return baseSize;
    }
    
    // For mobile app on tablet size, apply scaling
    try {
      return baseSize.h;
    } catch (e) {
      return baseSize;
    }
  }

  /// Get responsive border radius
  /// Use this for BorderRadius values
  static double responsiveRadius(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    // Determine the base size based on screen width
    double baseSize;
    if (width >= ResponsiveBreakpoints.desktop) {
      baseSize = desktop ?? tablet ?? mobile;
    } else if (width >= ResponsiveBreakpoints.tablet) {
      baseSize = tablet ?? mobile;
    } else {
      baseSize = mobile;
    }
    
    // For mobile viewports, apply radius scaling
    if (width < ResponsiveBreakpoints.mobile) {
      try {
        return baseSize.r;
      } catch (e) {
        return baseSize;
      }
    }
    
    // For tablet and desktop on web, use fixed sizes
    if (kIsWeb) {
      return baseSize;
    }
    
    // For mobile app on tablet size, apply scaling
    try {
      return baseSize.r;
    } catch (e) {
      return baseSize;
    }
  }
}

/// Responsive layout wrapper for web
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final bool centerContent;
  final bool allowFullWidth;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth,
    this.centerContent = true,
    this.allowFullWidth = true, // Default to full width
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = allowFullWidth && maxWidth == null
        ? double.infinity
        : maxWidth ?? ResponsiveUtils.getMaxContentWidth(context, allowFullWidth: allowFullWidth);

    final content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    return Container(
      color: backgroundColor,
      child: centerContent && ResponsiveUtils.isWeb && !allowFullWidth
          ? Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
                child: content,
              ),
            )
          : content,
    );
  }
}

/// Responsive grid for form fields
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 2,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.responsive(
      context,
      mobile: mobileColumns,
      tablet: tabletColumns,
      desktop: desktopColumns,
    );

    if (columns == 1) {
      return Column(
        children: children
            .map(
              (child) => Padding(
                padding: EdgeInsets.only(bottom: runSpacing),
                child: child,
              ),
            )
            .toList(),
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children.map((child) {
        return SizedBox(
          width:
              (MediaQuery.of(context).size.width -
                  (spacing * (columns - 1)) -
                  (ResponsiveUtils.getHorizontalPadding(context) * 2)) /
              columns,
          child: child,
        );
      }).toList(),
    );
  }
}
