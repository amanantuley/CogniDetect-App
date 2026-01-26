/// Application Constants and Configuration
class AppConfig {
  AppConfig._();

  // App Information
  static const String appName = 'CogniDetect';
  static const String appVersion = '1.0.0';
  static const String appBuild = '1';

  // API Configuration
  static const String apiBaseUrl = 'https://api.cognidetect.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableNotifications = true;
  static const bool enableAutoSave = true;
  static const bool enableOfflineMode = true;

  // Assessment Configuration
  static const int reactionTimeRounds = 10;
  static const int memoryMatrixMaxGridSize = 6;
  static const Duration assessmentTimeout = Duration(minutes: 30);

  // Notification Settings
  static const Duration reminderInterval = Duration(hours: 24);
  static const int maxNotificationsInCenter = 50;

  // Storage Configuration
  static const int maxStorageSizeKB = 10240; // 10 MB

  // User Preferences
  static const String defaultLanguage = 'en';
  static const bool defaultDarkMode = false;
  static const bool defaultNotifications = true;
  static const bool defaultSound = true;

  // Cognition Domains
  static const List<String> cognitiveDomains = [
    'memory',
    'attention',
    'executive_function',
    'processing_speed',
    'language',
  ];

  // Score Thresholds
  static const Map<String, Map<String, int>> scoreThresholds = {
    'excellent': {'min': 80, 'max': 100},
    'good': {'min': 70, 'max': 79},
    'average': {'min': 60, 'max': 69},
    'below_average': {'min': 50, 'max': 59},
    'needs_improvement': {'min': 0, 'max': 49},
  };
}

/// Route paths for easy navigation
class RoutePaths {
  RoutePaths._();

  static const String home = '/';
  static const String dashboard = '/main-dashboard';
  static const String login = '/google-login-screen';

  // Assessment Modules
  static const String speechAnalysis = '/speech-analysis-module';
  static const String cognitiveGames = '/cognitive-games-module';
  static const String eyeMovement = '/eye-movement-detection-module';
  static const String reactionTime = '/reaction-time-module';
  static const String memoryMatrix = '/memory-matrix-module';

  // Results
  static const String assessmentReport = '/final-assessment-report';
  static const String aiInsights = '/ai-insights';

  // User
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
}

/// API Status Codes
class ApiStatus {
  ApiStatus._();

  static const int success = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int conflict = 409;
  static const int serverError = 500;
}

/// Error Messages
class ErrorMessages {
  ErrorMessages._();

  static const String networkError = 'Network connection failed. Please try again.';
  static const String serverError = 'Server error occurred. Please try again later.';
  static const String unauthorizedError = 'Unauthorized access. Please login again.';
  static const String notFoundError = 'Resource not found.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String unknownError = 'An unknown error occurred.';
  static const String validationError = 'Invalid input. Please check your data.';
  static const String storageError = 'Failed to save data locally.';
  static const String permissionError = 'Permission denied. Please grant access.';
}

/// Success Messages
class SuccessMessages {
  SuccessMessages._();

  static const String assessmentComplete = 'Assessment completed successfully!';
  static const String profileUpdated = 'Profile updated successfully!';
  static const String dataSaved = 'Data saved successfully!';
  static const String dataDeleted = 'Data deleted successfully!';
  static const String settingsUpdated = 'Settings updated successfully!';
}
