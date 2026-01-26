import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

/// Navigation service for managing app navigation
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  
  late GlobalKey<NavigatorState> _navigationKey;
  final List<String> _navigationStack = [];

  factory NavigationService() {
    return _instance;
  }

  NavigationService._internal() {
    _navigationKey = GlobalKey<NavigatorState>();
  }

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;
  
  /// Initialize the navigation service (call in main.dart)
  void initialize(GlobalKey<NavigatorState> key) {
    _navigationKey = key;
  }

  /// Push new route
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    _navigationStack.add(routeName);
    return _navigationKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  /// Replace current route
  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
    }
    _navigationStack.add(routeName);
    return _navigationKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Pop current route
  void pop<T extends Object?>({T? result}) {
    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();
    }
    _navigationKey.currentState!.pop(result);
  }

  /// Pop until route
  void popUntil(String routeName) {
    _navigationKey.currentState!.popUntil(
      (route) {
        if (route.settings.name == routeName) {
          return true;
        }
        if (_navigationStack.isNotEmpty) {
          _navigationStack.removeLast();
        }
        return false;
      },
    );
  }

  /// Push and remove until
  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required String untilRouteName,
  }) {
    _navigationStack.clear();
    _navigationStack.add(routeName);
    return _navigationKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) {
        return route.settings.name == untilRouteName;
      },
      arguments: arguments,
    );
  }

  /// Check if can pop
  bool canPop() => _navigationKey.currentState!.canPop();

  /// Get current route
  String? getCurrentRoute() {
    return _navigationStack.isNotEmpty ? _navigationStack.last : null;
  }

  /// Get navigation stack
  List<String> getNavigationStack() => List.unmodifiable(_navigationStack);

  /// Clear navigation stack
  void clearStack() {
    _navigationStack.clear();
  }

  /// Navigate to home
  void navigateToHome() => pushReplacementNamed(AppRoutes.home);

  /// Navigate to login
  void navigateToLogin() => pushNamedAndRemoveUntil(
    AppRoutes.googleLogin,
    untilRouteName: AppRoutes.googleLogin,
  );

  /// Navigate to dashboard
  void navigateToDashboard() => pushReplacementNamed(AppRoutes.mainDashboard);

  /// Navigate to assessment with type
  void navigateToAssessment(String assessmentType) {
    switch (assessmentType) {
      case 'reaction':
        pushNamed(AppRoutes.reactionTimeModule);
        break;
      case 'memory':
        pushNamed(AppRoutes.memoryMatrixModule);
        break;
      case 'games':
        pushNamed(AppRoutes.cognitiveGamesModule);
        break;
      case 'speech':
        pushNamed(AppRoutes.speechAnalysisModule);
        break;
      case 'eye':
        pushNamed(AppRoutes.eyeMovementDetectionModule);
        break;
      default:
        pushNamed(AppRoutes.mainDashboard);
    }
  }
}

/// Deep link handler
class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  
  late NavigationService _navigationService;

  factory DeepLinkHandler() {
    return _instance;
  }

  DeepLinkHandler._internal();

  void initialize(NavigationService navigationService) {
    _navigationService = navigationService;
  }

  /// Handle deep link
  void handleDeepLink(Uri uri) {
    final path = uri.path;
    final params = uri.queryParameters;

    if (path.contains('assessment')) {
      final type = params['type'] ?? 'reaction';
      _navigationService.navigateToAssessment(type);
    } else if (path.contains('profile')) {
      _navigationService.pushNamed(AppRoutes.profileScreen);
    } else if (path.contains('settings')) {
      _navigationService.pushNamed(AppRoutes.settingsScreen);
    } else if (path.contains('insights')) {
      _navigationService.pushNamed(AppRoutes.aiInsights);
    } else if (path.contains('notifications')) {
      _navigationService.pushNamed(AppRoutes.notificationCenter);
    } else if (path.contains('report')) {
      _navigationService.pushNamed(AppRoutes.finalAssessmentReport);
    } else {
      _navigationService.navigateToHome();
    }
  }

  /// Generate deep link
  static String generateDeepLink(String route, [Map<String, String>? params]) {
    String link = 'cognidetect://$route';
    if (params != null && params.isNotEmpty) {
      final queryString = params.entries.map((e) => '${e.key}=${e.value}').join('&');
      link += '?$queryString';
    }
    return link;
  }
}

/// Route transition helper
class RouteTransition {
  /// Slide transition from bottom
  static PageRoute<T> slideTransition<T>(
    Widget page, {
    Curve curve = Curves.easeInOut,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: duration,
    );
  }

  /// Fade transition
  static PageRoute<T> fadeTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: duration,
    );
  }

  /// Scale transition
  static PageRoute<T> scaleTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOutCubic;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return ScaleTransition(scale: animation.drive(tween), child: child);
      },
      transitionDuration: duration,
    );
  }

  /// Rotation transition
  static PageRoute<T> rotationTransition<T>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: animation,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }
}
