import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../services/app_state_manager.dart';
import '../../services/analytics_service.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/advanced_ui_components.dart';

/// Advanced Settings Screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _stateManager = AppStateManager();
  final _analytics = AnalyticsService();
  final _storage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _analytics.trackScreenView('settings_screen');
  }

  Future<void> _exportData() async {
    final analyticsData = _analytics.exportEventsAsJson();
    final stateData = _stateManager.getAnalyticsSummary();
    
    // In a real app, you'd export this to a file or cloud storage
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Text('Would export ${analyticsData.length} events and user data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your assessment data, progress, and settings. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storage.clearAll();
      _stateManager.resetAllData();
      _analytics.clearEvents();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data cleared successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          SectionHeader(title: 'Preferences'),
          InfoTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            trailing: Switch(
              value: _stateManager.darkMode,
              onChanged: (value) {
                setState(() => _stateManager.setDarkMode(value));
                _analytics.trackInteraction('toggle', 'dark_mode', value: value);
              },
            ),
          ),
          InfoTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Enable assessment reminders',
            trailing: Switch(
              value: _stateManager.notificationsEnabled,
              onChanged: (value) {
                setState(() => _stateManager.toggleNotifications());
                _analytics.trackInteraction('toggle', 'notifications', value: value);
              },
            ),
          ),
          InfoTile(
            icon: Icons.volume_up,
            title: 'Sound Effects',
            subtitle: 'Enable audio feedback',
            trailing: Switch(
              value: _stateManager.soundEnabled,
              onChanged: (value) {
                setState(() => _stateManager.toggleSound());
                _analytics.trackInteraction('toggle', 'sound', value: value);
              },
            ),
          ),
          InfoTile(
            icon: Icons.save,
            title: 'Auto-Save Results',
            subtitle: 'Automatically save assessment results',
            trailing: Switch(
              value: _stateManager.autoSaveResults,
              onChanged: (value) {
                setState(() => _stateManager.toggleAutoSave());
                _analytics.trackInteraction('toggle', 'auto_save', value: value);
              },
            ),
          ),
          const Divider(height: 32),
          SectionHeader(title: 'Data & Privacy'),
          InfoTile(
            icon: Icons.file_download,
            title: 'Export Data',
            subtitle: 'Download your assessment data',
            onTap: _exportData,
          ),
          InfoTile(
            icon: Icons.delete_forever,
            title: 'Clear All Data',
            subtitle: 'Permanently delete all data',
            iconColor: Colors.red,
            onTap: _clearAllData,
          ),
          InfoTile(
            icon: Icons.storage,
            title: 'Storage Usage',
            subtitle: 'View storage information',
            onTap: () async {
              final size = await _storage.getStorageSize();
              final sizeInKB = (size / 1024).toStringAsFixed(2);
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Storage Usage'),
                    content: Text('Current usage: $sizeInKB KB'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          const Divider(height: 32),
          SectionHeader(title: 'About'),
          InfoTile(
            icon: Icons.info,
            title: 'App Version',
            subtitle: '1.0.0',
          ),
          InfoTile(
            icon: Icons.description,
            title: 'Terms of Service',
            onTap: () {
              // Navigate to terms
            },
          ),
          InfoTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          InfoTile(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              // Navigate to help
            },
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
