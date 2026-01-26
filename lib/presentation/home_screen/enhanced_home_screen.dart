import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../config/app_config.dart';
import '../../widgets/advanced_ui_components.dart';
import '../../widgets/advanced_animations.dart';

/// Enhanced Home Screen with Dashboard Integration
class EnhancedHomeScreen extends StatefulWidget {
  const EnhancedHomeScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen> {
  final _stateManager = AppStateManager();
  final _analytics = AnalyticsService();
  final _notifications = NotificationService();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _analytics.trackScreenView('home_dashboard');
    _initializeIfNeeded();
  }

  void _initializeIfNeeded() {
    if (_stateManager.userName == null) {
      // Set demo user if not set
      _stateManager.setUserProfile(
        userId: 'demo_user',
        userName: 'Welcome User',
        userEmail: 'user@cognidetect.com',
      );
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    _analytics.trackInteraction('refresh', 'dashboard');
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
    _notifications.showInfo('Dashboard refreshed');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CogniDetect'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, RoutePaths.notifications),
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, RoutePaths.profile),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Welcome Header
            _buildWelcomeHeader(theme),
            
            SizedBox(height: 3.h),

            // Quick Stats
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SectionHeader(
                title: 'Your Statistics',
                action: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, RoutePaths.profile),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            _buildStatsGrid(),
            
            SizedBox(height: 3.h),

            // Quick Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: const SectionHeader(title: 'Start Assessment'),
            ),
            SizedBox(height: 2.h),
            _buildAssessmentModules(),

            SizedBox(height: 3.h),

            // AI Insights Preview
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SectionHeader(
                title: 'AI Insights',
                action: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, RoutePaths.aiInsights),
                  child: Text(
                    'View More',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            _buildAIInsightsPreview(),

            SizedBox(height: 3.h),

            // Recent Activity
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: const SectionHeader(title: 'Recent Activity'),
            ),
            SizedBox(height: 1.h),
            _buildRecentActivity(),

            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D9A), Color(0xFF4A90A4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D9A).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${_stateManager.userName}! 👋',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Track and improve your cognitive abilities',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 2.h),
          GradientButton(
            text: 'View Report',
            icon: Icons.assessment,
            onPressed: () => Navigator.pushNamed(context, RoutePaths.assessmentReport),
            gradientColors: const [Colors.white10, Colors.white24],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.6,
        children: [
          StatCard(
            title: 'Avg Score',
            value: '${_stateManager.getAverageCognitiveScore().toStringAsFixed(0)}%',
            icon: Icons.stars,
            color: const Color(0xFF2E7D9A),
            trend: 5.5,
          ),
          StatCard(
            title: 'Assessments',
            value: '${_stateManager.totalAssessments}',
            icon: Icons.assignment_turned_in,
            color: const Color(0xFF2A9D8F),
            trend: 10.0,
          ),
          StatCard(
            title: 'Streak',
            value: '${_stateManager.loginStreak}',
            icon: Icons.local_fire_department,
            color: const Color(0xFFE76F51),
            trend: 2.0,
          ),
          StatCard(
            title: 'Progress',
            value: '${(_stateManager.overallProgress * 100).toStringAsFixed(0)}%',
            icon: Icons.trending_up,
            color: const Color(0xFF4A90A4),
            trend: 15.0,
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentModules() {
    final modules = [
      {
        'title': 'Reaction Time',
        'icon': Icons.speed,
        'color': const Color(0xFF2E7D9A),
        'route': RoutePaths.reactionTime,
        'description': '10 rounds',
      },
      {
        'title': 'Memory Matrix',
        'icon': Icons.grid_3x3,
        'color': const Color(0xFF2A9D8F),
        'route': RoutePaths.memoryMatrix,
        'description': 'Progressive',
      },
      {
        'title': 'Cognitive Games',
        'icon': Icons.gamepad,
        'color': const Color(0xFF4A90A4),
        'route': RoutePaths.cognitiveGames,
        'description': 'Interactive',
      },
      {
        'title': 'Speech Analysis',
        'icon': Icons.mic,
        'color': const Color(0xFFF4A261),
        'route': RoutePaths.speechAnalysis,
        'description': 'Voice test',
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: modules.asMap().entries.map((entry) {
          final module = entry.value;
          return Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: GestureDetector(
              onTap: () {
                _analytics.trackInteraction('assessment_start', module['title']?.toString() ?? '');
                Navigator.pushNamed(context, module['route']?.toString() ?? '');
              },
              child: Container(
                width: 35.w,
                decoration: BoxDecoration(
                  color: (module['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (module['color'] as Color).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                padding: EdgeInsets.all(3.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: module['color'] as Color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        module['icon'] as IconData,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      module['title']?.toString() ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      module['description']?.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAIInsightsPreview() {
    final scores = _stateManager.cognitiveScores;
    final hasData = scores.values.any((v) => v > 0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2E7D9A).withOpacity(0.1),
                const Color(0xFF4A90A4).withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: hasData
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Performance Level',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getPerformanceColor().withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getPerformanceLevel(),
                            style: TextStyle(
                              color: _getPerformanceColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: _stateManager.getAverageCognitiveScore() / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getPerformanceColor(),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Continue assessments to get personalized AI recommendations',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Text(
                      'Complete assessments to see AI insights',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final analyticsData = _analytics.allEvents.take(3).toList();

    if (analyticsData.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Center(
          child: Text(
            'No recent activity',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: analyticsData.map((event) {
          return Card(
            elevation: 0,
            margin: EdgeInsets.only(bottom: 1.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D9A).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.history,
                  color: Color(0xFF2E7D9A),
                  size: 20,
                ),
              ),
              title: Text(
                event.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              subtitle: Text(
                _formatTime(event.timestamp),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getPerformanceLevel() {
    final score = _stateManager.getAverageCognitiveScore();
    if (score >= 80) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 60) return 'Average';
    if (score >= 50) return 'Below Average';
    return 'Needs Improvement';
  }

  Color _getPerformanceColor() {
    final score = _stateManager.getAverageCognitiveScore();
    if (score >= 80) return const Color(0xFF2A9D8F);
    if (score >= 70) return const Color(0xFF4A90A4);
    if (score >= 60) return const Color(0xFFE9C46A);
    if (score >= 50) return const Color(0xFFE76F51);
    return const Color(0xFFE76F51);
  }

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
