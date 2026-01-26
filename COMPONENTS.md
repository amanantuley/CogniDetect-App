# 🎨 Component Catalog - Visual Reference Guide

## 📱 Complete Component Library

---

## 🎬 Animations

### 1. AnimatedGradientCard
**Purpose**: Beautiful gradient cards with optional shimmer effect  
**Location**: `lib/widgets/advanced_animations.dart`

```dart
AnimatedGradientCard(
  gradientColors: [Color(0xFF2E7D9A), Color(0xFF4A90A4)],
  height: 200,
  width: double.infinity,
  enableShimmer: true,
  borderRadius: BorderRadius.circular(16),
  onTap: () => print('Tapped'),
  child: Center(child: Text('Content')),
)
```

**Features**:
- Gradient background
- Shimmer animation
- Customizable colors
- Tap handling
- Shadow effects

---

### 2. AnimatedProgressRing
**Purpose**: Circular progress indicator with smooth animation  
**Location**: `lib/widgets/advanced_animations.dart`

```dart
AnimatedProgressRing(
  progress: 0.75, // 0.0 to 1.0
  size: 120,
  strokeWidth: 12,
  progressColor: Color(0xFF2E7D9A),
  backgroundColor: Colors.grey,
  showPercentage: true,
  animationDuration: Duration(milliseconds: 1500),
)
```

**Features**:
- Smooth animations
- Percentage display
- Customizable colors
- Adjustable size
- Auto-updates on change

---

### 3. PulseAnimation
**Purpose**: Pulsing scale animation for attention  
**Location**: `lib/widgets/advanced_animations.dart`

```dart
PulseAnimation(
  minScale: 0.95,
  maxScale: 1.05,
  duration: Duration(milliseconds: 1000),
  repeat: true,
  child: Icon(Icons.favorite, size: 48, color: Colors.red),
)
```

**Features**:
- Smooth pulsing
- Configurable scale
- Repeat mode
- Any widget support

---

### 4. ShimmerLoading
**Purpose**: Loading skeleton with shimmer effect  
**Location**: `lib/widgets/advanced_animations.dart`

```dart
ShimmerLoading(
  duration: Duration(milliseconds: 1500),
  baseColor: Color(0xFFE0E0E0),
  highlightColor: Color(0xFFF5F5F5),
  child: Container(
    width: double.infinity,
    height: 100,
    color: Colors.white,
  ),
)
```

**Features**:
- Shimmer effect
- Customizable colors
- Loading states
- Any widget support

---

## 📊 Charts & Visualizations

### 1. CognitiveRadarChart
**Purpose**: Multi-dimensional cognitive score visualization  
**Location**: `lib/widgets/advanced_charts.dart`

```dart
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
  maxValue: 100,
)
```

**Use Cases**:
- Cognitive assessments
- Multi-dimensional data
- Performance overviews
- Comparison displays

---

### 2. ProgressLineChart
**Purpose**: Historical progress tracking over time  
**Location**: `lib/widgets/advanced_charts.dart`

```dart
ProgressLineChart(
  dataPoints: [
    FlSpot(0, 65),
    FlSpot(1, 70),
    FlSpot(2, 75),
    FlSpot(3, 80),
    FlSpot(4, 85),
  ],
  title: 'Memory Score Progress',
  lineColor: Color(0xFF2E7D9A),
  showDots: true,
  showGrid: true,
)
```

**Use Cases**:
- Progress tracking
- Trend visualization
- Historical data
- Performance monitoring

---

### 3. ComparativeBarChart
**Purpose**: Domain-by-domain comparison  
**Location**: `lib/widgets/advanced_charts.dart`

```dart
ComparativeBarChart(
  data: {
    'memory': 85.0,
    'attention': 78.0,
    'language': 88.0,
  },
  title: 'Cognitive Domain Scores',
  barColor: Color(0xFF4A90A4),
  maxY: 100,
)
```

**Use Cases**:
- Score comparison
- Domain analysis
- Performance gaps
- Strength identification

---

### 4. ScoreDonutChart
**Purpose**: Score distribution visualization  
**Location**: `lib/widgets/advanced_charts.dart`

```dart
ScoreDonutChart(
  scores: {
    'excellent': 25.0,
    'good': 35.0,
    'average': 30.0,
    'needs_work': 10.0,
  },
  colors: [
    Color(0xFF2A9D8F),
    Color(0xFF4A90A4),
    Color(0xFFE9C46A),
    Color(0xFFE76F51),
  ],
  showLegend: true,
)
```

