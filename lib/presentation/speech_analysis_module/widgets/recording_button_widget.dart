import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Recording button with pulse animation and waveform visualization
class RecordingButtonWidget extends StatelessWidget {
  final bool isRecording;
  final AnimationController pulseController;
  final AnimationController waveformController;
  final VoidCallback onPressed;

  const RecordingButtonWidget({
    super.key,
    required this.isRecording,
    required this.pulseController,
    required this.waveformController,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Recording button with pulse animation
        GestureDetector(
          onTap: onPressed,
          child: AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              return Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRecording
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                  boxShadow: isRecording
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.error.withValues(
                              alpha: 0.3 + (pulseController.value * 0.3),
                            ),
                            blurRadius: 20 + (pulseController.value * 20),
                            spreadRadius: 5 + (pulseController.value * 10),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withValues(
                              alpha: 0.15,
                            ),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: isRecording ? 'stop' : 'mic',
                    color: theme.colorScheme.onPrimary,
                    size: 12.w,
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 2.h),

        // Waveform visualization during recording
        if (isRecording)
          AnimatedBuilder(
            animation: waveformController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final height = 2.h +
                      (waveformController.value * 4.h * ((index % 2) + 1));
                  return Container(
                    width: 1.w,
                    height: height,
                    margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              );
            },
          ),

        SizedBox(height: 2.h),

        // Action text
        Text(
          isRecording ? 'Tap to stop recording' : 'Tap to start recording',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
