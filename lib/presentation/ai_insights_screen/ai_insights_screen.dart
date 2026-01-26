import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../services/app_state_manager.dart';
import '../../services/ai_analysis_service.dart';
import '../../services/analytics_service.dart';
import '../../widgets/advanced_ui_components.dart';

/// AI-Powered Insights and Recommendations Screen
class AIInsightsScreen extends StatefulWidget {
  const AIInsightsScreen({Key? key}) : super(key: key);

  @override
  State<AIInsightsScreen> createState() => _AIInsightsScreenState();
}

class _AIInsightsScreenState extends State<AIInsightsScreen> {
  final _stateManager = AppStateManager();
  final _aiService = AIAnalysisService();
  final _analytics = AnalyticsService();
  
  Map<String, dynamic>? _analysis;
  List<Map<String, dynamic>>? _trainingPlan;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _analytics.trackScreenView('ai_insights');
    _performAnalysis();
  }

  void _performAnalysis() {
    setState(() => _isLoading = true);
    
    final scores = _stateManager.cognitiveScores;
    if (scores.values.any((v) => v > 0)) {
      _analysis = _aiService.analyzeCognitivePatterns(scores);
      _trainingPlan = _aiService.generateTrainingPlan(scores);
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Insights'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _performAnalysis,
            tooltip: 'Refresh Analysis',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _analysis == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 80,
                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No data available',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Complete assessments to get AI-powered insights',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: EdgeInsets.all(4.w),
                  children: [
                    // Overall Performance Card
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
                          const Icon(
                            Icons.stars,
                            color: Colors.white,
                            size: 48,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${_analysis!['overall_score'].toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _analysis!['performance_level'],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Cognitive Age: ${_analysis!['cognitive_age_estimate']} years',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Insights Section
                    SectionHeader(title: 'Key Insights'),
                    SizedBox(height: 1.h),
                    ..._buildInsights(_analysis!['insights'] as List),
                    SizedBox(height: 3.h),

                    // Strengths Section
                    if ((_analysis!['strengths'] as List).isNotEmpty) ...[
                      SectionHeader(
                        title: 'Your Strengths',
                        subtitle: 'Keep up the good work!',
                      ),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (_analysis!['strengths'] as List)
                            .map((strength) => Chip(
                                  avatar: const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF2A9D8F),
                                    size: 18,
                                  ),
                                  label: Text(strength.toString()),
                                  backgroundColor:
                                      const Color(0xFF2A9D8F).withOpacity(0.1),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 3.h),
                    ],

                    // Areas for Improvement
                    if ((_analysis!['areas_for_improvement'] as List).isNotEmpty) ...[
                      SectionHeader(
                        title: 'Focus Areas',
                        subtitle: 'Opportunities for growth',
                      ),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (_analysis!['areas_for_improvement'] as List)
                            .map((area) => Chip(
                                  avatar: const Icon(
                                    Icons.trending_up,
                                    color: Color(0xFFF4A261),
                                    size: 18,
                                  ),
                                  label: Text(area.toString()),
                                  backgroundColor:
                                      const Color(0xFFF4A261).withOpacity(0.1),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 3.h),
                    ],

                    // Recommendations Section
                    SectionHeader(title: 'Recommendations'),
                    SizedBox(height: 1.h),
                    ..._buildRecommendations(_analysis!['recommendations'] as List),
                    SizedBox(height: 3.h),

                    // Personalized Training Plan
                    if (_trainingPlan != null && _trainingPlan!.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Personalized Training Plan',
                        subtitle: 'Tailored to your needs',
                      ),
                      SizedBox(height: 1.h),
                      ..._trainingPlan!.map((plan) => _buildTrainingCard(plan)),
                      SizedBox(height: 3.h),
                    ],

                    // Action Button
                    GradientButton(
                      text: 'Start Training',
                      icon: Icons.play_arrow,
                      onPressed: () {
                        Navigator.pushNamed(context, '/cognitive-games-module');
                      },
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
    );
  }

  List<Widget> _buildInsights(List insights) {
    return insights
        .map((insight) => Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90A4).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lightbulb,
                    color: Color(0xFF4A90A4),
                  ),
                ),
                title: Text(
                  insight.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ))
        .toList();
  }

  List<Widget> _buildRecommendations(List recommendations) {
    return recommendations
        .map((rec) => Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A9D8F).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF2A9D8F),
                  ),
                ),
                title: Text(
                  rec.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ))
        .toList();
  }

  Widget _buildTrainingCard(Map<String, dynamic> plan) {
    final priorityColors = {
      'high': const Color(0xFFE76F51),
      'medium': const Color(0xFFF4A261),
      'low': const Color(0xFF2A9D8F),
    };

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    plan['domain'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColors[plan['priority']]?.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    plan['priority'].toString().toUpperCase(),
                    style: TextStyle(
                      color: priorityColors[plan['priority']],
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Text(
                  'Current: ${plan['current_score'].toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward, size: 16),
                const SizedBox(width: 16),
                Text(
                  'Target: ${plan['target_score'].toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Duration: ${plan['estimated_duration']}',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 1.h),
            const Text(
              'Recommended Exercises:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            ...((plan['exercises'] as List).map((exercise) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Text(
                          exercise.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ))),
          ],
        ),
      ),
    );
  }
}
