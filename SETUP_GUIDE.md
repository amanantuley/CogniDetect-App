# 🚀 CogniDetect - Setup & Installation Guide

## ✅ Pre-Installation Checklist

Before you start, ensure you have:
- [ ] Flutter 3.0 or higher installed
- [ ] Dart 3.0 or higher installed
- [ ] Android SDK (API 21+) or Xcode installed
- [ ] At least 2GB free disk space
- [ ] Internet connection for downloads
- [ ] Git (optional, for version control)

---

## 📋 Step-by-Step Installation

### Step 1: Verify Flutter Installation
```bash
# Check Flutter version
flutter --version

# Check Dart version
dart --version

# Verify SDK setup
flutter doctor
```

Expected output: All items should show checkmarks (✓)

### Step 2: Navigate to Project
```bash
cd "c:\Users\Hp\OneDrive\Desktop\PerfectFit\CogniDetect-App"
```

### Step 3: Get Dependencies
```bash
# Update Flutter packages
flutter pub get

# Upgrade packages if needed
flutter pub upgrade
```

### Step 4: Verify Project Structure
Check that these folders exist:
- `lib/` - Source code
- `android/` - Android build files
- `ios/` - iOS build files
- `web/` - Web build files
- `pubspec.yaml` - Dependencies file

### Step 5: Build Verification
```bash
# Analyze code for errors
flutter analyze

# Run format check
dart format lib/ --set-exit-if-changed
```

Expected: No errors or warnings

### Step 6: Run on Device/Emulator
```bash
# List available devices
flutter devices

# Run in debug mode
flutter run

# Run in release mode
flutter run --release
```

---

## 🎯 First Launch Checklist

When you first run the app:

1. **Splash Screen** - You should see the app loading
2. **Login Screen** - Google Login or authentication
3. **Home Dashboard** - Main dashboard with statistics
4. **Navigation** - Can navigate to all screens
5. **Assessments** - Can start assessment modules
6. **Profile** - Can view user profile
7. **Settings** - Can access settings
8. **Notifications** - Can see notification center

---

## 🔧 Configuration & Setup

### Config File Location
`lib/config/app_config.dart`

### Key Configuration Options
```dart
// App name
static const String appName = 'CogniDetect';

// Version
static const String appVersion = '1.0.0';

// Route paths
class RoutePaths {
  static const String home = '/home';
  static const String profile = '/profile';
  // ... more routes
}

// Score thresholds
static const Map<String, Map<String, int>> scoreThresholds = {
  'excellent': {'min': 80, 'max': 100},
  'good': {'min': 70, 'max': 79},
  // ... more thresholds
};
```

### Modifying Configuration
Edit `lib/config/app_config.dart` to:
- Change app name or version
- Adjust score thresholds
- Update route paths
- Modify API endpoints
- Change error messages

---

## 📱 Running on Specific Devices

### Android Emulator
```bash
# Start Android emulator first
# Then run:
flutter run -d emulator-5554
```

### Physical Android Device
```bash
# Enable USB debugging on device
# Connect device via USB
# Then run:
flutter run -d <device_id>

# Find device ID:
flutter devices
```

### iOS Simulator
```bash
# Start iOS simulator first:
open -a Simulator

# Then run:
flutter run -d iPhone
```

### Physical iOS Device
```bash
# First time setup:
# 1. Open ios/Runner.xcworkspace in Xcode
# 2. Select your device
# 3. Set up signing (Apple Developer account)
# 4. Run from Xcode

# Or from command line:
flutter run -d <device_id>
```

### Web Browser
```bash
# Run on web (requires web platform enabled)
flutter run -d chrome
flutter run -d safari  # on macOS
```

---

## 🛠️ Build Types

### Debug Build
```bash
# For testing and development
flutter build apk
flutter build ios

# Fast, includes debug info, unoptimized
```

### Release Build
```bash
# For production deployment
flutter build apk --release
flutter build ios --release

# Optimized, smaller size, no debug info
```

### Build Output Locations
- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **iOS**: `build/ios/iphoneos/Runner.app`
- **Bundle**: `build/app/outputs/bundle/release/app-release.aab`

---

## 🐛 Troubleshooting

### Issue: "Flutter command not found"
**Solution**: Add Flutter to PATH
```bash
# Linux/Mac
export PATH="$PATH:/path/to/flutter/bin"

# Windows: Add Flutter/bin to System Environment Variables
```

### Issue: "CocoaPods dependency error"
**Solution**: Update iOS dependencies
```bash
cd ios
pod repo update
pod install
cd ..
```

### Issue: "Build failed - Gradle error"
**Solution**: Clean and rebuild
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "Package not found"
**Solution**: Get all dependencies
```bash
flutter pub get
flutter pub upgrade
```

### Issue: "Memory error during build"
**Solution**: Increase memory allocation
```bash
# For Android builds, edit android/app/build.gradle:
# increase heap size in android {} block
```

### Issue: "Device not recognized"
**Solution**: Check device connection
```bash
flutter devices
adb devices  # for Android
```

### Issue: "Plugin not found error"
**Solution**: Rebuild plugins
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "Hot reload not working"
**Solution**: Try hot restart
```bash
# In Flutter terminal, press 'r' for hot reload
# Or press 'R' for hot restart
# Or Ctrl+C and run flutter run again
```