**Use Cases**:
- Distribution display
- Category breakdown
- Percentage visualization
- Summary views

---

## 🎨 UI Components

### 1. StatCard
**Purpose**: Display statistics with trend indicators  
**Location**: `lib/widgets/advanced_ui_components.dart`

```dart
StatCard(
  title: 'Total Assessments',
  value: '24',
  icon: Icons.assignment_turned_in,
  color: Color(0xFF2E7D9A),
  subtitle: 'This month',
  trend: 15.5, // +15.5%
  onTap: () => print('Card tapped'),
)
```

**Features**:
- Icon display
- Trend arrows
- Color customization
- Tap handling
- Subtitle support

---

### 2. AchievementBadge
**Purpose**: Gamification badges for milestones  
**Location**: `lib/widgets/advanced_ui_components.dart`

```dart
AchievementBadge(
  title: 'First Steps',
  icon: Icons.flag,
  color: Color(0xFF2A9D8F),
  isUnlocked: true,
  description: 'Complete your first assessment',
  onTap: () => showDetails(),
)
```

**Features**:
- Locked/unlocked states
- Glow effects when unlocked
- Tap handling
- Icon customization

---

### 3. InfoTile
**Purpose**: Settings and profile list items  
**Location**: `lib/widgets/advanced_ui_components.dart`

```dart
InfoTile(
  icon: Icons.dark_mode,
  title: 'Dark Mode',
  subtitle: 'Switch to dark theme',
  iconColor: Color(0xFF2E7D9A),
  trailing: Switch(value: true, onChanged: (v) {}),
  onTap: () => toggleDarkMode(),
)
```

**Features**:
- Leading icon
- Title/subtitle
- Custom trailing widget
- Tap handling
- Consistent styling

---

### 4. GradientButton
**Purpose**: Call-to-action buttons with gradient  
**Location**: `lib/widgets/advanced_ui_components.dart`

```dart
GradientButton(
  text: 'Start Assessment',
  icon: Icons.play_arrow,
  onPressed: () => startTest(),
  gradientColors: [Color(0xFF2E7D9A), Color(0xFF4A90A4)],
  width: double.infinity,
  height: 50,
  isLoading: false,
)
```

**Features**:
- Gradient background
- Optional icon
- Loading state
- Shadow effects
- Customizable size

---

### 5. SectionHeader
**Purpose**: Consistent section headers  
**Location**: `lib/widgets/advanced_ui_components.dart`

```dart
SectionHeader(
  title: 'Statistics',
  subtitle: 'Your performance overview',
  action: TextButton(
    onPressed: () => viewAll(),
    child: Text('View All'),
  ),
)
```

**Features**:
- Title/subtitle
- Optional action widget
- Consistent styling
- Responsive padding

---

## 🖼️ Screen Templates

### 1. Profile Screen
**Purpose**: User statistics and performance  
**Location**: `lib/presentation/profile_screen/`

**Components Used**:
- Gradient header card
- StatCard grid
- CognitiveRadarChart
- Score breakdown bars
- AchievementBadge list

**Sections**:
1. Profile header (avatar, name, stats)
2. Cognitive performance radar
3. Score breakdown with bars
4. Statistics grid
5. Achievements carousel

---

### 2. Settings Screen
**Purpose**: App configuration and preferences  
**Location**: `lib/presentation/settings_screen/`

**Components Used**:
- SectionHeader
- InfoTile with switches
- InfoTile with navigation

**Sections**:
1. Preferences (dark mode, notifications, sound)
2. Data & Privacy (export, clear, storage)
3. About (version, terms, privacy, help)

---

### 3. AI Insights Screen
**Purpose**: AI-powered analysis and recommendations  
**Location**: `lib/presentation/ai_insights_screen/`

**Components Used**:
- Gradient performance card
- SectionHeader
- Insight cards
- Chip components
- Training plan cards
- GradientButton

**Sections**:
1. Overall performance score
2. Key insights
3. Strengths
4. Focus areas
5. Recommendations
6. Training plan

---

### 4. Notification Center
**Purpose**: Notification management  
**Location**: `lib/presentation/notification_center/`

**Components Used**:
- Dismissible list items
- Notification tiles
- Empty state

**Features**:
- Swipe to delete
- Mark as read/unread
- Notification types
- Timestamp formatting

---

## 🧪 Assessment Modules

### 1. Reaction Time Module
**Purpose**: Processing speed assessment  
**Location**: `lib/presentation/reaction_time_module/`

