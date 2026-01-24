import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/module_card_widget.dart';
import './widgets/progress_section_widget.dart';

class MainDashboardInitialPage extends StatefulWidget {
  const MainDashboardInitialPage({super.key});

  @override
  State<MainDashboardInitialPage> createState() =>
      _MainDashboardInitialPageState();
}

class _MainDashboardInitialPageState extends State<MainDashboardInitialPage> {
  final String userName = "Sarah";
  int completedModules = 1;
  final int totalModules = 4;
  bool isRefreshing = false;

  final List<Map<String, dynamic>> modules = [
    {
      "id": 1,
      "title": "Cognitive Games",
      "description":
          "Test memory, attention, and problem-solving skills through interactive games",
      "icon": "games",
      "route": "/cognitive-games-module",
      "estimatedTime": "15-20 min",
      "isCompleted": true,
      "color": Color(0xFF2E7D9A),
    },
    {
      "id": 2,
      "title": "Speech Analysis",
      "description":
          "Analyze speech patterns and verbal fluency for cognitive indicators",
      "icon": "mic",
      "route": "/speech-analysis-module",
      "estimatedTime": "10-15 min",
      "isCompleted": false,
      "color": Color(0xFF4A90A4),
    },
    {
      "id": 3,
      "title": "Eye Movement Detection",
      "description":
          "Track eye movements and gaze patterns for neurological assessment",
      "icon": "visibility",
      "route": "/eye-movement-detection-module",
      "estimatedTime": "8-12 min",
      "isCompleted": false,
      "color": Color(0xFF2A9D8F),
    },
    {
      "id": 4,
      "title": "Final Report",
      "description":
          "View comprehensive assessment results with detailed insights",
      "icon": "assessment",
      "route": "/final-assessment-report",
      "estimatedTime": "5 min",
      "isCompleted": false,
      "color": Color(0xFFF4A261),
    },
  ];

  Future<void> _handleRefresh() async {
    setState(() => isRefreshing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isRefreshing = false;
      completedModules =
          (modules.where((m) => m["isCompleted"] == true).length);
    });
  }

  void _handleModuleTap(Map<String, dynamic> module) {
    if (module["route"] != null) {
      Navigator.of(context, rootNavigator: true).pushNamed(module["route"]);
    }
  }

  void _handleQuickAssessment() {
    final firstIncomplete = modules.firstWhere(
      (m) => m["isCompleted"] == false,
      orElse: () => modules[0],
    );
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(firstIncomplete["route"]);
  }

  void _showModuleOptions(Map<String, dynamic> module) {
    if (!module["isCompleted"]) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'visibility',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('View Results', style: theme.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed('/final-assessment-report');
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'refresh',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Retake Assessment',
                  style: theme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _handleModuleTap(module);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Share Report', style: theme.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Report sharing feature coming soon'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
                                'Hello $userName',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                currentDate,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomIconWidget(
                            iconName: 'notifications_outlined',
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info_outline',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Complete all modules for comprehensive assessment',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assessment Modules',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Select a module to begin your cognitive assessment',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 2.h,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final module = modules[index];
                  return ModuleCardWidget(
                    module: module,
                    onTap: () => _handleModuleTap(module),
                    onLongPress: () => _showModuleOptions(module),
                  );
                }, childCount: modules.length),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              sliver: SliverToBoxAdapter(
                child: ProgressSectionWidget(
                  completedModules: completedModules,
                  totalModules: totalModules,
                  onQuickAssessment: _handleQuickAssessment,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 2.h)),
          ],
        ),
      ),
    );
  }
}