---

## 📦 Dependency Management

### View All Dependencies
```bash
flutter pub deps
```

### Update Single Package
```bash
flutter pub upgrade package_name
```

### Update All Packages
```bash
flutter pub upgrade
```

### Check for Outdated Packages
```bash
flutter pub outdated
```

### Add New Package
```bash
flutter pub add package_name
```

### Remove Package
```bash
flutter pub remove package_name
```

---

## 🔍 Development Tools

### Dart DevTools
```bash
# Start DevTools
dart devtools

# Or run from Flutter:
flutter pub global activate devtools
devtools
```

### Code Analysis
```bash
# Check for issues
flutter analyze

# Auto-fix issues
dart fix --apply
```

### Code Formatting
```bash
# Format code
dart format lib/

# Check formatting
dart format lib/ --set-exit-if-changed
```

### Widget Inspector
```bash
# Enable during flutter run:
# Press 'w' in terminal to open widget inspector
# Or click the icon in IDE
```

---

## 📊 Performance Testing

### Check Frame Rate
```bash
# During flutter run, press 'p' to toggle performance overlay
# Shows frame rendering time
```

### Memory Usage
```bash
# Enable memory profiling in DevTools
# Navigate to Memory tab
# Monitor allocation and garbage collection
```

### Build Speed
```bash
# Measure build time
time flutter build apk

# Generate build graph
flutter analyze --report-on=unused-files
```

---

## 🔐 Security Setup

### Generate Release Keystore (Android)
```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

### Configure Signing
Edit `android/app/build.gradle`:
```gradle
android {
  signingConfigs {
    release {
      keyAlias 'key'
      keyPassword 'your_password'
      storeFile file('/path/to/key.jks')
      storePassword 'your_password'
    }
  }
  
  buildTypes {
    release {
      signingConfig signingConfigs.release
    }
  }
}
```

### iOS Code Signing
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select project → Runner
3. Select "Signing & Capabilities"
4. Select your team
5. Add development certificate

---

## 📱 Device-Specific Setup

### For Android
1. Enable USB Debugging: Settings → Developer Options
2. Connect device
3. Grant USB access permission on device
4. Run `flutter devices` to verify
5. Run `flutter run`

### For iOS
1. Open Xcode
2. Install Xcode Command Line Tools
3. Run `xcode-select --install`
4. Open project in Xcode
5. Configure signing
6. Run from Xcode or command line

### For macOS (Apple Silicon)
```bash
# Ensure Flutter targets ARM64
flutter config --enable-macos

# Run with explicit architecture
flutter run
```

---

## 🌐 Environment Variables

### Create `.env` File (if needed)
```
FLAVOR=development
API_BASE_URL=https://api.example.com
LOG_LEVEL=debug
```

### Use in Code
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiUrl = dotenv.env['API_BASE_URL'] ?? '';
```

---

## 🚀 Running Tests

### Unit Tests
```bash
flutter test test/unit/

# Run specific test
flutter test test/unit/service_test.dart
```

### Integration Tests
```bash
flutter test integration_test/

# Run on specific device
flutter test -d <device_id> integration_test/
```

### Coverage Report
```bash
# Install coverage tool
dart pub global activate coverage

# Generate coverage
dart pub global run coverage:format_coverage -i coverage -o coverage/coverage.json
```

---

## 📈 Monitoring & Analytics

### Enable Crash Reporting (Optional)
```dart
// In main.dart
FlutterError.onError = (FlutterErrorDetails details) {
  // Send to crash reporting service
};

Future.delayed(Duration.zero, () {
  runZonedGuarded(
    () => runApp(MyApp()),
    (error, stack) {
      // Handle errors
    },
  );
});
```

### Local Logging
```dart
// All logs are captured in AppLogger
final logs = AppLogger.getLogs();
final logsText = AppLogger.exportLogs();
```

---

## 📋 Post-Installation Checklist

- [ ] All dependencies installed
- [ ] No errors in `flutter analyze`
- [ ] App runs without errors
- [ ] Home screen displays correctly
- [ ] Can navigate to all screens
- [ ] Can start assessment modules
- [ ] Can view profile and settings
- [ ] Notifications display properly
- [ ] Data persists after app restart
- [ ] No console warnings

---

## 🎓 Learning Path

1. **Understand Structure** - Read COMPLETE_FEATURES.md
2. **Learn Services** - Review lib/services/ files
3. **Understand Routes** - Check lib/routes/app_routes.dart
4. **Explore Widgets** - Review lib/widgets/ components
5. **Review Screens** - Study lib/presentation/ files
6. **Check Utilities** - Review lib/utils/ services

---

## 📞 Getting Help

### Common Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/docs)
- [StackOverflow Flutter Tag](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)

### Project Documentation
- COMPLETE_FEATURES.md - All features documented
- INTEGRATION_GUIDE.md - Implementation examples
- Code comments - Inline documentation

---

## ✅ Installation Complete!

You're all set! The CogniDetect app is ready to run.

**Next Steps:**
1. Run `flutter run`
2. Explore the app
3. Review the documentation
4. Start development or deployment

**Issues?** Check the troubleshooting section above.

---

**Version**: 1.0.0  
**Last Updated**: 2024  
**Status**: ✅ Ready to Use
