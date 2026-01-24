import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sizer/sizer.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController? cameraController;
  final bool isCameraInitialized;

  const CameraPreviewWidget({
    super.key,
    required this.cameraController,
    required this.isCameraInitialized,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isCameraInitialized || cameraController == null) {
      return Container(
        color: theme.colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: theme.colorScheme.primary),
              SizedBox(height: 2.h),
              Text(
                'Initializing camera...',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      child: OverflowBox(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 100.w,
            height: 100.w / cameraController!.value.aspectRatio,
            child: CameraPreview(cameraController!),
          ),
        ),
      ),
    );
  }
}
