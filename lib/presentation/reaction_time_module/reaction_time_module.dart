import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';
import 'dart:math';
import '../../services/app_state_manager.dart';
import '../../services/analytics_service.dart';

/// Advanced Reaction Time Test Module
class ReactionTimeModule extends StatefulWidget {
  const ReactionTimeModule({Key? key}) : super(key: key);

  @override
  State<ReactionTimeModule> createState() => _ReactionTimeModuleState();
}

class _ReactionTimeModuleState extends State<ReactionTimeModule> {
  final _stateManager = AppStateManager();
  final _analytics = AnalyticsService();
  
  bool _isWaiting = false;
  bool _showTarget = false;
  DateTime? _targetShowTime;
  List<int> _reactionTimes = [];
  int _currentRound = 0;
  final int _totalRounds = 10;
  Timer? _timer;
  String _status = 'Tap "Start" to begin';
  bool _testCompleted = false;
  bool _tooEarly = false;

  @override
  void initState() {
    super.initState();
    _analytics.trackScreenView('reaction_time_module');
    _analytics.trackAssessmentStart('reaction_time', 'Reaction Time Test');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTest() {
    setState(() {
      _currentRound = 0;
      _reactionTimes.clear();
      _testCompleted = false;
      _status = 'Get ready...';
    });
    _startRound();
  }

  void _startRound() {
    if (_currentRound >= _totalRounds) {
      _completeTest();
      return;
    }

    setState(() {
      _showTarget = false;
      _isWaiting = true;
      _tooEarly = false;
      _status = 'Wait for the target...';
    });

    // Random delay between 1-4 seconds
    final delay = Duration(milliseconds: 1000 + Random().nextInt(3000));
    
    _timer = Timer(delay, () {
      if (mounted) {
        setState(() {
          _showTarget = true;
          _isWaiting = false;
          _targetShowTime = DateTime.now();
          _status = 'TAP NOW!';
        });

        // Auto-advance after 2 seconds if not tapped
        Timer(const Duration(seconds: 2), () {
          if (mounted && _showTarget) {
            _handleMissedTarget();
          }
        });
      }
    });
  }

  void _handleTap() {
    if (_tooEarly) return;

    if (_isWaiting) {
      // Tapped too early
      setState(() {
        _tooEarly = true;
        _status = 'Too early! Wait for the target.';
      });
      _timer?.cancel();
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _startRound();
      });
      return;
    }

    if (_showTarget && _targetShowTime != null) {
      final reactionTime = DateTime.now().difference(_targetShowTime!).inMilliseconds;
      _reactionTimes.add(reactionTime);
      
      setState(() {
        _currentRound++;
        _showTarget = false;
        _status = '$reactionTime ms - Round ${_currentRound}/$_totalRounds';
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _startRound();
      });
    }
  }

  void _handleMissedTarget() {
    setState(() {
      _currentRound++;
      _showTarget = false;
      _status = 'Missed! - Round ${_currentRound}/$_totalRounds';
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _startRound();
    });
  }

  void _completeTest() {
    if (_reactionTimes.isEmpty) {
      setState(() => _status = 'Test incomplete');
      return;
    }

    final avgTime = _reactionTimes.reduce((a, b) => a + b) / _reactionTimes.length;
    final score = _calculateScore(avgTime);

    _stateManager.updateCognitiveScore('processing_speed', score);
    _analytics.trackAssessmentComplete(
      'reaction_time',
      'Reaction Time Test',
      duration: Duration(seconds: 30),
      score: score,
      additionalData: {
        'average_time_ms': avgTime,
        'attempts': _reactionTimes.length,
      },
    );

    setState(() {
      _testCompleted = true;
      _status = 'Test Complete! Average: ${avgTime.toStringAsFixed(0)} ms';
    });
  }

  double _calculateScore(double avgTime) {
    // Score calculation: <200ms = 100, >500ms = 0, linear interpolation
    if (avgTime <= 200) return 100;
    if (avgTime >= 500) return 0;
    return 100 - ((avgTime - 200) / 3);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reaction Time Test'),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: _showTarget
              ? const Color(0xFF2A9D8F)
              : _tooEarly
                  ? const Color(0xFFE76F51)
                  : theme.scaffoldBackgroundColor,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_showTarget && !_isWaiting && !_testCompleted)
                  ElevatedButton(
                    onPressed: _startTest,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Start Test',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.all(4.w),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _status,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Round ${_currentRound}/$_totalRounds',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                if (_reactionTimes.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _reactionTimes.asMap().entries.map((entry) {
                        return Chip(
                          label: Text('${entry.key + 1}: ${entry.value}ms'),
                          backgroundColor: entry.value < 300
                              ? Colors.green.withOpacity(0.2)
                              : entry.value < 400
                                  ? Colors.orange.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                        );
                      }).toList(),
                    ),
                  ),
                ],
                if (_testCompleted) ...[
                  SizedBox(height: 4.h),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Complete'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
