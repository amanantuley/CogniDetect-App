import 'dart:io';
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
  return Image.file(
    File(path),
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
    color: color,
    semanticLabel: semanticLabel,
  );
}
