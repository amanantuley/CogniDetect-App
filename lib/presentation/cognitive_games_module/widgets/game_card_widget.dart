import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Game Card Widget
/// Renders different game types with appropriate interfaces
class GameCardWidget extends StatelessWidget {
  final Map<String, dynamic> game;
  final Function(String action, dynamic data) onGameAction;

  const GameCardWidget({
    super.key,
    required this.game,
    required this.onGameAction,
  });

  @override
  Widget build(BuildContext context) {
    final gameType = game["type"] as String;

    switch (gameType) {
      case "memory":
        return _buildMemoryGame(context);
      case "pattern":
        return _buildPatternGame(context);
      case "reaction":
        return _buildReactionGame(context);
      case "attention":
        return _buildAttentionGame(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMemoryGame(BuildContext context) {
    final theme = Theme.of(context);
    final cards = game["cards"] as List;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            children: [
              Text(
                game["description"] as String,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Difficulty: ${game["difficulty"]}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 2.w,
            mainAxisSpacing: 2.w,
            childAspectRatio: 1,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index] as Map<String, dynamic>;
            final isRevealed = card["revealed"] == true;
            final isMatched = card["matched"] == true;

            return GestureDetector(
              onTap: () => onGameAction("card_tap", index),
              child: Container(
                decoration: BoxDecoration(
                  color: isMatched
                      ? theme.colorScheme.primary.withValues(alpha: 0.2)
                      : isRevealed
                          ? theme.colorScheme.surface
                          : theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isMatched
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isRevealed || isMatched
                      ? Text(
                          card["value"] as String,
                          style: TextStyle(fontSize: 32),
                        )
                      : CustomIconWidget(
                          iconName: 'question_mark',
                          color: theme.colorScheme.onPrimary,
                          size: 32,
                        ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPatternGame(BuildContext context) {
    final theme = Theme.of(context);
    final patterns = game["patterns"] as List;
    final currentPatternIndex = game["currentPattern"] as int;
    final currentPattern =
        patterns[currentPatternIndex] as Map<String, dynamic>;
    final sequence = currentPattern["sequence"] as List;
    final options = currentPattern["options"] as List;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            children: [
              Text(
                game["description"] as String,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Pattern ${currentPatternIndex + 1} of ${patterns.length}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'Sequence:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Wrap(
                spacing: 3.w,
                runSpacing: 2.h,
                alignment: WrapAlignment.center,
                children: [
                  ...(sequence).map(
                    (item) => Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.primary),
                      ),
                      child: Text(
                        item as String,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.tertiary,
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'question_mark',
                      color: theme.colorScheme.tertiary,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'Select the next item:',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 3.w,
          runSpacing: 2.h,
          alignment: WrapAlignment.center,
          children: (options).map((option) {
            return GestureDetector(
              onTap: () => onGameAction("answer_selected", option),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: Text(
                  option as String,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReactionGame(BuildContext context) {
    final theme = Theme.of(context);
    final currentTrial = game["currentTrial"] as int;
    final totalTrials = game["trials"] as int;
    final reactionTimes = game["reactionTimes"] as List;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            children: [
              Text(
                game["description"] as String,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Trial ${currentTrial + 1} of $totalTrials',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: () {
            final reactionTime = DateTime.now().millisecondsSinceEpoch % 1000;
            onGameAction("target_tapped", reactionTime);
          },
          child: Container(
            width: 60.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'touch_app',
                color: theme.colorScheme.onPrimary,
                size: 60,
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        reactionTimes.isNotEmpty
            ? Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  children: [
                    Text(
                      'Last Reaction Time',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '${reactionTimes.last}ms',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildAttentionGame(BuildContext context) {
    final theme = Theme.of(context);
    final targets = game["targets"] as List;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            children: [
              Text(
                game["description"] as String,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Difficulty: ${game["difficulty"]}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: 3.w,
            runSpacing: 2.h,
            alignment: WrapAlignment.center,
            children: (targets).map((target) {
              final targetMap = target as Map<String, dynamic>;
              final shape = targetMap["shape"] as String;
              final color = targetMap["color"] as String;

              return Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: _getColorFromString(color),
                  shape:
                      shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius:
                      shape != "circle" ? BorderRadius.circular(8) : null,
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'How many blue circles did you count?',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: GestureDetector(
                onTap: () => onGameAction("answer_submitted", index),
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case "blue":
        return Colors.blue;
      case "red":
        return Colors.red;
      case "green":
        return Colors.green;
      case "yellow":
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
