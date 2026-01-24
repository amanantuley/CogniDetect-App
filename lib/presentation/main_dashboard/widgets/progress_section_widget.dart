import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProgressSectionWidget extends StatelessWidget {
  final int completedModules;
  final int totalModules;
  final VoidCallback onQuickAssessment;

  const ProgressSectionWidget({
    super.key,
    required this.completedModules,
    required this.totalModules,
    required this.onQuickAssessment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = completedModules / totalModules;
    final progressPercentage = (progress * 100).toInt();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
                      'Overall Progress',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '$completedModules of $totalModules modules completed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$progressPercentage%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearPercentIndicator(
            lineHeight: 1.2.h,
            percent: progress,
            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
            progressColor: theme.colorScheme.primary,
            barRadius: const Radius.circular(8),
            animation: true,
            animationDuration: 1000,
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: completedModules == totalModules
                  ? Color(0xFF2A9D8F).withValues(alpha: 0.1)
                  : theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: completedModules == totalModules
                    ? Color(0xFF2A9D8F).withValues(alpha: 0.3)
                    : theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: completedModules == totalModules
                      ? 'celebration'
                      : 'lightbulb_outline',
                  color: completedModules == totalModules
                      ? Color(0xFF2A9D8F)
                      : theme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    completedModules == totalModules
                        ? 'Congratulations! All modules completed. View your comprehensive report.'
                        : 'Keep going! Complete remaining modules for full assessment.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: completedModules == totalModules
                          ? Color(0xFF2A9D8F)
                          : theme.colorScheme.primary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onQuickAssessment,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'play_arrow',
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    completedModules == totalModules
                        ? 'View Full Report'
                        : 'Continue Assessment',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
