import 'dart:math';

/// Advanced AI-powered cognitive analysis service
class AIAnalysisService {
  static final AIAnalysisService _instance = AIAnalysisService._internal();
  factory AIAnalysisService() => _instance;
  AIAnalysisService._internal();

  /// Analyze cognitive patterns and generate insights
  Map<String, dynamic> analyzeCognitivePatterns(Map<String, double> scores) {
    final insights = <String>[];
    final recommendations = <String>[];
    final strengths = <String>[];
    final areasForImprovement = <String>[];

    // Analyze each cognitive domain
    scores.forEach((domain, score) {
      if (score >= 80) {
        strengths.add(_getDomainName(domain));
      } else if (score < 60) {
        areasForImprovement.add(_getDomainName(domain));
        recommendations.add(_getRecommendation(domain));
      }
    });

    // Generate overall insights
    final avgScore = scores.values.isNotEmpty
        ? scores.values.reduce((a, b) => a + b) / scores.length
        : 0.0;

    if (avgScore >= 80) {
      insights.add('Excellent overall cognitive performance!');
    } else if (avgScore >= 60) {
      insights.add('Good cognitive performance with room for improvement.');
    } else {
      insights.add('Focus on targeted cognitive exercises to improve scores.');
    }

    // Detect patterns
    final variability = _calculateVariability(scores.values.toList());
    if (variability > 25) {
      insights.add('Significant variability across cognitive domains detected.');
      recommendations.add('Consider balanced training across all cognitive areas.');
    } else {
      insights.add('Consistent performance across cognitive domains.');
    }

    return {
      'overall_score': avgScore,
      'performance_level': _getPerformanceLevel(avgScore),
      'insights': insights,
      'recommendations': recommendations,
      'strengths': strengths,
      'areas_for_improvement': areasForImprovement,
      'cognitive_age_estimate': _estimateCognitiveAge(avgScore),
      'trend_prediction': _predictTrend(scores),
    };
  }

  /// Predict future performance based on historical data
  Map<String, dynamic> predictFuturePerformance(
    List<Map<String, double>> historicalScores,
  ) {
    if (historicalScores.length < 2) {
      return {
        'prediction': 'Insufficient data for prediction',
        'confidence': 0.0,
      };
    }

    final recentScores = historicalScores.take(5).toList();
    final trends = <String, double>{};

    // Calculate trend for each domain
    for (final domain in recentScores.first.keys) {
      final scores = recentScores.map((s) => s[domain] ?? 0.0).toList();
      final trend = _calculateTrend(scores);
      trends[domain] = trend;
    }

    final avgTrend = trends.values.reduce((a, b) => a + b) / trends.length;

    return {
      'overall_trend': avgTrend > 0 ? 'improving' : avgTrend < 0 ? 'declining' : 'stable',
      'domain_trends': trends,
      'predicted_improvement': avgTrend * 30, // 30-day projection
      'confidence': _calculateConfidence(recentScores),
    };
  }

  /// Generate personalized training recommendations
  List<Map<String, dynamic>> generateTrainingPlan(Map<String, double> scores) {
    final plan = <Map<String, dynamic>>[];

    scores.forEach((domain, score) {
      if (score < 70) {
        plan.add({
          'domain': _getDomainName(domain),
          'current_score': score,
          'target_score': min(score + 20, 100),
          'exercises': _getExercisesForDomain(domain),
          'estimated_duration': '2-3 weeks',
          'priority': score < 50 ? 'high' : 'medium',
        });
      }
    });

    // Sort by priority
    plan.sort((a, b) {
      final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
      return (priorityOrder[a['priority']] ?? 2)
          .compareTo(priorityOrder[b['priority']] ?? 2);
    });

    return plan;
  }

