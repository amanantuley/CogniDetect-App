import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await _initializeServices();

  bool hasShownError = false;

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!hasShownError) {
      hasShownError = true;

      // Reset flag after 3 seconds to allow error widget on new screens
      Future.delayed(Duration(seconds: 5), () {
        hasShownError = false;
      });

      return CustomErrorWidget(errorDetails: details);
    }
    return SizedBox.shrink();
  };

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]).then((value) {
    runApp(MyApp());
  });
}

/// Initialize all app services
Future<void> _initializeServices() async {
  try {
    // Initialize storage service
    final storage = LocalStorageService();
    await storage.initialize();
    
    // Initialize state manager
    final stateManager = AppStateManager();
    
    // Show welcome notification
    final notificationService = NotificationService();
    notificationService.showInfo(
      'Welcome to CogniDetect!',
      title: 'Get Started',
    );
    
    // Schedule daily reminder (example)
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    notificationService.scheduleReminder(
      title: 'Daily Assessment',
      message: 'Complete your cognitive assessment today!',
      scheduledTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0),
    );
    
    print('✅ All services initialized successfully');
  } catch (e) {
    print('⚠️ Error initializing services: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'CogniDetect - Advanced Cognitive Assessment',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },
          // 🚨 END CRITICAL SECTION
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.initial,
        );
      },
    );
  }
}
