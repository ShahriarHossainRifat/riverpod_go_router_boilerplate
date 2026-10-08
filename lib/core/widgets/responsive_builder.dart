import 'package:flutter/material.dart';

/// Responsive layout breakpoints used throughout the app.
abstract class Breakpoints {
  /// Private constructor to prevent instantiation.
  const new _();

  /// Maximum width for mobile layouts.
  static const double mobile = 600;

  /// Maximum width for tablet layouts.
  static const double tablet = 1024;

  /// Minimum width for desktop layouts.
  static const double desktop = 1440;
}

/// A widget that builds different layouts based on screen width.
class ResponsiveBuilder extends StatelessWidget {
  /// Creates a [ResponsiveBuilder].
  const new({required this.mobile, super.key, this.tablet, this.desktop});

  /// Builder for mobile layouts.
  final Widget Function(BuildContext context) mobile;

  /// Optional builder for tablet layouts.
  final Widget Function(BuildContext context)? tablet;

  /// Optional builder for desktop layouts.
  final Widget Function(BuildContext context)? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.desktop) {
          return desktop?.call(context) ??
              tablet?.call(context) ??
              mobile(context);
        }
        if (constraints.maxWidth >= Breakpoints.tablet) {
          return tablet?.call(context) ?? mobile(context);
        }
        return mobile(context);
      },
    );
  }
}

/// Resolves a value based on the current screen width.
class ResponsiveValue<T> {
  /// Creates a [ResponsiveValue].
  new({
    required BuildContext context,
    required this._mobile,
    this._tablet,
    this._desktop,
  }) : _width = MediaQuery.of(context).size.width;

  final T _mobile;
  final T? _tablet;
  final T? _desktop;
  final double _width;

  /// The resolved responsive value.
  T get value {
    if (_width >= Breakpoints.desktop) {
      return _desktop ?? _tablet ?? _mobile;
    }
    if (_width >= Breakpoints.tablet) {
      return _tablet ?? _mobile;
    }
    return _mobile;
  }
}

/// Extensions for responsive helpers on [BuildContext].
extension ResponsiveContextExtension on BuildContext {
  /// Returns a responsive value based on screen width.
  T responsiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    return ResponsiveValue<T>(
      context: this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    ).value;
  }

  /// Whether the current screen size is mobile.
  bool get isMobile => MediaQuery.of(this).size.width < Breakpoints.mobile;

  /// Whether the current screen size is tablet.
  bool get isTablet {
    final width = MediaQuery.of(this).size.width;
    return width >= Breakpoints.mobile && width < Breakpoints.tablet;
  }

  /// Whether the current screen size is desktop.
  bool get isDesktop => MediaQuery.of(this).size.width >= Breakpoints.tablet;
}

/// A responsive grid that adapts column count to screen size.
class ResponsiveGrid extends StatelessWidget {
  /// Creates a [ResponsiveGrid].
  const new({
    required this.children,
    super.key,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
    this.childAspectRatio = 1,
  });

  /// Grid children widgets.
  final List<Widget> children;

  /// Number of columns on mobile screens.
  final int mobileColumns;

  /// Number of columns on tablet screens.
  final int tabletColumns;

  /// Number of columns on desktop screens.
  final int desktopColumns;

  /// Horizontal spacing between grid items.
  final double spacing;

  /// Vertical spacing between grid items.
  final double runSpacing;

  /// Aspect ratio of grid children.
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        if (constraints.maxWidth >= Breakpoints.desktop) {
          columns = desktopColumns;
        } else if (constraints.maxWidth >= Breakpoints.tablet) {
          columns = tabletColumns;
        } else {
          columns = mobileColumns;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

/// A widget that conditionally shows content based on screen size.
class ResponsiveVisibility extends StatelessWidget {
  /// Creates a [ResponsiveVisibility].
  const new({
    required this.child,
    super.key,
    this.visibleOnMobile = true,
    this.visibleOnTablet = true,
    this.visibleOnDesktop = true,
    this.replacement,
  });

  /// Widget to display when visible.
  final Widget child;

  /// Whether the widget is visible on mobile screens.
  final bool visibleOnMobile;

  /// Whether the widget is visible on tablet screens.
  final bool visibleOnTablet;

  /// Whether the widget is visible on desktop screens.
  final bool visibleOnDesktop;

  /// Widget shown when not visible.
  final Widget? replacement;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool visible;
        if (constraints.maxWidth >= Breakpoints.desktop) {
          visible = visibleOnDesktop;
        } else if (constraints.maxWidth >= Breakpoints.tablet) {
          visible = visibleOnTablet;
        } else {
          visible = visibleOnMobile;
        }

        return visible ? child : replacement ?? const SizedBox.shrink();
      },
    );
  }
}
