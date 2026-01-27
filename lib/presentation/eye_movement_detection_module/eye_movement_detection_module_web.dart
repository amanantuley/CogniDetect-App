import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EyeMovementDetectionModule extends StatelessWidget {
  const EyeMovementDetectionModule({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Eye Movement Detection')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.videocam_off, size: 48, color: theme.colorScheme.primary),
              SizedBox(height: 2.h),
              Text(
                'Camera-based eye tracking is not supported on Web.',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Please use the mobile app (Android/iOS) to run this module.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
