import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:shimmer/shimmer.dart';

/// A cached network image widget with built-in loading and error states.
///
/// Displays a shimmer placeholder while loading and a fallback
/// widget when the image fails to load.
class AppCachedImage extends StatelessWidget {
  /// Creates an [AppCachedImage].
  const new({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = .cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  /// URL of the image to load.
  final String imageUrl;

  /// Optional width of the image.
  final double? width;

  /// Optional height of the image.
  final double? height;

  /// How the image should be inscribed into the space.
  final BoxFit fit;

  /// Optional border radius applied to the image.
  final BorderRadius? borderRadius;

  /// Optional custom placeholder widget.
  final Widget? placeholder;

  /// Optional custom error widget.
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ?? _ShimmerPlaceholder(width: width, height: height),
      errorWidget: (context, url, error) =>
          errorWidget ?? _ErrorPlaceholder(width: width, height: height),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}

class _ShimmerPlaceholder extends StatelessWidget {
  const new({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(width: width, height: height, color: Colors.white),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const new({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.broken_image_outlined,
        color: colorScheme.onSurfaceVariant,
        size: (width ?? height ?? 48) * 0.4,
      ),
    );
  }
}

/// A circular cached avatar image widget.
///
/// Falls back to a placeholder avatar when the image URL is null,
/// empty, or fails to load.
class AppCachedAvatar extends StatelessWidget {
  /// Creates an [AppCachedAvatar].
  const new({
    required this.imageUrl,
    super.key,
    this.radius = 24,
    this.placeholder,
  });

  /// URL of the avatar image.
  ///
  /// If null or empty, a fallback avatar is shown.
  final String? imageUrl;

  /// Radius of the avatar.
  final double radius;

  /// Optional widget displayed when no image is available.
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: context.theme.colorScheme.primaryContainer,
        child:
            placeholder ??
            Icon(
              Icons.person,
              size: radius,
              color: context.theme.colorScheme.primary,
            ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      imageBuilder: (context, imageProvider) =>
          CircleAvatar(radius: radius, backgroundImage: imageProvider),
      placeholder: (context, url) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return CircleAvatar(
          radius: radius,
          child: Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: .circle,
              ),
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => CircleAvatar(
        radius: radius,
        backgroundColor: context.theme.colorScheme.primaryContainer,
        child:
            placeholder ??
            Icon(
              Icons.person,
              size: radius,
              color: context.theme.colorScheme.primary,
            ),
      ),
    );
  }
}
