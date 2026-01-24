import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Key findings section highlighting significant patterns
class KeyFindingsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> findings;

  const KeyFindingsWidget({super.key, required this.findings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text('Key Findings', style: theme.textTheme.titleLarge),
            ],
          ),
          SizedBox(height: 2.h),
          ...findings.map(
            (finding) => Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0.5.h),
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: _getFindingColor(
                        theme,
                        finding['type'] as String,
                      ).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: _getFindingIcon(finding['type'] as String),
                      color: _getFindingColor(theme, finding['type'] as String),
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          finding['title'] as String,
                          style: theme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          finding['description'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
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

  Color _getFindingColor(ThemeData theme, String type) {
    switch (type) {
      case 'positive':
        return theme.colorScheme.tertiary;
      case 'neutral':
        return const Color(0xFFE9C46A);
      case 'attention':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.primary;
    }
  }

  String _getFindingIcon(String type) {
    switch (type) {
      case 'positive':
        return 'check_circle';
      case 'neutral':
        return 'info';
      case 'attention':
        return 'warning';
      default:
        return 'circle';
    }
  }
}
