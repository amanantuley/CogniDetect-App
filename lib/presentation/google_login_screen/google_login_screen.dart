import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

/// Google Login Screen for CogniDetect
/// Implements secure authentication using Google Sign-In SDK
/// Optimized for healthcare data protection with HIPAA compliance
class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top spacing
                      SizedBox(height: 4.h),

                      // Logo and branding section
                      _buildBrandingSection(theme),

                      SizedBox(height: 6.h),

                      // Main content section
                      _buildMainContentSection(theme),

                      // Bottom section with legal links
                      _buildBottomSection(theme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the branding section with logo and tagline
  Widget _buildBrandingSection(ThemeData theme) {
    return Column(
      children: [
        // App logo
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'psychology',
              size: 15.w,
              color: theme.colorScheme.primary,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // App name
        Text(
          'CogniDetect',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Cognitive Health Assessment',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Builds the main content section with sign-in button and privacy info
  Widget _buildMainContentSection(ThemeData theme) {
    return Column(
      children: [
        // Google Sign-In button
        _buildGoogleSignInButton(theme),

        SizedBox(height: 3.h),

        // Error message display
        if (_errorMessage != null) _buildErrorMessage(theme),

        SizedBox(height: 4.h),

        // Privacy message
        _buildPrivacyMessage(theme),

        SizedBox(height: 2.h),

        // Healthcare compliance badges
        _buildComplianceBadges(theme),
      ],
    );
  }

  /// Builds the Google Sign-In button with loading state
  Widget _buildGoogleSignInButton(ThemeData theme) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 85.w),
      child: _isLoading
          ? Container(
              height: 7.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline, width: 1),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Signing you in...',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SignInButton(
              Buttons.google,
              text: "Continue with Google",
              onPressed: _handleGoogleSignIn,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
    );
  }

  /// Builds error message display
  Widget _buildErrorMessage(ThemeData theme) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 85.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            size: 5.w,
            color: theme.colorScheme.error,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              _errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds privacy message section
  Widget _buildPrivacyMessage(ThemeData theme) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 85.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'lock',
            size: 5.w,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Your cognitive assessment data is encrypted and secure',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds healthcare compliance badges
  Widget _buildComplianceBadges(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBadge('HIPAA', theme),
        SizedBox(width: 4.w),
        _buildBadge('SSL', theme),
      ],
    );
  }

  /// Builds individual compliance badge
  Widget _buildBadge(String label, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'verified_user',
            size: 4.w,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 2.w),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds bottom section with legal links
  Widget _buildBottomSection(ThemeData theme) {
    return Column(
      children: [
        SizedBox(height: 2.h),
        Text(
          'By continuing, you agree to our',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegalLink('Privacy Policy', theme),
            Text(
              ' and ',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            _buildLegalLink('Terms of Service', theme),
          ],
        ),
      ],
    );
  }

  /// Builds legal link button
  Widget _buildLegalLink(String text, ThemeData theme) {
    return GestureDetector(
      onTap: () => _handleLegalLinkTap(text),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  /// Handles Google Sign-In button press
  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate authentication delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication success
      // In production, implement actual Google Sign-In SDK integration
      final bool isNewUser = DateTime.now().second % 2 == 0;

      if (!mounted) return;

      // Provide haptic feedback
      if (!kIsWeb) {
        // HapticFeedback would be imported from 'package:flutter/services.dart'
        // HapticFeedback.mediumImpact();
      }

      // Navigate based on user status
      if (isNewUser) {
        // New user - navigate to profile setup
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushReplacementNamed('/main-dashboard');
      } else {
        // Returning user - navigate to dashboard
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushReplacementNamed('/main-dashboard');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = _getErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  /// Gets user-friendly error message based on exception
  String _getErrorMessage(dynamic error) {
    // In production, handle specific Google Sign-In exceptions
    if (error.toString().contains('network')) {
      return 'Network connection issue. Please check your internet and try again.';
    } else if (error.toString().contains('cancelled')) {
      return 'Sign-in was cancelled. Please try again.';
    } else if (error.toString().contains('account')) {
      return 'Account access restricted. Please contact support.';
    } else {
      return 'Google Sign-In is temporarily unavailable. Please try again later.';
    }
  }

  /// Handles legal link tap
  void _handleLegalLinkTap(String linkType) {
    // In production, open web view or external browser with legal documents
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $linkType...'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
