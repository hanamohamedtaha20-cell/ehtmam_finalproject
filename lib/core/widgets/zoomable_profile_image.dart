import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'full_screen_image_page.dart';

/// Drop-in profile image that opens full-screen on tap.
/// Pass [shape] = BoxShape.circle for circular avatars.
class ZoomableProfileImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;
  final Color fallbackColor;
  final Widget? fallbackChild;
  final String heroTag;

  const ZoomableProfileImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.shape = BoxShape.rectangle,
    this.fallbackColor = const Color(0xFF169CE8),
    this.fallbackChild,
    this.heroTag = '',
  });

  String get _tag => heroTag.isNotEmpty ? heroTag : 'profile_$imageUrl';

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.isNotEmpty;

    final child = hasImage
        ? Hero(
            tag: _tag,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _fallback,
            ),
          )
        : _fallback;

    final decoration = shape == BoxShape.circle
        ? BoxDecoration(color: fallbackColor, shape: BoxShape.circle)
        : BoxDecoration(
            color: fallbackColor,
            borderRadius: BorderRadius.circular(borderRadius.r),
          );

    return GestureDetector(
      onTap: hasImage
          ? () => Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.black,
                  pageBuilder: (_, _, _) => FullScreenImagePage(
                    imageUrl: imageUrl,
                    heroTag: _tag,
                  ),
                  transitionsBuilder: (_, animation, _, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              )
          : null,
      child: Container(
        width: width,
        height: height,
        decoration: decoration,
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }

  Widget get _fallback =>
      fallbackChild ??
      Icon(Icons.person, color: Colors.white, size: (width * 0.45).r);
}
