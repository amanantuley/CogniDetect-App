import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Game Controls Widget
/// Provides navigation and submission controls for games
class GameControlsWidget extends StatelessWidget {
  final int currentGame;
  final int totalGames;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  const GameControlsWidget({
    super.key,
    required this.currentGame,
    required this.totalGames,
    required this.onPrevious,
    required this.onNext,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFirstGame = currentGame == 0;
    final isLastGame = currentGame == totalGames - 1;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            isFirstGame
                ? const SizedBox.shrink()
                : Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onPrevious,
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      label: const Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                      ),
                    ),
                  ),
            isFirstGame ? const SizedBox.shrink() : SizedBox(width: 3.w),
            Expanded(
              flex: isFirstGame ? 1 : 1,
              child: ElevatedButton.icon(
                onPressed: isLastGame ? onSubmit : onNext,
                icon: CustomIconWidget(
                  iconName: isLastGame ? 'check_circle' : 'arrow_forward',
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text(isLastGame ? 'Complete' : 'Next'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
