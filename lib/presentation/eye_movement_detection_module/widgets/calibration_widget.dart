import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CalibrationWidget extends StatefulWidget {
  final VoidCallback onCalibrationComplete;

  const CalibrationWidget({super.key, required this.onCalibrationComplete});

  @override
  State<CalibrationWidget> createState() => _CalibrationWidgetState();
}

class _CalibrationWidgetState extends State<CalibrationWidget> {
  int _currentStep = 0;
  final List<String> _calibrationSteps = [
    'Look at the center dot',
    'Follow the moving dot',
    'Look at each corner',
    'Calibration complete',
  ];

  @override
  void initState() {
    super.initState();
    _startCalibration();
  }

  void _startCalibration() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _currentStep < _calibrationSteps.length - 1) {
        setState(() {
          _currentStep++;
        });
        _startCalibration();
      } else if (mounted) {
        widget.onCalibrationComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface.withValues(alpha: 0.95),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'visibility',
                color: theme.colorScheme.primary,
                size: 48,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Calibration',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _calibrationSteps[_currentStep],
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: 60.w,
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _calibrationSteps.length,
                backgroundColor: theme.colorScheme.outline.withValues(
                  alpha: 0.2,
                ),
                color: theme.colorScheme.primary,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Step ${_currentStep + 1} of ${_calibrationSteps.length}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
