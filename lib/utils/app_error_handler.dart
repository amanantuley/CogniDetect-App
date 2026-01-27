import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Centralized Error Handler for the Application
class AppErrorHandler {
  static final AppErrorHandler _instance = AppErrorHandler._internal();

  factory AppErrorHandler() {
    return _instance;
  }

  AppErrorHandler._internal();

  /// Handle exceptions with user-friendly messaging
  static void handleException(
    dynamic error, {
    required String context,
    Function? onRetry,
    bool showNotification = true,
  }) {
    debugPrint('❌ [ERROR in $context]: $error');

    final message = _getErrorMessage(error);
    if (showNotification) {
      _showErrorDialog(context, message, onRetry);
    }
  }

  /// Get user-friendly error message
  static String _getErrorMessage(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('SocketException') ||
        errorString.contains('HandshakeException')) {
      return ErrorMessages.networkError;
    }

    if (errorString.contains('TimeoutException')) {
      return ErrorMessages.timeoutError;
    }

    if (errorString.contains('FileSystemException')) {
      return ErrorMessages.storageError;
    }

    if (errorString.contains('FormatException')) {
      return ErrorMessages.dataFormatError;
    }

    return ErrorMessages.unknownError;
  }

  /// Show error dialog with retry option
  static void _showErrorDialog(
    String context,
    String message,
    Function? onRetry,
  ) {
    // This would typically show a dialog in the app
    // For now, we log it
    debugPrint('⚠️ Error Dialog: $message');
  }

  /// Safe async operation wrapper
  static Future<T?> safeAsync<T>(
    Future<T> Function() operation, {
    required String context,
    T? defaultValue,
  }) async {
    try {
      return await operation();
    } catch (e) {
      handleException(e, context: context);
      return defaultValue;
    }
  }

  /// Validate required fields
  static bool validateRequired(
    List<String> fields, {
    required String context,
  }) {
    for (final field in fields) {
      if (field.isEmpty) {
        handleException(
          'Required field is empty',
          context: context,
          showNotification: true,
        );
        return false;
      }
    }
    return true;
  }

  /// Log success message
  static void logSuccess(String message, [String? context]) {
    debugPrint('✅ ${context != null ? '[$context] ' : ''}$message');
  }

  /// Log info message
  static void logInfo(String message, [String? context]) {
    debugPrint('ℹ️ ${context != null ? '[$context] ' : ''}$message');
  }

  /// Log warning message
  static void logWarning(String message, [String? context]) {
    debugPrint('⚠️ ${context != null ? '[$context] ' : ''}$message');
  }
}

/// Error Messages Repository
class ErrorMessages {
  static const String networkError =
      'Network connection failed. Please check your internet.';
  static const String timeoutError = 'Request timed out. Please try again.';
  static const String storageError =
      'Storage error occurred. Please check app permissions.';
  static const String dataFormatError = 'Data format error. Please try again.';
  static const String unknownError =
      'An unexpected error occurred. Please try again.';
  static const String assessmentLoadError =
      'Failed to load assessment. Please try again.';
  static const String assessmentSaveError =
      'Failed to save assessment results.';
  static const String userDataLoadError = 'Failed to load user data.';
  static const String analyticsError = 'Analytics tracking failed.';
  static const String notificationError = 'Failed to send notification.';
  static const String storagePermissionError = 'Storage permission denied.';
  static const String microphonePermissionError =
      'Microphone permission denied.';
  static const String cameraPermissionError = 'Camera permission denied.';
}

/// Success Messages Repository
class SuccessMessages {
  static const String assessmentCompleted =
      'Assessment completed successfully!';
  static const String dataSaved = 'Data saved successfully.';
  static const String settingsUpdated = 'Settings updated successfully.';
  static const String profileUpdated = 'Profile updated successfully.';
  static const String notificationSent = 'Notification sent successfully.';
  static const String dataExported = 'Data exported successfully.';
}

/// App Logger for comprehensive logging
class AppLogger {
  static final List<LogEntry> _logs = [];
  static const int maxLogs = 1000;

  static void log(
    String message, {
    required String level,
    String? context,
    dynamic error,
  }) {
    final timestamp = DateTime.now();
    final entry = LogEntry(
      timestamp: timestamp,
      level: level,
      message: message,
      context: context,
      error: error,
    );

    _logs.add(entry);

    // Keep only latest logs
    if (_logs.length > maxLogs) {
      _logs.removeAt(0);
    }

    // Print to console
    _printLog(entry);
  }

  static void _printLog(LogEntry entry) {
    final prefix = _getLevelPrefix(entry.level);
    final contextStr = entry.context != null ? '[${entry.context}] ' : '';
    final errorStr = entry.error != null ? '\n  Error: ${entry.error}' : '';

    debugPrint(
      '$prefix ${entry.timestamp.hour}:${entry.timestamp.minute}:${entry.timestamp.second} '
      '$contextStr${entry.message}$errorStr',
    );
  }

  static String _getLevelPrefix(String level) {
    switch (level) {
      case 'INFO':
        return 'ℹ️';
      case 'SUCCESS':
        return '✅';
      case 'WARNING':
        return '⚠️';
      case 'ERROR':
        return '❌';
      case 'DEBUG':
        return '🐛';
      default:
        return '📝';
    }
  }

  static void info(String message, [String? context]) {
    log(message, level: 'INFO', context: context);
  }

  static void success(String message, [String? context]) {
    log(message, level: 'SUCCESS', context: context);
  }

  static void warning(String message, [String? context]) {
    log(message, level: 'WARNING', context: context);
  }

  static void error(String message, [String? context, dynamic error]) {
    log(message, level: 'ERROR', context: context, error: error);
  }

  static void debug(String message, [String? context]) {
    log(message, level: 'DEBUG', context: context);
  }

  static List<LogEntry> getLogs() => List.unmodifiable(_logs);

  static List<LogEntry> getLogsForContext(String context) {
    return _logs.where((log) => log.context == context).toList();
  }

  static void clearLogs() {
    _logs.clear();
  }

  static String exportLogs() {
    return _logs.map((log) => log.toString()).join('\n');
  }
}

/// Log Entry Model
class LogEntry {
  final DateTime timestamp;
  final String level;
  final String message;
  final String? context;
  final dynamic error;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.context,
    this.error,
  });

  @override
  String toString() {
    return '[${timestamp.toIso8601String()}] [$level] ${context ?? ''} $message'
        '${error != null ? '\nError: $error' : ''}';
  }
}

/// Validation Helper
class ValidationHelper {
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^[+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$')
        .hasMatch(phone);
  }

  static bool isStrongPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Email is required';
    }
    if (!isValidEmail(value!)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Password is required';
    }
    if (value!.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!isStrongPassword(value)) {
      return 'Password must contain uppercase, lowercase, and numbers';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Phone number is required';
    }
    if (!isValidPhoneNumber(value!)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateNotEmpty(String? value, {String? fieldName}) {
    if (value?.isEmpty ?? true) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength,
      {String? fieldName}) {
    if (value?.isEmpty ?? true) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (value!.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }
}

/// Snackbar Helper for showing messages
class SnackbarHelper {
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.green);
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.red);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.orange);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.blue);
  }

  static void _showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
