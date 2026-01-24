import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Primary action buttons for report sharing and follow-up
class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onDownloadPdf;
  final VoidCallback onScheduleFollowup;

  const ActionButtonsWidget({
    super.key,
    required this.onDownloadPdf,
    required this.onScheduleFollowup,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _shareReport(context),
            icon: CustomIconWidget(
              iconName: 'share',
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
            label: Text('Share Report'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onDownloadPdf,
            icon: CustomIconWidget(
              iconName: 'download',
              color: theme.colorScheme.primary,
              size: 20,
            ),
            label: Text('Download PDF'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onScheduleFollowup,
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: theme.colorScheme.primary,
              size: 20,
            ),
            label: Text('Schedule Follow-up'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
      ],
    );
  }

  void _shareReport(BuildContext context) {
    Share.share(
      'Check out my CogniDetect Assessment Report. Download the app to track your cognitive health.',
      subject: 'CogniDetect Assessment Report',
    );
  }
}
