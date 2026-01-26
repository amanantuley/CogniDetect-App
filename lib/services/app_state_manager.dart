import 'package:flutter/foundation.dart';
import 'dart:async';

/// Advanced state management for the entire application
/// Implements singleton pattern with reactive state updates
class AppStateManager extends ChangeNotifier {
  static final AppStateManager _instance = AppStateManager._internal();
  factory AppStateManager() => _instance;
  AppStateManager._internal();

  // User Profile State
  String? _userId;
  String? _userName;
  String? _userEmail;
  DateTime? _lastLoginDate;
  int _loginStreak = 0;

  // Assessment Progress State
  Map<String, dynamic> _assessmentData = {};
  Map<String, bool> _moduleCompletion = {};
  Map<String, DateTime> _moduleTimestamps = {};
  double _overallProgress = 0.0;

  // Performance Metrics
  Map<String, double> _cognitiveScores = {
    'memory': 0.0,
    'attention': 0.0,
    'executive_function': 0.0,
    'processing_speed': 0.0,
    'language': 0.0,
  };

  // App Settings State
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  String _preferredLanguage = 'en';
  bool _autoSaveResults = true;

  // Session Management
  DateTime? _sessionStartTime;
  Duration _totalSessionDuration = Duration.zero;
  int _totalAssessments = 0;
  
  // Streaming Controllers for reactive updates
  final StreamController<Map<String, double>> _scoresController = 
      StreamController<Map<String, double>>.broadcast();
  final StreamController<double> _progressController = 
      StreamController<double>.broadcast();

  // Getters
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  DateTime? get lastLoginDate => _lastLoginDate;
  int get loginStreak => _loginStreak;
  Map<String, dynamic> get assessmentData => Map.unmodifiable(_assessmentData);
  Map<String, bool> get moduleCompletion => Map.unmodifiable(_moduleCompletion);
  double get overallProgress => _overallProgress;
  Map<String, double> get cognitiveScores => Map.unmodifiable(_cognitiveScores);
  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  String get preferredLanguage => _preferredLanguage;
  bool get autoSaveResults => _autoSaveResults;
  int get totalAssessments => _totalAssessments;
  Duration get totalSessionDuration => _totalSessionDuration;
  
  // Streams
  Stream<Map<String, double>> get scoresStream => _scoresController.stream;
  Stream<double> get progressStream => _progressController.stream;

  // User Profile Methods
  void setUserProfile({
    required String userId,
    required String userName,
    required String userEmail,
  }) {
    _userId = userId;
    _userName = userName;
    _userEmail = userEmail;
    _lastLoginDate = DateTime.now();
    _updateLoginStreak();
    notifyListeners();
  }

  void _updateLoginStreak() {
    final now = DateTime.now();
    if (_lastLoginDate != null) {
      final difference = now.difference(_lastLoginDate!).inDays;
      if (difference == 1) {
        _loginStreak++;
      } else if (difference > 1) {
        _loginStreak = 1;
      }
    } else {
      _loginStreak = 1;
    }
  }

  // Assessment Data Methods
  void updateAssessmentData(String moduleId, Map<String, dynamic> data) {
    _assessmentData[moduleId] = data;
    _moduleTimestamps[moduleId] = DateTime.now();
    _totalAssessments++;
    _calculateOverallProgress();
    notifyListeners();
  }

  void markModuleComplete(String moduleId, {Map<String, dynamic>? resultData}) {
    _moduleCompletion[moduleId] = true;
    if (resultData != null) {
      updateAssessmentData(moduleId, resultData);
    }
    _calculateOverallProgress();
    notifyListeners();
  }

  void _calculateOverallProgress() {
    if (_moduleCompletion.isEmpty) {
      _overallProgress = 0.0;
    } else {
      final completed = _moduleCompletion.values.where((v) => v).length;
      _overallProgress = completed / _moduleCompletion.length;
      _progressController.add(_overallProgress);
    }
  }

  // Cognitive Scores Methods
  void updateCognitiveScore(String domain, double score) {
    if (_cognitiveScores.containsKey(domain)) {
      _cognitiveScores[domain] = score.clamp(0.0, 100.0);
      _scoresController.add(_cognitiveScores);
      notifyListeners();
    }
  }

  void updateMultipleCognitiveScores(Map<String, double> scores) {
    scores.forEach((domain, score) {
      if (_cognitiveScores.containsKey(domain)) {
        _cognitiveScores[domain] = score.clamp(0.0, 100.0);
      }
    });
    _scoresController.add(_cognitiveScores);
    notifyListeners();
  }

  double getAverageCognitiveScore() {
    if (_cognitiveScores.isEmpty) return 0.0;
    final sum = _cognitiveScores.values.reduce((a, b) => a + b);
    return sum / _cognitiveScores.length;
  }

  // Settings Methods
  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  void setLanguage(String languageCode) {
    _preferredLanguage = languageCode;
    notifyListeners();
  }

  void toggleAutoSave() {
    _autoSaveResults = !_autoSaveResults;
    notifyListeners();
  }

  // Session Management
  void startSession() {
    _sessionStartTime = DateTime.now();
    notifyListeners();
  }

  void endSession() {
    if (_sessionStartTime != null) {
      final duration = DateTime.now().difference(_sessionStartTime!);
      _totalSessionDuration += duration;
      _sessionStartTime = null;
      notifyListeners();
    }
  }

  // Analytics Methods
  Map<String, dynamic> getAnalyticsSummary() {
    return {
      'total_assessments': _totalAssessments,
      'total_time_spent': _totalSessionDuration.inMinutes,
      'average_score': getAverageCognitiveScore(),
      'completion_rate': _overallProgress,
      'login_streak': _loginStreak,
      'modules_completed': _moduleCompletion.values.where((v) => v).length,
      'last_activity': _moduleTimestamps.values.isNotEmpty 
          ? _moduleTimestamps.values.reduce((a, b) => a.isAfter(b) ? a : b)
          : null,
    };
  }

  // Reset Methods
  void resetAssessmentData() {
    _assessmentData.clear();
    _moduleCompletion.clear();
    _moduleTimestamps.clear();
    _overallProgress = 0.0;
    _cognitiveScores.updateAll((key, value) => 0.0);
    _totalAssessments = 0;
    notifyListeners();
  }

  void resetAllData() {
    _userId = null;
    _userName = null;
    _userEmail = null;
    _lastLoginDate = null;
    _loginStreak = 0;
    resetAssessmentData();
    _totalSessionDuration = Duration.zero;
    notifyListeners();
  }

  @override
  void dispose() {
    _scoresController.close();
    _progressController.close();
    super.dispose();
  }
}
