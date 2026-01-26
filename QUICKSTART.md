# 🚀 Quick Start Guide - Advanced Components

## How to Use the New Advanced Components

### 1. State Management

```dart
import 'package:cognidetect/services/app_state_manager.dart';

// Get instance
final stateManager = AppStateManager();

// Set user profile
stateManager.setUserProfile(
  userId: 'user123',
  userName: 'John Doe',
  userEmail: 'john@example.com',
);

// Update cognitive scores
stateManager.updateCognitiveScore('memory', 85.0);
stateManager.updateMultipleCognitiveScores({
  'memory': 85.0,
  'attention': 78.0,
  'executive_function': 82.0,
});

// Listen to score updates
stateManager.scoresStream.listen((scores) {
  print('Updated scores: $scores');
});

// Mark module as complete
stateManager.markModuleComplete('memory_test', resultData: {
  'score': 85.0,
  'duration': 300,
});
```

### 2. Analytics Service

```dart
import 'package:cognidetect/services/analytics_service.dart';

final analytics = AnalyticsService();

// Track events
analytics.trackEvent(
  'button_clicked',
  parameters: {'button_id': 'start_test'},
  category: 'interaction',
);

// Track screen views
analytics.trackScreenView('home_screen');

// Track assessments
analytics.trackAssessmentStart('memory_test', 'Memory Assessment');

analytics.trackAssessmentComplete(
  'memory_test',
  'Memory Assessment',
  duration: Duration(minutes: 5),
  score: 85.0,
  additionalData: {'difficulty': 'medium'},
);

// Get analytics summary
final summary = analytics.getAssessmentAnalytics();
print('Average score: ${summary['average_score']}');
```

### 3. Notification Service

```dart
import 'package:cognidetect/services/notification_service.dart';

final notifications = NotificationService();

// Show notifications
notifications.showSuccess('Assessment completed!');
notifications.showError('Failed to save data');
notifications.showWarning('Low battery detected');
notifications.showInfo('New feature available');

// Schedule reminders
notifications.scheduleReminder(
  title: 'Daily Assessment',
  message: 'Complete your cognitive test today!',
  scheduledTime: DateTime.now().add(Duration(days: 1)),
);

// Listen to notifications
notifications.notificationStream.listen((notification) {
  print('New notification: ${notification.title}');
});

// Get unread count
final unreadCount = notifications.unreadCount;
```

### 4. Local Storage

```dart
import 'package:cognidetect/services/local_storage_service.dart';

final storage = LocalStorageService();

// Initialize first
await storage.initialize();

// Save and load JSON
await storage.saveJson('user_data', {
  'name': 'John',
  'score': 85,
});

final userData = await storage.loadJson('user_data');

// Save and load strings
await storage.saveString('last_login', DateTime.now().toIso8601String());
final lastLogin = await storage.loadString('last_login');

// Check storage size
final sizeInBytes = await storage.getStorageSize();
```

### 5. AI Analysis Service

```dart
import 'package:cognidetect/services/ai_analysis_service.dart';

final aiService = AIAnalysisService();

// Analyze cognitive patterns
final analysis = aiService.analyzeCognitivePatterns({
  'memory': 85.0,
  'attention': 78.0,
  'executive_function': 82.0,
});

print('Performance Level: ${analysis['performance_level']}');
print('Insights: ${analysis['insights']}');
print('Cognitive Age: ${analysis['cognitive_age_estimate']}');

// Generate training plan
final trainingPlan = aiService.generateTrainingPlan({
  'memory': 65.0,
  'attention': 55.0,
});

for (final plan in trainingPlan) {
  print('Focus on: ${plan['domain']}');
  print('Target: ${plan['target_score']}%');
  print('Exercises: ${plan['exercises']}');
}

// Detect cognitive decline
final declineAnalysis = aiService.detectCognitiveDecline([
  {'memory': 85.0, 'attention': 80.0},
  {'memory': 82.0, 'attention': 78.0},
  {'memory': 79.0, 'attention': 75.0},
]);

print('Risk Level: ${declineAnalysis['risk_level']}');
```

---

## Advanced Widgets Usage

### 1. Animated Progress Ring

```dart
import 'package:cognidetect/widgets/advanced_animations.dart';

AnimatedProgressRing(
  progress: 0.75, // 75%
  size: 120,
  strokeWidth: 12,
  progressColor: Color(0xFF2E7D9A),
  showPercentage: true,
)
```

### 2. Gradient Card

```dart
AnimatedGradientCard(
  gradientColors: [Color(0xFF2E7D9A), Color(0xFF4A90A4)],
  height: 200,
  enableShimmer: true,
  onTap: () => print('Card tapped'),
  child: YourContentWidget(),
)
```

### 3. Radar Chart

```dart
import 'package:cognidetect/widgets/advanced_charts.dart';

CognitiveRadarChart(
  scores: {
    'memory': 85.0,
    'attention': 78.0,
    'executive_function': 82.0,
    'processing_speed': 76.0,
    'language': 88.0,
  },
  fillColor: Color(0xFF4A90A4),
  borderColor: Color(0xFF2E7D9A),
)
```

