import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';
import 'dart:math';
import '../../services/app_state_manager.dart';
import '../../services/analytics_service.dart';

/// Advanced Memory Matrix Test - Tests visual memory and recall
class MemoryMatrixModule extends StatefulWidget {
  const MemoryMatrixModule({Key? key}) : super(key: key);

  @override
  State<MemoryMatrixModule> createState() => _MemoryMatrixModuleState();
}

class _MemoryMatrixModuleState extends State<MemoryMatrixModule> {
  final _stateManager = AppStateManager();
  final _analytics = AnalyticsService();
  
  int _gridSize = 3;
  List<int> _targetCells = [];
  List<int> _selectedCells = [];
  bool _isMemorizing = false;
  bool _isRecalling = false;
  int _currentLevel = 1;
  int _score = 0;
  int _lives = 3;
  String _status = 'Memorize the highlighted cells';

  @override
  void initState() {
    super.initState();
    _analytics.trackScreenView('memory_matrix_module');
    _analytics.trackAssessmentStart('memory_matrix', 'Memory Matrix Test');
    _startLevel();
  }

  void _startLevel() {
    final numTargets = min(_currentLevel + 1, _gridSize * _gridSize);
    _targetCells = _generateRandomCells(numTargets);
    _selectedCells.clear();

    setState(() {
      _isMemorizing = true;
      _isRecalling = false;
      _status = 'Memorize these cells...';
    });

    Timer(Duration(seconds: max(2, 4 - (_currentLevel ~/ 3))), () {
      if (mounted) {
        setState(() {
          _isMemorizing = false;
          _isRecalling = true;
          _status = 'Now select the cells you remember';
        });
      }
    });
  }

  List<int> _generateRandomCells(int count) {
    final random = Random();
    final totalCells = _gridSize * _gridSize;
    final cells = <int>[];
    
    while (cells.length < count) {
      final cell = random.nextInt(totalCells);
      if (!cells.contains(cell)) {
        cells.add(cell);
      }
    }
    
    return cells;
  }

  void _handleCellTap(int index) {
    if (!_isRecalling) return;

    setState(() {
      if (_selectedCells.contains(index)) {
        _selectedCells.remove(index);
      } else {
        _selectedCells.add(index);
      }
    });
  }

  void _submitAnswer() {
    if (!_isRecalling) return;

    final correctCells = _selectedCells.where((cell) => _targetCells.contains(cell)).length;
    final incorrectCells = _selectedCells.where((cell) => !_targetCells.contains(cell)).length;
    final missedCells = _targetCells.where((cell) => !_selectedCells.contains(cell)).length;

    if (correctCells == _targetCells.length && incorrectCells == 0) {
      // Perfect match
      setState(() {
        _score += _currentLevel * 10;
        _currentLevel++;
        
        if (_currentLevel % 3 == 0 && _gridSize < 6) {
          _gridSize++;
        }
        
        _status = 'Correct! +${_currentLevel * 10} points';
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _startLevel();
      });
    } else {
      // Wrong answer
      setState(() {
        _lives--;
        _status = 'Incorrect! Lives remaining: $_lives';
      });

      if (_lives <= 0) {
        _completeTest();
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) _startLevel();
        });
      }
    }
  }

  void _completeTest() {
    final finalScore = (_score / (_currentLevel * 10 + 50)) * 100;
    
    _stateManager.updateCognitiveScore('memory', finalScore);
    _analytics.trackAssessmentComplete(
      'memory_matrix',
      'Memory Matrix Test',
      duration: Duration(minutes: 3),
      score: finalScore,
      additionalData: {
        'final_score': _score,
        'levels_completed': _currentLevel - 1,
      },
    );

    setState(() {
      _isRecalling = false;
      _status = 'Test Complete! Score: $_score';
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Test Complete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Final Score: $_score'),
            Text('Levels Completed: ${_currentLevel - 1}'),
            Text('Memory Score: ${finalScore.toStringAsFixed(0)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Matrix'),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 20),
                SizedBox(width: 1.w),
                Text('$_lives', style: const TextStyle(fontSize: 16)),
                SizedBox(width: 4.w),
                Icon(Icons.stars, color: Colors.amber, size: 20),
                SizedBox(width: 1.w),
                Text('$_score', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _status,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Level $_currentLevel',
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _gridSize,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _gridSize * _gridSize,
                      itemBuilder: (context, index) {
                        final isTarget = _targetCells.contains(index);
                        final isSelected = _selectedCells.contains(index);
                        
                        return GestureDetector(
                          onTap: () => _handleCellTap(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _isMemorizing && isTarget
                                  ? const Color(0xFF2A9D8F)
                                  : _isRecalling && isSelected
                                      ? const Color(0xFF4A90A4)
                                      : theme.cardColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.outline.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (_isRecalling)
              Padding(
                padding: EdgeInsets.all(4.w),
                child: ElevatedButton(
                  onPressed: _submitAnswer,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 6.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Answer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
