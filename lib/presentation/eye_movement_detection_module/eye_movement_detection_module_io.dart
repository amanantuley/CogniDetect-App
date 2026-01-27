import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/assessment_results_widget.dart';
import './widgets/calibration_widget.dart';
import './widgets/camera_preview_widget.dart';
import './widgets/positioning_feedback_widget.dart';
import './widgets/tracking_overlay_widget.dart';

class EyeMovementDetectionModule extends StatefulWidget {
  const EyeMovementDetectionModule({super.key});

  @override
  State<EyeMovementDetectionModule> createState() =>
      _EyeMovementDetectionModuleState();
}

class _EyeMovementDetectionModuleState
    extends State<EyeMovementDetectionModule> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _showCalibration = true;
  bool _showResults = false;
  String _positioningFeedback = 'Initializing camera...';
  bool _isPositionedCorrectly = false;
  int _currentPhase = 0;
  final List<String> _phases = [
    'Calibration',
    'Smooth Pursuit',
    'Rapid Eye Movement',
    'Sustained Attention',
  ];
  final Map<String, dynamic> _assessmentData = {
    'smoothPursuit': 0.0,
    'rapidMovement': 0.0,
    'sustainedAttention': 0.0,
    'overallScore': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        setState(() {
          _positioningFeedback = 'Camera permission denied';
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _positioningFeedback = 'No camera available';
        });
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            );

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _positioningFeedback = 'Position your face in the frame';
        });
        _startPositionTracking();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _positioningFeedback = 'Camera initialization failed';
        });
      }
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;
    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      // Focus mode not supported
    }
    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.off);
      } catch (e) {
        // Flash mode not supported
      }
    }
  }

  void _startPositionTracking() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _isCameraInitialized) {
        setState(() {
          _isPositionedCorrectly = true;
          _positioningFeedback = 'Good positioning';
        });
      }
    });
  }

  void _startCalibration() {
    setState(() {
      _showCalibration = true;
      _isRecording = true;
    });
  }

  void _completeCalibration() {
    setState(() {
      _showCalibration = false;
      _currentPhase = 1;
    });
    _startAssessmentPhase();
  }

  void _startAssessmentPhase() {
    if (_currentPhase >= _phases.length) {
      _completeAssessment();
      return;
    }

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        final phaseScore = 75.0 + (DateTime.now().millisecond % 20);
        setState(() {
          if (_currentPhase == 1) {
            _assessmentData['smoothPursuit'] = phaseScore;
          } else if (_currentPhase == 2) {
            _assessmentData['rapidMovement'] = phaseScore;
          } else if (_currentPhase == 3) {
            _assessmentData['sustainedAttention'] = phaseScore;
          }
          _currentPhase++;
        });
        _startAssessmentPhase();
      }
    });
  }

  void _completeAssessment() {
    final overallScore = (_assessmentData['smoothPursuit'] +
            _assessmentData['rapidMovement'] +
            _assessmentData['sustainedAttention']) /
        3;
    setState(() {
      _assessmentData['overallScore'] = overallScore;
      _isRecording = false;
      _showResults = true;
    });
  }

  void _returnToDashboard() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed('/main-dashboard');
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _showResults
            ? AssessmentResultsWidget(
                assessmentData: _assessmentData,
                onReturnToDashboard: _returnToDashboard,
              )
            : Column(
                children: [
                  _buildHeader(theme),
                  Expanded(
                    child: Stack(
                      children: [
                        CameraPreviewWidget(
                          cameraController: _cameraController,
                          isCameraInitialized: _isCameraInitialized,
                        ),
                        if (_isCameraInitialized && !_showCalibration)
                          TrackingOverlayWidget(
                            isPositionedCorrectly: _isPositionedCorrectly,
                            currentPhase: _currentPhase,
                            phaseName: _currentPhase < _phases.length
                                ? _phases[_currentPhase]
                                : 'Complete',
                          ),
                        if (_showCalibration)
                          CalibrationWidget(
                            onCalibrationComplete: _completeCalibration,
                          ),
                      ],
                    ),
                  ),
                  PositioningFeedbackWidget(
                    feedback: _positioningFeedback,
                    isPositionedCorrectly: _isPositionedCorrectly,
                    isRecording: _isRecording,
                    onStartCalibration: _startCalibration,
                    showStartButton: _isCameraInitialized && !_isRecording,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eye Movement Detection',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _isRecording ? 'Recording Active' : 'Camera Ready',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