### 4. Line Chart

```dart
ProgressLineChart(
  dataPoints: [
    FlSpot(0, 65),
    FlSpot(1, 70),
    FlSpot(2, 75),
    FlSpot(3, 80),
  ],
  title: 'Progress Over Time',
  lineColor: Color(0xFF2E7D9A),
  showDots: true,
)
```

### 5. Stat Card

```dart
import 'package:cognidetect/widgets/advanced_ui_components.dart';

StatCard(
  title: 'Assessments',
  value: '24',
  icon: Icons.assignment_turned_in,
  color: Color(0xFF2E7D9A),
  subtitle: 'This month',
  trend: 15.5, // +15.5% increase
  onTap: () => print('Card tapped'),
)
```

### 6. Gradient Button

```dart
GradientButton(
  text: 'Start Assessment',
  icon: Icons.play_arrow,
  onPressed: () => print('Button pressed'),
  gradientColors: [Color(0xFF2E7D9A), Color(0xFF4A90A4)],
  height: 50,
  isLoading: false,
)
```

### 7. Achievement Badge

```dart
AchievementBadge(
  title: 'First Steps',
  icon: Icons.flag,
  color: Color(0xFF2A9D8F),
  isUnlocked: true,
  onTap: () => print('Badge tapped'),
)
```

---

## Navigation Examples

### Navigate to new screens

```dart
// Profile Screen
Navigator.pushNamed(context, '/profile');

// Settings Screen
Navigator.pushNamed(context, '/settings');

// AI Insights
Navigator.pushNamed(context, '/ai-insights');

// Notification Center
Navigator.pushNamed(context, '/notifications');

// New Assessment Modules
Navigator.pushNamed(context, '/reaction-time-module');
Navigator.pushNamed(context, '/memory-matrix-module');
```

---

## Complete Integration Example

```dart
import 'package:flutter/material.dart';
import 'package:cognidetect/services/app_state_manager.dart';
import 'package:cognidetect/services/analytics_service.dart';
import 'package:cognidetect/services/notification_service.dart';
import 'package:cognidetect/widgets/advanced_ui_components.dart';
import 'package:cognidetect/widgets/advanced_charts.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _stateManager = AppStateManager();
  final _analytics = AnalyticsService();
  final _notifications = NotificationService();

  @override
  void initState() {
    super.initState();
    _analytics.trackScreenView('dashboard');
    _initializeData();
  }

  void _initializeData() {
    // Set user profile
    _stateManager.setUserProfile(
      userId: 'user123',
      userName: 'John Doe',
      userEmail: 'john@example.com',
    );

    // Show welcome notification
    _notifications.showSuccess(
      'Welcome back, ${_stateManager.userName}!',
    );
  }

  void _startAssessment() {
    _analytics.trackInteraction('button_tap', 'start_assessment');
    Navigator.pushNamed(context, '/reaction-time-module');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              StatCard(
                title: 'Score',
                value: '${_stateManager.getAverageCognitiveScore().toInt()}',
                icon: Icons.stars,
                color: Color(0xFF2E7D9A),
              ),
              StatCard(
                title: 'Streak',
                value: '${_stateManager.loginStreak}',
                icon: Icons.local_fire_department,
                color: Color(0xFFE76F51),
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          // Performance Chart
          Container(
            height: 250,
            child: CognitiveRadarChart(
              scores: _stateManager.cognitiveScores,
            ),
          ),
          
          SizedBox(height: 24),
          
          // Action Button
          GradientButton(
            text: 'Start Assessment',
            icon: Icons.play_arrow,
            onPressed: _startAssessment,
          ),
        ],
      ),
    );
  }
}
```

---

## Tips & Best Practices

### 1. **State Management**
- Always use singleton instances
- Listen to streams for reactive updates
- Dispose controllers in dispose()
- Use const constructors where possible

### 2. **Analytics**
- Track all major user actions
- Include relevant parameters
- Export data periodically
- Monitor error rates

### 3. **Notifications**
- Use appropriate types
- Set auto-hide durations
- Don't spam users
- Provide actionable notifications

### 4. **Performance**
- Initialize services once
- Use lazy loading
- Optimize widget rebuilds
- Profile regularly

### 5. **UI/UX**
- Use consistent colors
- Follow design system
- Add loading states
- Handle errors gracefully

---

## Troubleshooting

### Services not initialized
```dart
// Always initialize storage before use
await LocalStorageService().initialize();
```

### State not updating
```dart
// Make sure to call notifyListeners()
stateManager.updateCognitiveScore('memory', 85.0);
// Updates automatically trigger notifyListeners()
```

### Charts not showing
```dart
// Ensure data is not empty
if (scores.values.any((v) => v > 0)) {
  CognitiveRadarChart(scores: scores)
}
```

---

**Happy Coding! 🎉**
