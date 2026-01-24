import 'package:flutter/material.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/google_login_screen/google_login_screen.dart';
import '../presentation/speech_analysis_module/speech_analysis_module.dart';
import '../presentation/cognitive_games_module/cognitive_games_module.dart';
import '../presentation/final_assessment_report/final_assessment_report.dart';
import '../presentation/eye_movement_detection_module/eye_movement_detection_module.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String mainDashboard = '/main-dashboard';
  static const String googleLogin = '/google-login-screen';
  static const String speechAnalysisModule = '/speech-analysis-module';
  static const String cognitiveGamesModule = '/cognitive-games-module';
  static const String finalAssessmentReport = '/final-assessment-report';
  static const String eyeMovementDetectionModule =
      '/eye-movement-detection-module';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const GoogleLoginScreen(),
    mainDashboard: (context) => const MainDashboard(),
    googleLogin: (context) => const GoogleLoginScreen(),
    speechAnalysisModule: (context) => const SpeechAnalysisModule(),
    cognitiveGamesModule: (context) => const CognitiveGamesModule(),
    finalAssessmentReport: (context) => const FinalAssessmentReport(),
    eyeMovementDetectionModule: (context) => const EyeMovementDetectionModule(),
    // TODO: Add your other routes here
  };
}