  /// Detect potential cognitive decline patterns
  Map<String, dynamic> detectCognitiveDecline(
    List<Map<String, double>> historicalScores,
  ) {
    if (historicalScores.length < 3) {
      return {'risk_level': 'unknown', 'message': 'Insufficient data'};
    }

    final recentScores = historicalScores.take(5).toList();
    var decliningDomains = 0;
    final concernAreas = <String>[];

    for (final domain in recentScores.first.keys) {
      final scores = recentScores.map((s) => s[domain] ?? 0.0).toList();
      final trend = _calculateTrend(scores);
      
      if (trend < -5) {
        decliningDomains++;
        concernAreas.add(_getDomainName(domain));
      }
    }

    String riskLevel;
    String message;

    if (decliningDomains >= 3) {
      riskLevel = 'high';
      message = 'Multiple domains showing decline. Consider consulting a healthcare professional.';
    } else if (decliningDomains >= 1) {
      riskLevel = 'moderate';
      message = 'Some cognitive domains showing decline. Continue regular assessments.';
    } else {
      riskLevel = 'low';
      message = 'No significant decline detected. Maintain current cognitive activities.';
    }

    return {
      'risk_level': riskLevel,
      'declining_domains': decliningDomains,
      'concern_areas': concernAreas,
      'message': message,
      'recommendation': riskLevel == 'high'
          ? 'Consult healthcare professional'
          : 'Continue regular cognitive exercises',
    };
  }

  String _getDomainName(String domain) {
    return domain.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }

  String _getRecommendation(String domain) {
    final recommendations = {
      'memory': 'Practice memory games and mnemonic techniques daily',
      'attention': 'Engage in focused meditation and attention training exercises',
      'executive_function': 'Try problem-solving puzzles and strategic games',
      'processing_speed': 'Practice reaction time exercises and quick decision-making tasks',
      'language': 'Read regularly and practice vocabulary-building exercises',
    };
    return recommendations[domain] ?? 'Engage in regular cognitive training';
  }

  String _getPerformanceLevel(double score) {
    if (score >= 90) return 'Exceptional';
    if (score >= 80) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 60) return 'Average';
    if (score >= 50) return 'Below Average';
    return 'Needs Improvement';
  }

  int _estimateCognitiveAge(double avgScore) {
    // Simplified cognitive age estimation
    if (avgScore >= 90) return 25;
    if (avgScore >= 80) return 35;
    if (avgScore >= 70) return 45;
    if (avgScore >= 60) return 55;
    if (avgScore >= 50) return 65;
    return 75;
  }

  String _predictTrend(Map<String, double> scores) {
    final avgScore = scores.values.reduce((a, b) => a + b) / scores.length;
    if (avgScore >= 80) return 'stable_high';
    if (avgScore >= 60) return 'stable_medium';
    return 'needs_attention';
  }

  double _calculateVariability(List<double> scores) {
    if (scores.isEmpty) return 0.0;
    final mean = scores.reduce((a, b) => a + b) / scores.length;
    final variance = scores.map((s) => pow(s - mean, 2)).reduce((a, b) => a + b) / scores.length;
    return sqrt(variance);
  }

  double _calculateTrend(List<double> scores) {
    if (scores.length < 2) return 0.0;
    
    // Simple linear regression
    final n = scores.length;
    final xMean = (n - 1) / 2;
    var numerator = 0.0;
    var denominator = 0.0;

    for (var i = 0; i < n; i++) {
      numerator += (i - xMean) * scores[i];
      denominator += pow(i - xMean, 2);
    }

    return denominator != 0 ? numerator / denominator : 0.0;
  }

  double _calculateConfidence(List<Map<String, double>> scores) {
    if (scores.length < 3) return 0.3;
    if (scores.length < 5) return 0.6;
    return 0.85;
  }

  List<String> _getExercisesForDomain(String domain) {
    final exercises = {
      'memory': [
        'Memory card matching game',
        'Number sequence recall',
        'Story recall exercise',
      ],
      'attention': [
        'Focus training with distractions',
        'Visual search tasks',
        'Dual-task exercises',
      ],
      'executive_function': [
        'Planning and strategy games',
        'Problem-solving puzzles',
        'Task-switching exercises',
      ],
      'processing_speed': [
        'Reaction time drills',
        'Rapid decision-making tasks',
        'Speed reading exercises',
      ],
      'language': [
        'Vocabulary building games',
        'Verbal fluency exercises',
        'Reading comprehension tasks',
      ],
    };
    return exercises[domain] ?? ['General cognitive training'];
  }
}
