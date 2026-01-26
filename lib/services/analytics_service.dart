import 'dart:async';
import 'package:flutter/foundation.dart';

/// Advanced analytics service for tracking user behavior and assessment performance
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final List<AnalyticsEvent> _events = [];
  final StreamController<AnalyticsEvent> _eventController = 
      StreamController<AnalyticsEvent>.broadcast();

  Stream<AnalyticsEvent> get eventStream => _eventController.stream;
  List<AnalyticsEvent> get allEvents => List.unmodifiable(_events);

  /// Track custom events
  void trackEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
    String? category,
    String? label,
  }) {
    final event = AnalyticsEvent(
      name: eventName,
      timestamp: DateTime.now(),
      parameters: parameters ?? {},
      category: category,
      label: label,
    );
    _events.add(event);
    _eventController.add(event);
    _logEvent(event);
  }

  /// Track screen views
  void trackScreenView(String screenName, {Map<String, dynamic>? properties}) {
    trackEvent(
      'screen_view',
      parameters: {'screen_name': screenName, ...?properties},
      category: 'navigation',
    );
  }

  /// Track assessment starts
  void trackAssessmentStart(String moduleId, String moduleName) {
    trackEvent(
      'assessment_start',
      parameters: {
        'module_id': moduleId,
        'module_name': moduleName,
        'start_time': DateTime.now().toIso8601String(),
      },
      category: 'assessment',
    );
  }

  /// Track assessment completions
  void trackAssessmentComplete(
    String moduleId,
    String moduleName, {
    required Duration duration,
    required double score,
    Map<String, dynamic>? additionalData,
  }) {
    trackEvent(
      'assessment_complete',
      parameters: {
        'module_id': moduleId,
        'module_name': moduleName,
        'duration_seconds': duration.inSeconds,
        'score': score,
        'completion_time': DateTime.now().toIso8601String(),
        ...?additionalData,
      },
      category: 'assessment',
    );
  }

  /// Track user interactions
  void trackInteraction(String interactionType, String elementId, {dynamic value}) {
    trackEvent(
      'user_interaction',
      parameters: {
        'interaction_type': interactionType,
        'element_id': elementId,
        'value': value,
      },
      category: 'interaction',
    );
  }

  /// Track errors
  void trackError(String errorType, String errorMessage, {StackTrace? stackTrace}) {
    trackEvent(
      'error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
        'stack_trace': stackTrace?.toString(),
      },
      category: 'error',
    );
  }

  /// Get events by category
  List<AnalyticsEvent> getEventsByCategory(String category) {
    return _events.where((e) => e.category == category).toList();
  }

  /// Get events by date range
  List<AnalyticsEvent> getEventsByDateRange(DateTime start, DateTime end) {
    return _events
        .where((e) => e.timestamp.isAfter(start) && e.timestamp.isBefore(end))
        .toList();
  }

  /// Get assessment analytics
  Map<String, dynamic> getAssessmentAnalytics() {
    final assessmentEvents = _events.where((e) => e.category == 'assessment');
    final starts = assessmentEvents.where((e) => e.name == 'assessment_start').length;
    final completions = assessmentEvents.where((e) => e.name == 'assessment_complete').length;
    
    final scores = assessmentEvents
        .where((e) => e.name == 'assessment_complete' && e.parameters.containsKey('score'))
        .map((e) => e.parameters['score'] as double)
        .toList();

    final avgScore = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;

    return {
      'total_starts': starts,
      'total_completions': completions,
      'completion_rate': starts > 0 ? (completions / starts) * 100 : 0,
      'average_score': avgScore,
      'highest_score': scores.isEmpty ? 0.0 : scores.reduce((a, b) => a > b ? a : b),
      'lowest_score': scores.isEmpty ? 0.0 : scores.reduce((a, b) => a < b ? a : b),
    };
  }

  /// Get user engagement metrics
  Map<String, dynamic> getUserEngagementMetrics() {
    final screenViews = _events.where((e) => e.name == 'screen_view').length;
    final interactions = _events.where((e) => e.category == 'interaction').length;
    
    final uniqueScreens = _events
        .where((e) => e.name == 'screen_view')
        .map((e) => e.parameters['screen_name'])
        .toSet()
        .length;

    return {
      'total_screen_views': screenViews,
      'unique_screens_viewed': uniqueScreens,
      'total_interactions': interactions,
      'avg_interactions_per_session': interactions / (screenViews > 0 ? screenViews : 1),
    };
  }

  /// Clear all events
  void clearEvents() {
    _events.clear();
  }

  /// Export events as JSON
  List<Map<String, dynamic>> exportEventsAsJson() {
    return _events.map((e) => e.toJson()).toList();
  }

  void _logEvent(AnalyticsEvent event) {
    if (kDebugMode) {
      print('[Analytics] ${event.name}: ${event.parameters}');
    }
  }

  void dispose() {
    _eventController.close();
  }
}

/// Model class for analytics events
class AnalyticsEvent {
  final String name;
  final DateTime timestamp;
  final Map<String, dynamic> parameters;
  final String? category;
  final String? label;

  AnalyticsEvent({
    required this.name,
    required this.timestamp,
    required this.parameters,
    this.category,
    this.label,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'timestamp': timestamp.toIso8601String(),
        'parameters': parameters,
        'category': category,
        'label': label,
      };

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) => AnalyticsEvent(
        name: json['name'],
        timestamp: DateTime.parse(json['timestamp']),
        parameters: Map<String, dynamic>.from(json['parameters']),
        category: json['category'],
        label: json['label'],
      );
}
