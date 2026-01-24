import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Playback controls for recorded audio
class PlaybackControlsWidget extends StatelessWidget {
  final bool isPlaying;
  final Duration recordingDuration;
  final Duration playbackPosition;
  final VoidCallback onPlayPause;
  final VoidCallback onReRecord;
  final String Function(Duration) formatDuration;

  const PlaybackControlsWidget({
    super.key,
    required this.isPlaying,
    required this.recordingDuration,
    required this.playbackPosition,
    required this.onPlayPause,
    required this.onReRecord,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = recordingDuration.inMilliseconds > 0
        ? playbackPosition.inMilliseconds / recordingDuration.inMilliseconds
        : 0.0;

    return Column(
      children: [
        SizedBox(height: 4.h),

        // Playback controls
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              // Waveform scrubber
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    // Progress indicator
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    // Waveform visualization
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(30, (index) {
                          final height = 2.h + (index % 3) * 1.5.h;
                          final isPassed = (index / 30) <= progress;
                          return Container(
                            width: 0.5.w,
                            height: height,
                            decoration: BoxDecoration(
                              color: isPassed
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Time indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(playbackPosition),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    formatDuration(recordingDuration),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Re-record button
                  OutlinedButton.icon(
                    onPressed: onReRecord,
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text('Re-record'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 1.5.h,
                      ),
                    ),
                  ),

                  SizedBox(width: 4.w),

                  // Play/Pause button
                  ElevatedButton.icon(
                    onPressed: onPlayPause,
                    icon: CustomIconWidget(
                      iconName: isPlaying ? 'pause' : 'play_arrow',
                      color: theme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    label: Text(isPlaying ? 'Pause' : 'Play'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 1.5.h,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
