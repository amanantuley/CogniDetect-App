import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sizer/sizer.dart';
import 'save_pdf_io.dart' if (dart.library.html) 'save_pdf_web.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/disclaimer_widget.dart';
import './widgets/key_findings_widget.dart';
import './widgets/module_results_widget.dart';
import './widgets/overall_score_widget.dart';
import './widgets/recommendations_widget.dart';

/// Final Assessment Report Screen
/// Displays comprehensive cognitive assessment results with visual charts and actionable insights
class FinalAssessmentReport extends StatefulWidget {
  const FinalAssessmentReport({super.key});

  @override
  State<FinalAssessmentReport> createState() => _FinalAssessmentReportState();
}

class _FinalAssessmentReportState extends State<FinalAssessmentReport> {
  // Mock assessment data
  final Map<String, dynamic> _assessmentData = {
    "overallScore": 78,
    "percentile": 85,
    "assessmentDate": "January 24, 2026",
    "cognitiveGames": [
      {"label": "Memory", "value": 82},
      {"label": "Attention", "value": 75},
      {"label": "Processing", "value": 80},
      {"label": "Reasoning", "value": 76},
    ],
    "speechAnalysis": [
      {"label": "Fluency", "value": 85},
      {"label": "Clarity", "value": 78},
      {"label": "Coherence", "value": 72},
      {"label": "Vocabulary", "value": 88},
    ],
    "eyeMovement": [
      {"label": "Tracking", "value": 70},
      {"label": "Fixation", "value": 68},
      {"label": "Saccades", "value": 74},
      {"label": "Convergence", "value": 72},
    ],
    "keyFindings": [
      {
        "type": "positive",
        "title": "Strong Memory Performance",
        "description":
            "Your memory scores are above average for your age group, indicating healthy cognitive function in this area.",
      },
      {
        "type": "positive",
        "title": "Excellent Vocabulary",
        "description":
            "Speech analysis shows rich vocabulary usage and strong verbal communication skills.",
      },
      {
        "type": "neutral",
        "title": "Moderate Processing Speed",
        "description":
            "Processing speed is within normal range but could benefit from targeted cognitive exercises.",
      },
      {
        "type": "attention",
        "title": "Eye Movement Patterns",
        "description":
            "Some variations in eye tracking patterns detected. Consider regular eye health checkups.",
      },
    ],
    "recommendations": [
      {
        "title": "Continue Cognitive Exercises",
        "description":
            "Maintain regular brain training activities to preserve and enhance cognitive abilities.",
      },
      {
        "title": "Schedule Follow-up Assessment",
        "description":
            "Complete another assessment in 3 months to track progress and identify any changes.",
      },
      {
        "title": "Consult Healthcare Professional",
        "description":
            "Discuss results with your doctor, especially regarding eye movement patterns.",
      },
      {
        "title": "Maintain Healthy Lifestyle",
        "description":
            "Regular exercise, balanced diet, and adequate sleep support cognitive health.",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Assessment Report'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _shareReport,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Assessment date
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Assessment Date: ${_assessmentData['assessmentDate']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),

              // Overall score
              OverallScoreWidget(
                score: _assessmentData['overallScore'] as int,
                percentile: _assessmentData['percentile'] as int,
              ),
              SizedBox(height: 3.h),

              // Module results
              Text('Detailed Results', style: theme.textTheme.headlineSmall),
              SizedBox(height: 2.h),

              ModuleResultsWidget(
                moduleName: 'Cognitive Games',
                moduleIcon: Icons.games,
                metrics: (_assessmentData['cognitiveGames'] as List)
                    .cast<Map<String, dynamic>>(),
              ),
              SizedBox(height: 2.h),

              ModuleResultsWidget(
                moduleName: 'Speech Analysis',
                moduleIcon: Icons.mic,
                metrics: (_assessmentData['speechAnalysis'] as List)
                    .cast<Map<String, dynamic>>(),
              ),
              SizedBox(height: 2.h),

              ModuleResultsWidget(
                moduleName: 'Eye Movement',
                moduleIcon: Icons.visibility,
                metrics: (_assessmentData['eyeMovement'] as List)
                    .cast<Map<String, dynamic>>(),
              ),
              SizedBox(height: 3.h),

              // Key findings
              KeyFindingsWidget(
                findings: (_assessmentData['keyFindings'] as List)
                    .cast<Map<String, dynamic>>(),
              ),
              SizedBox(height: 3.h),

              // Recommendations
              RecommendationsWidget(
                recommendations: (_assessmentData['recommendations'] as List)
                    .cast<Map<String, dynamic>>(),
              ),
              SizedBox(height: 3.h),

              // Action buttons
              ActionButtonsWidget(
                onDownloadPdf: _downloadPdf,
                onScheduleFollowup: _scheduleFollowup,
              ),
              SizedBox(height: 3.h),

              // Disclaimer
              DisclaimerWidget(),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _shareReport() {
    // Share functionality handled by ActionButtonsWidget
  }

  Future<void> _downloadPdf() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'CogniDetect Assessment Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Assessment Date: ${_assessmentData['assessmentDate']}',
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Overall Score: ${_assessmentData['overallScore']}/100',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Percentile: Top ${_assessmentData['percentile']}% for your age group',
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Detailed Results',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Cognitive Games:'),
                ...(_assessmentData['cognitiveGames'] as List).map(
                  (metric) =>
                      pw.Text('  ${metric['label']}: ${metric['value']}%'),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Speech Analysis:'),
                ...(_assessmentData['speechAnalysis'] as List).map(
                  (metric) =>
                      pw.Text('  ${metric['label']}: ${metric['value']}%'),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Eye Movement:'),
                ...(_assessmentData['eyeMovement'] as List).map(
                  (metric) =>
                      pw.Text('  ${metric['label']}: ${metric['value']}%'),
                ),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      await savePdfBytes(bytes, filename: 'cognidetect_report.pdf');

      Fluttertoast.showToast(
        msg: "Report downloaded successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to download report",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _scheduleFollowup() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text('Schedule Follow-up'),
          content: Text('Set a reminder for your next assessment in 3 months?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "Follow-up reminder set for 3 months",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
