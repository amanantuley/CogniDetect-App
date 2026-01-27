import 'package:flutter/material.dart';

Widget buildFileImage(
  String path, {
  double? height,
  double? width,
  BoxFit? fit,
  Color? color,
  String? semanticLabel,
  String? fallbackAsset,
  Widget? errorWidget,
}) {
  // File images aren't supported on web; use fallback
  if (errorWidget != null) return errorWidget;
  return Image.asset(
    fallbackAsset ?? 'assets/images/no-image.jpg',
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
    color: color,
    semanticLabel: semanticLabel,
  );
}