**Features**:
- 10-round test
- Random delays
- Real-time feedback
- Too-early detection
- Score calculation
- Results tracking

**UI States**:
- Start screen
- Waiting (blue background)
- Target shown (green background)
- Too early (red background)
- Results display

---

### 2. Memory Matrix Module
**Purpose**: Visual memory testing  
**Location**: `lib/presentation/memory_matrix_module/`

**Features**:
- Progressive difficulty
- Grid-based recall
- Lives system
- Score multipliers
- Dynamic grid size
- Level progression

**UI States**:
- Memorization phase
- Recall phase
- Feedback display
- Level complete

---

## 🔧 Service APIs

### AppStateManager
```dart
// Initialize user
stateManager.setUserProfile(
  userId: 'user123',
  userName: 'John',
  userEmail: 'john@example.com',
);

// Update scores
stateManager.updateCognitiveScore('memory', 85.0);
stateManager.updateMultipleCognitiveScores({
  'memory': 85.0,
  'attention': 78.0,
});

// Listen to changes
stateManager.scoresStream.listen((scores) {
  print('Scores updated: $scores');
});
```

---

### AnalyticsService
```dart
// Track events
analytics.trackScreenView('home');
analytics.trackEvent('button_tap', parameters: {'id': 'start'});

// Track assessments
analytics.trackAssessmentStart('memory_test', 'Memory Test');
analytics.trackAssessmentComplete(
  'memory_test',
  'Memory Test',
  duration: Duration(minutes: 5),
  score: 85.0,
);

// Get analytics
final summary = analytics.getAssessmentAnalytics();
```

---

### NotificationService
```dart
// Show notifications
notifications.showSuccess('Assessment complete!');
notifications.showError('Failed to save');
notifications.showWarning('Low battery');
notifications.showInfo('New feature');

// Schedule reminders
notifications.scheduleReminder(
  title: 'Daily Test',
  message: 'Complete your assessment',
  scheduledTime: DateTime.now().add(Duration(days: 1)),
);
```

---

### AIAnalysisService
```dart
// Analyze patterns
final analysis = aiService.analyzeCognitivePatterns(scores);
print(analysis['performance_level']);
print(analysis['insights']);

// Generate training plan
final plan = aiService.generateTrainingPlan(scores);
for (final item in plan) {
  print('${item['domain']}: ${item['exercises']}');
}
```

---

## 🎨 Color System

### Primary Colors
- **Primary**: `Color(0xFF2E7D9A)` - Therapeutic Blue
- **Primary Variant**: `Color(0xFF4A90A4)` - Supporting Blue
- **Secondary**: `Color(0xFF4A90A4)` - Navigation Blue

### Semantic Colors
- **Success**: `Color(0xFF2A9D8F)` - Calming Teal
- **Warning**: `Color(0xFFE9C46A)` - Gentle Yellow
- **Error**: `Color(0xFFE76F51)` - Supportive Red-Orange
- **Accent**: `Color(0xFFF4A261)` - Warm Orange

### Neutral Colors
- **Background**: `Color(0xFFFAFBFC)` - Soft Off-White
- **Surface**: `Color(0xFFFFFFFF)` - Pure White
- **Text Primary**: `Color(0xFF1A1A1A)` - Near Black
- **Text Secondary**: `Color(0xFF6B7280)` - Medium Gray

---

## 📐 Spacing System

Using Sizer package for responsive design:
- `1.w` = 1% of screen width
- `1.h` = 1% of screen height
- `4.w` = Standard horizontal padding
- `2.h` = Standard vertical spacing

---

## 🎯 Usage Patterns

### Dashboard Layout
```dart
ListView(
  padding: EdgeInsets.all(4.w),
  children: [
    SectionHeader(title: 'Statistics'),
    SizedBox(height: 2.h),
    GridView.count(...), // StatCards
    SizedBox(height: 3.h),
    SectionHeader(title: 'Performance'),
    SizedBox(height: 2.h),
    Container(
      height: 250,
      child: CognitiveRadarChart(...),
    ),
  ],
)
```

### Settings Layout
```dart
ListView(
  children: [
    SectionHeader(title: 'Preferences'),
    InfoTile(...),
    InfoTile(...),
    Divider(),
    SectionHeader(title: 'Data'),
    InfoTile(...),
  ],
)
```

---

**Component Count**: 30+  
**Design System**: Clinical Minimalism  
**Status**: Production Ready ✅
