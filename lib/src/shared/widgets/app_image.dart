import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';

/// A reusable image widget that handles network images with proper loading and error states
class AppImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;
  final IconData? fallbackIcon;
  final double? fallbackIconSize;
  final Color? fallbackIconColor;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
    this.fallbackIcon = Icons.image,
    this.fallbackIconSize,
    this.fallbackIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultPlaceholder = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          fallbackIcon,
          size: fallbackIconSize ?? (width != null ? width! * 0.3 : 24),
          color: fallbackIconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );

    final defaultErrorWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          Icons.broken_image,
          size: fallbackIconSize ?? (width != null ? width! * 0.3 : 24),
          color: theme.colorScheme.error.withValues(alpha: 0.5),
        ),
      ),
    );

    // If no image URL, show fallback
    if (imageUrl == null || imageUrl!.isEmpty) {
      if (kDebugMode) {
        print('AppImage: No image URL provided');
      }
      return defaultPlaceholder;
    }

    // Check if it's a valid URL
    if (!_isValidUrl(imageUrl!)) {
      if (kDebugMode) {
        print('AppImage: Invalid URL: $imageUrl');
      }
      return defaultErrorWidget;
    }

    if (kDebugMode) {
      print('AppImage: Attempting to load: $imageUrl');
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) {
          if (kDebugMode) {
            print('AppImage: Loading placeholder for $url');
          }
          return placeholder ?? defaultPlaceholder;
        },
        errorWidget: (context, url, error) {
          // Only log errors in debug mode and filter out common 404rrors
          if (kDebugMode) {
            // Don't log 404 known problematic URLs to reduce noise
            if (!url.contains('photo-1621996346565') &&
                !url.contains('photo-1551024506') &&
                !url.contains('photo-1571877227200') &&
                !url.contains('photo-1510812431401') &&
                !url.contains('photo-1621263764928')) {
              print('AppImage: Error loading $url - $error');
            }
          }
          return errorWidget ?? defaultErrorWidget;
        },
        memCacheWidth: width?.toInt(),
        memCacheHeight: height?.toInt(),
        // Add retry logic for failed images
        httpHeaders: const {
          'User-Agent': 'Flutter POS App/1.0',
        },
      ),
    );
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }
}

/// A circular image widget for avatars and profile pictures
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;
  final IconData? fallbackIcon;
  final Color? fallbackIconColor;

  const AppAvatar({
    super.key,
    required this.imageUrl,
    this.size = 40,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
    this.fallbackIcon = Icons.person,
    this.fallbackIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
      placeholder: placeholder,
      errorWidget: errorWidget,
      backgroundColor: backgroundColor,
      fallbackIcon: fallbackIcon,
      fallbackIconSize: size * 0.4,
      fallbackIconColor: fallbackIconColor,
    );
  }
}

/// A square image widget for product images and thumbnails
class AppThumbnail extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;
  final IconData? fallbackIcon;
  final Color? fallbackIconColor;

  const AppThumbnail({
    super.key,
    required this.imageUrl,
    this.size = 60,
    this.borderRadius = 8,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
    this.fallbackIcon = Icons.image,
    this.fallbackIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(borderRadius),
      placeholder: placeholder,
      errorWidget: errorWidget,
      backgroundColor: backgroundColor,
      fallbackIcon: fallbackIcon,
      fallbackIconSize: size * 0.3,
      fallbackIconColor: fallbackIconColor,
    );
  }
} 