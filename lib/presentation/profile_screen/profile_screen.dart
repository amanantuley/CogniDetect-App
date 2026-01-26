import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../services/app_state_manager.dart';
import '../../services/analytics_service.dart';
import '../../widgets/advanced_ui_components.dart';
import '../../widgets/advanced_charts.dart';
import '../../widgets/advanced_animations.dart';

/// Advanced Profile Screen with Statistics
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _stateManager = AppStateManager();
  final _analytics = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _analytics.trackScreenView('profile_screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final analyticsSummary = _stateManager.getAnalyticsSummary();
    final cognitiveScores = _stateManager.cognitiveScores;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(4.w),
        children: [
          // Profile Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D9A), Color(0xFF4A90A4)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D9A).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Text(
                    _stateManager.userName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D9A),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _stateManager.userName ?? 'User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (_stateManager.userEmail != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    _stateManager.userEmail!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProfileStat(
                      'Streak',
                      '${_stateManager.loginStreak}',
                      Icons.local_fire_department,
                    ),
                    _buildProfileStat(
                      'Tests',
                      '${analyticsSummary['total_assessments']}',
                      Icons.assessment,
                    ),
                    _buildProfileStat(
                      'Score',
                      '${_stateManager.getAverageCognitiveScore().toStringAsFixed(0)}',
                      Icons.stars,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Cognitive Scores Overview
          SectionHeader(title: 'Cognitive Performance'),
          SizedBox(height: 2.h),
          Container(
            height: 250,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: cognitiveScores.values.any((v) => v > 0)
                ? CognitiveRadarChart(scores: cognitiveScores)
                : Center(
                    child: Text(
                      'Complete assessments to see your scores',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
          ),
          SizedBox(height: 3.h),

          // Score Breakdown
          SectionHeader(title: 'Score Breakdown'),
          SizedBox(height: 1.h),
          ...cognitiveScores.entries.map((entry) {
            final domain = entry.key.split('_').map((w) => 
              w[0].toUpperCase() + w.substring(1)
            ).join(' ');
            
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        domain,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${entry.value.toStringAsFixed(0)}%',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: entry.value / 100,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getScoreColor(entry.value),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 3.h),

          // Statistics
          SectionHeader(title: 'Statistics'),
          SizedBox(height: 1.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.5,
            children: [
              StatCard(
                title: 'Assessments',
                value: '${analyticsSummary['total_assessments']}',
                icon: Icons.assignment_turned_in,
                color: const Color(0xFF2E7D9A),
              ),
              StatCard(
                title: 'Time Spent',
                value: '${analyticsSummary['total_time_spent']}m',
                icon: Icons.timer,
                color: const Color(0xFF2A9D8F),
              ),
              StatCard(
                title: 'Completion',
                value: '${(analyticsSummary['completion_rate'] * 100).toStringAsFixed(0)}%',
                icon: Icons.check_circle,
                color: const Color(0xFF4A90A4),
              ),
              StatCard(
                title: 'Modules',
                value: '${analyticsSummary['modules_completed']}',
                icon: Icons.apps,
                color: const Color(0xFFF4A261),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Achievements Section
          SectionHeader(title: 'Achievements'),
          SizedBox(height: 2.h),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                AchievementBadge(
                  title: 'First Steps',
                  icon: Icons.flag,
                  color: const Color(0xFF2A9D8F),
                  isUnlocked: _stateManager.totalAssessments >= 1,
                ),
                SizedBox(width: 4.w),
                AchievementBadge(
                  title: 'Dedicated',
                  icon: Icons.local_fire_department,
                  color: const Color(0xFFE76F51),
                  isUnlocked: _stateManager.loginStreak >= 7,
                ),
                SizedBox(width: 4.w),
                AchievementBadge(
                  title: 'High Score',
                  icon: Icons.stars,
                  color: const Color(0xFFF4A261),
                  isUnlocked: _stateManager.getAverageCognitiveScore() >= 80,
                ),
                SizedBox(width: 4.w),
                AchievementBadge(
                  title: 'Completionist',
                  icon: Icons.emoji_events,
                  color: const Color(0xFF4A90A4),
                  isUnlocked: _stateManager.overallProgress >= 1.0,
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return const Color(0xFF2A9D8F);
    if (score >= 60) return const Color(0xFF4A90A4);
    if (score >= 40) return const Color(0xFFE9C46A);
    return const Color(0xFFE76F51);
  }
}
