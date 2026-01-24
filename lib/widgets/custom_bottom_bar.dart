import 'package:flutter/material.dart';

/// Custom Bottom Navigation Bar for CogniDetect
/// Implements Bottom-Heavy Interaction Design with persistent access to core sections
/// Follows Clinical Minimalism design style with Therapeutic Blue Foundation
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor:
              theme.bottomNavigationBarTheme.unselectedItemColor,
          selectedLabelStyle: theme.bottomNavigationBarTheme.selectedLabelStyle,
          unselectedLabelStyle:
              theme.bottomNavigationBarTheme.unselectedLabelStyle,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            // Dashboard/Home - Main module selection hub
            BottomNavigationBarItem(
              icon: _buildIcon(
                icon: Icons.dashboard_outlined,
                isSelected: currentIndex == 0,
                theme: theme,
              ),
              activeIcon: _buildIcon(
                icon: Icons.dashboard,
                isSelected: true,
                theme: theme,
              ),
              label: 'Dashboard',
              tooltip: 'Main module selection hub',
            ),

            // History - Assessment timeline and results
            BottomNavigationBarItem(
              icon: _buildIcon(
                icon: Icons.history_outlined,
                isSelected: currentIndex == 1,
                theme: theme,
              ),
              activeIcon: _buildIcon(
                icon: Icons.history,
                isSelected: true,
                theme: theme,
              ),
              label: 'History',
              tooltip: 'Assessment timeline and results',
            ),

            // Settings - Profile and preferences
            BottomNavigationBarItem(
              icon: _buildIcon(
                icon: Icons.settings_outlined,
                isSelected: currentIndex == 2,
                theme: theme,
              ),
              activeIcon: _buildIcon(
                icon: Icons.settings,
                isSelected: true,
                theme: theme,
              ),
              label: 'Settings',
              tooltip: 'Profile and preferences',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds navigation icon with proper sizing and touch target
  /// Minimum 60pt touch target per Touch Architecture requirements
  Widget _buildIcon({
    required IconData icon,
    required bool isSelected,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        icon,
        size: 24,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.bottomNavigationBarTheme.unselectedItemColor,
      ),
    );
  }
}
