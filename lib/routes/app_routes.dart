import 'package:flutter/material.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/google_login_screen/google_login_screen.dart';
import '../presentation/speech_analysis_module/speech_analysis_module.dart';
import '../presentation/cognitive_games_module/cognitive_games_module.dart';
import '../presentation/final_assessment_report/final_assessment_report.dart';
import '../presentation/eye_movement_detection_module/eye_movement_detection_module.dart';
import '../presentation/reaction_time_module/reaction_time_module.dart';
import '../presentation/memory_matrix_module/memory_matrix_module.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/notification_center/notification_center_screen.dart';
import '../presentation/ai_insights_screen/ai_insights_screen.dart';

class AppRoutes {
  // Main Routes
  static const String initial = '/';
  static const String mainDashboard = '/main-dashboard';
  static const String googleLogin = '/google-login-screen';
  
  // Assessment Modules
  static const String speechAnalysisModule = '/speech-analysis-module';
  static const String cognitiveGamesModule = '/cognitive-games-module';
  static const String eyeMovementDetectionModule = '/eye-movement-detection-module';
  static const String reactionTimeModule = '/reaction-time-module';
  static const String memoryMatrixModule = '/memory-matrix-module';
  
  // Results & Reports
  static const String finalAssessmentReport = '/final-assessment-report';
  static const String aiInsights = '/ai-insights';
  
  // User Management
  static const String profileScreen = '/profile';
  static const String settingsScreen = '/settings';
  static const String notificationCenter = '/notifications';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const GoogleLoginScreen(),
    mainDashboard: (context) => const MainDashboard(),
    googleLogin: (context) => const GoogleLoginScreen(),
    
    // Assessment Modules
    speechAnalysisModule: (context) => const SpeechAnalysisModule(),
    cognitiveGamesModule: (context) => const CognitiveGamesModule(),
    eyeMovementDetectionModule: (context) => const EyeMovementDetectionModule(),
    reactionTimeModule: (context) => const ReactionTimeModule(),
    memoryMatrixModule: (context) => const MemoryMatrixModule(),
    
    // Results & Reports
    finalAssessmentReport: (context) => const FinalAssessmentReport(),
    aiInsights: (context) => const AIInsightsScreen(),
    
    // User Management
    profileScreen: (context) => const ProfileScreen(),
    settingsScreen: (context) => const SettingsScreen(),
    notificationCenter: (context) => const NotificationCenterScreen(),
  };
}
