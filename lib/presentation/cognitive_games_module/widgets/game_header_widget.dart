import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Game Header Widget
/// Displays game title, progress, score, timer, and controls
class GameHeaderWidget extends StatelessWidget {
  final String gameTitle;
  final int currentGame;
  final int totalGames;
  final int score;
  final int timeRemaining;
  final bool isPaused;
  final VoidCallback onPauseToggle;
  final VoidCallback onHelpPressed;

  const GameHeaderWidget({
    super.key,
    required this.gameTitle,
    required this.currentGame,
    required this.totalGames,
    required this.score,
    required this.timeRemaining,
    required this.isPaused,
    required this.onPauseToggle,
    required this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = currentGame / totalGames;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gameTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Game $currentGame of $totalGames',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onPauseToggle,
                    icon: CustomIconWidget(
                      iconName: isPaused ? 'play_arrow' : 'pause',
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    tooltip: isPaused ? 'Resume' : 'Pause',
                  ),
                  IconButton(
                    onPressed: onHelpPressed,
                    icon: CustomIconWidget(
                      iconName: 'help_outline',
                      color: theme.colorScheme.tertiary,
                      size: 28,
                    ),
                    tooltip: 'Help',
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'stars',
                          color: theme.colorScheme.tertiary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Score: $score',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: timeRemaining < 10
                      ? theme.colorScheme.error.withValues(alpha: 0.1)
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: timeRemaining < 10
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'timer',
                      color: timeRemaining < 10
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _formatTime(timeRemaining),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: timeRemaining < 10
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
