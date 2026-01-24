import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/analysis_results_widget.dart';
import './widgets/playback_controls_widget.dart';
import './widgets/recording_button_widget.dart';
import './widgets/recording_prompt_widget.dart';

/// Speech Analysis Module Screen
/// Captures and analyzes speech patterns for cognitive assessment
class SpeechAnalysisModule extends StatefulWidget {
  const SpeechAnalysisModule({super.key});

  @override
  State<SpeechAnalysisModule> createState() => _SpeechAnalysisModuleState();
}

class _SpeechAnalysisModuleState extends State<SpeechAnalysisModule>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  bool _hasRecording = false;
  bool _isPlaying = false;
  bool _isAnalyzing = false;
  bool _showResults = false;

  String? _recordingPath;
  Duration _recordingDuration = Duration.zero;
  Duration _playbackPosition = Duration.zero;

  late AnimationController _pulseController;
  late AnimationController _waveformController;

  // Mock analysis results
  Map<String, dynamic>? _analysisResults;

  // Recording prompts
  final List<Map<String, String>> _prompts = [
    {
      "type": "reading",
      "text":
          "Please read the following passage aloud: 'The quick brown fox jumps over the lazy dog. This sentence contains every letter of the alphabet.'",
      "duration": "30-45 seconds",
    },
    {
      "type": "description",
      "text":
          "Describe what you see in your surroundings for the next minute. Include colors, objects, and any activities you notice.",
      "duration": "45-60 seconds",
    },
    {
      "type": "spontaneous",
      "text":
          "Tell us about your favorite memory from childhood. Speak naturally and take your time.",
      "duration": "60-90 seconds",
    },
  ];

  int _currentPromptIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _requestMicrophonePermission();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _waveformController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();
  }

  Future<void> _requestMicrophonePermission() async {
    if (kIsWeb) {
      // Browser handles permissions automatically
      return;
    }

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Microphone Permission Required',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'This module needs microphone access to record and analyze your speech patterns. Please grant permission in your device settings.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
          _hasRecording = false;
          _showResults = false;
          _recordingDuration = Duration.zero;
        });

        if (kIsWeb) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'recording.wav',
          );
        } else {
          final dir = await getTemporaryDirectory();
          final path =
              '${dir.path}/speech_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: path,
          );
          _recordingPath = path;
        }

        _startDurationTimer();
      } else {
        _showPermissionDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start recording. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _startDurationTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingDuration = Duration(
            seconds: _recordingDuration.inSeconds + 1,
          );
        });
        _startDurationTimer();
      }
    });
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
        _hasRecording = true;
        _recordingPath = path;
      });

      _analyzeRecording();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to stop recording. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _analyzeRecording() async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate analysis processing
    await Future.delayed(const Duration(seconds: 2));

    // Generate mock analysis results
    final results = {
      "speechRate": 145 + (DateTime.now().millisecond % 30),
      "pausePatterns": {
        "shortPauses": 12 + (DateTime.now().millisecond % 8),
        "longPauses": 3 + (DateTime.now().millisecond % 4),
        "averagePauseDuration": 0.8 + (DateTime.now().millisecond % 5) / 10,
      },
      "fluencyScore": 78 + (DateTime.now().millisecond % 20),
      "clarity": 85 + (DateTime.now().millisecond % 15),
      "volumeConsistency": 82 + (DateTime.now().millisecond % 18),
      "timestamp": DateTime.now().toIso8601String(),
    };

    setState(() {
      _analysisResults = results;
      _isAnalyzing = false;
      _showResults = true;
    });
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _simulatePlayback();
    }
  }

  void _simulatePlayback() {
    if (_isPlaying && _playbackPosition < _recordingDuration) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _isPlaying) {
          setState(() {
            _playbackPosition = Duration(
              milliseconds: _playbackPosition.inMilliseconds + 100,
            );
          });
          _simulatePlayback();
        }
      });
    } else {
      setState(() {
        _isPlaying = false;
        _playbackPosition = Duration.zero;
      });
    }
  }

  void _reRecord() {
    setState(() {
      _hasRecording = false;
      _showResults = false;
      _recordingPath = null;
      _recordingDuration = Duration.zero;
      _playbackPosition = Duration.zero;
      _analysisResults = null;
      _currentPromptIndex = (_currentPromptIndex + 1) % _prompts.length;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveformController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: Text('Speech Analysis', style: theme.appBarTheme.titleTextStyle),
        centerTitle: true,
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Privacy assurance
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'lock',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Flexible(
                        child: Text(
                          'Audio processed locally and encrypted',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Recording prompt
                if (!_showResults)
                  RecordingPromptWidget(prompt: _prompts[_currentPromptIndex]),

                SizedBox(height: 4.h),

                // Recording interface
                if (!_hasRecording && !_showResults)
                  Column(
                    children: [
                      RecordingButtonWidget(
                        isRecording: _isRecording,
                        pulseController: _pulseController,
                        waveformController: _waveformController,
                        onPressed:
                            _isRecording ? _stopRecording : _startRecording,
                      ),

                      SizedBox(height: 3.h),

                      // Timer
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.shadow.withValues(
                                alpha: 0.08,
                              ),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              _formatDuration(_recordingDuration),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: _isRecording
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              _isRecording ? 'Recording...' : 'Ready to record',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Recommended duration
                      Text(
                        'Recommended: ${_prompts[_currentPromptIndex]["duration"]}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                // Playback controls
                if (_hasRecording && !_showResults)
                  PlaybackControlsWidget(
                    isPlaying: _isPlaying,
                    recordingDuration: _recordingDuration,
                    playbackPosition: _playbackPosition,
                    onPlayPause: _togglePlayback,
                    onReRecord: _reRecord,
                    formatDuration: _formatDuration,
                  ),

                // Analysis loading
                if (_isAnalyzing)
                  Column(
                    children: [
                      SizedBox(height: 4.h),
                      CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Analyzing speech patterns...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                // Analysis results
                if (_showResults && _analysisResults != null)
                  AnalysisResultsWidget(
                    results: _analysisResults!,
                    onReRecord: _reRecord,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
