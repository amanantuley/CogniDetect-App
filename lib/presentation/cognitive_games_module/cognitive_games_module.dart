import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/game_card_widget.dart';
import './widgets/game_controls_widget.dart';
import './widgets/game_header_widget.dart';

/// Cognitive Games Module Screen
/// Provides interactive neurological assessments through gamified interfaces
class CognitiveGamesModule extends StatefulWidget {
  const CognitiveGamesModule({super.key});

  @override
  State<CognitiveGamesModule> createState() => _CognitiveGamesModuleState();
}

class _CognitiveGamesModuleState extends State<CognitiveGamesModule> {
  int _currentGameIndex = 0;
  int _score = 0;
  int _timeRemaining = 60;
  bool _isPaused = false;
  bool _showInstructions = false;
  bool _gameCompleted = false;

  // Mock data for cognitive games
  final List<Map<String, dynamic>> _games = [
    {
      "id": 1,
      "title": "Memory Matching",
      "description": "Match pairs of cards to test your memory recall",
      "icon": "psychology",
      "color": 0xFF2E7D9A,
      "difficulty": "Easy",
      "duration": 60,
      "type": "memory",
      "instructions":
          "Tap cards to reveal them. Match all pairs to complete the game.",
      "cards": [
        {"id": 1, "value": "🍎", "matched": false, "revealed": false},
        {"id": 2, "value": "🍎", "matched": false, "revealed": false},
        {"id": 3, "value": "🍊", "matched": false, "revealed": false},
        {"id": 4, "value": "🍊", "matched": false, "revealed": false},
        {"id": 5, "value": "🍇", "matched": false, "revealed": false},
        {"id": 6, "value": "🍇", "matched": false, "revealed": false},
        {"id": 7, "value": "🍓", "matched": false, "revealed": false},
        {"id": 8, "value": "🍓", "matched": false, "revealed": false},
      ],
      "correctAnswers": 0,
      "totalAttempts": 0,
    },
    {
      "id": 2,
      "title": "Pattern Recognition",
      "description": "Identify the next item in the sequence",
      "icon": "grid_on",
      "color": 0xFF4A90A4,
      "difficulty": "Medium",
      "duration": 90,
      "type": "pattern",
      "instructions":
          "Study the pattern and select the correct next item from the options.",
      "patterns": [
        {
          "sequence": ["🔴", "🔵", "🔴", "🔵", "🔴"],
          "options": ["🔴", "🔵", "🟢", "🟡"],
          "correct": "🔵",
        },
        {
          "sequence": ["1", "2", "4", "8", "16"],
          "options": ["24", "32", "20", "18"],
          "correct": "32",
        },
        {
          "sequence": ["A", "C", "E", "G", "I"],
          "options": ["J", "K", "L", "M"],
          "correct": "K",
        },
      ],
      "currentPattern": 0,
      "correctAnswers": 0,
      "totalAttempts": 0,
    },
    {
      "id": 3,
      "title": "Reaction Time",
      "description": "Test your response speed to visual stimuli",
      "icon": "flash_on",
      "color": 0xFFF4A261,
      "difficulty": "Easy",
      "duration": 45,
      "type": "reaction",
      "instructions":
          "Tap the screen as quickly as possible when the target appears.",
      "trials": 10,
      "currentTrial": 0,
      "reactionTimes": [],
      "averageTime": 0,
    },
    {
      "id": 4,
      "title": "Attention Span",
      "description": "Focus on specific targets while ignoring distractions",
      "icon": "visibility",
      "color": 0xFF2A9D8F,
      "difficulty": "Hard",
      "duration": 120,
      "type": "attention",
      "instructions":
          "Count only the blue circles. Ignore all other shapes and colors.",
      "targets": [
        {"shape": "circle", "color": "blue", "isTarget": true},
        {"shape": "square", "color": "red", "isTarget": false},
        {"shape": "circle", "color": "blue", "isTarget": true},
        {"shape": "triangle", "color": "green", "isTarget": false},
        {"shape": "circle", "color": "red", "isTarget": false},
        {"shape": "circle", "color": "blue", "isTarget": true},
        {"shape": "square", "color": "blue", "isTarget": false},
        {"shape": "circle", "color": "blue", "isTarget": true},
      ],
      "correctCount": 4,
      "userAnswer": 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !_isPaused && _timeRemaining > 0 && !_gameCompleted) {
        setState(() {
          _timeRemaining--;
        });
        _startTimer();
      } else if (_timeRemaining == 0 && !_gameCompleted) {
        _completeGame();
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _showHelp() {
    setState(() {
      _showInstructions = true;
    });
  }

  void _hideHelp() {
    setState(() {
      _showInstructions = false;
    });
  }

  void _nextGame() {
    if (_currentGameIndex < _games.length - 1) {
      setState(() {
        _currentGameIndex++;
        _timeRemaining = (_games[_currentGameIndex]["duration"] as int);
        _isPaused = false;
        _showInstructions = false;
      });
    } else {
      _completeGame();
    }
  }

  void _previousGame() {
    if (_currentGameIndex > 0) {
      setState(() {
        _currentGameIndex--;
        _timeRemaining = (_games[_currentGameIndex]["duration"] as int);
        _isPaused = false;
        _showInstructions = false;
      });
    }
  }

  void _completeGame() {
    setState(() {
      _gameCompleted = true;
      _isPaused = true;
    });

    // Show completion dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildCompletionDialog(),
    );
  }

  Widget _buildCompletionDialog() {
    final theme = Theme.of(context);
    final totalGames = _games.length;
    final completedGames = _currentGameIndex + 1;
    final accuracy = _score > 0
        ? (_score / (completedGames * 100) * 100).toStringAsFixed(1)
        : "0.0";

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'celebration',
              color: theme.colorScheme.tertiary,
              size: 60,
            ),
            SizedBox(height: 3.h),
            Text(
              'Congratulations!',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'You have completed the cognitive assessment',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Column(
                children: [
                  _buildStatRow(
                    'Games Completed',
                    '$completedGames / $totalGames',
                    theme,
                  ),
                  SizedBox(height: 2.h),
                  _buildStatRow('Total Score', '$_score points', theme),
                  SizedBox(height: 2.h),
                  _buildStatRow('Accuracy', '$accuracy%', theme),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              '💡 Great job! Your results have been saved.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushReplacementNamed('/main-dashboard');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Return to Dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  void _handleGameAction(String action, dynamic data) {
    final currentGame = _games[_currentGameIndex];
    final gameType = currentGame["type"] as String;

    switch (gameType) {
      case "memory":
        _handleMemoryGame(action, data);
        break;
      case "pattern":
        _handlePatternGame(action, data);
        break;
      case "reaction":
        _handleReactionGame(action, data);
        break;
      case "attention":
        _handleAttentionGame(action, data);
        break;
    }
  }

  void _handleMemoryGame(String action, dynamic data) {
    if (action == "card_tap") {
      final cardIndex = data as int;
      final cards = _games[_currentGameIndex]["cards"] as List;
      final card = cards[cardIndex] as Map<String, dynamic>;

      if (card["matched"] == true || card["revealed"] == true) return;

      setState(() {
        card["revealed"] = true;
      });

      final revealedCards = (cards)
          .where(
            (c) =>
                (c as Map<String, dynamic>)["revealed"] == true &&
                (c)["matched"] == false,
          )
          .toList();

      if (revealedCards.length == 2) {
        final card1 = revealedCards[0] as Map<String, dynamic>;
        final card2 = revealedCards[1] as Map<String, dynamic>;

        if (card1["value"] == card2["value"]) {
          setState(() {
            card1["matched"] = true;
            card2["matched"] = true;
            _score += 10;
            _games[_currentGameIndex]["correctAnswers"] =
                (_games[_currentGameIndex]["correctAnswers"] as int) + 1;
          });
        } else {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                card1["revealed"] = false;
                card2["revealed"] = false;
              });
            }
          });
        }

        setState(() {
          _games[_currentGameIndex]["totalAttempts"] =
              (_games[_currentGameIndex]["totalAttempts"] as int) + 1;
        });

        // Check if all cards are matched
        final allMatched = (cards).every(
          (c) => (c as Map<String, dynamic>)["matched"] == true,
        );
        if (allMatched) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              _nextGame();
            }
          });
        }
      }
    }
  }

  void _handlePatternGame(String action, dynamic data) {
    if (action == "answer_selected") {
      final selectedAnswer = data as String;
      final patterns = _games[_currentGameIndex]["patterns"] as List;
      final currentPatternIndex =
          _games[_currentGameIndex]["currentPattern"] as int;
      final currentPattern =
          patterns[currentPatternIndex] as Map<String, dynamic>;

      setState(() {
        _games[_currentGameIndex]["totalAttempts"] =
            (_games[_currentGameIndex]["totalAttempts"] as int) + 1;
      });

      if (selectedAnswer == currentPattern["correct"]) {
        setState(() {
          _score += 15;
          _games[_currentGameIndex]["correctAnswers"] =
              (_games[_currentGameIndex]["correctAnswers"] as int) + 1;
        });
      }

      if (currentPatternIndex < patterns.length - 1) {
        setState(() {
          _games[_currentGameIndex]["currentPattern"] = currentPatternIndex + 1;
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _nextGame();
          }
        });
      }
    }
  }

  void _handleReactionGame(String action, dynamic data) {
    if (action == "target_tapped") {
      final reactionTime = data as int;
      final reactionTimes = _games[_currentGameIndex]["reactionTimes"] as List;
      final currentTrial = _games[_currentGameIndex]["currentTrial"] as int;
      final totalTrials = _games[_currentGameIndex]["trials"] as int;

      setState(() {
        reactionTimes.add(reactionTime);
        _games[_currentGameIndex]["currentTrial"] = currentTrial + 1;
        _score += reactionTime < 500 ? 20 : (reactionTime < 800 ? 15 : 10);
      });

      if (currentTrial + 1 >= totalTrials) {
        final avgTime =
            (reactionTimes).reduce((a, b) => (a as int) + (b as int)) /
                reactionTimes.length;
        setState(() {
          _games[_currentGameIndex]["averageTime"] = avgTime;
        });

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _nextGame();
          }
        });
      }
    }
  }

  void _handleAttentionGame(String action, dynamic data) {
    if (action == "answer_submitted") {
      final userAnswer = data as int;
      final correctCount = _games[_currentGameIndex]["correctCount"] as int;

      setState(() {
        _games[_currentGameIndex]["userAnswer"] = userAnswer;
      });

      if (userAnswer == correctCount) {
        setState(() {
          _score += 25;
        });
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _nextGame();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentGame = _games[_currentGameIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                GameHeaderWidget(
                  gameTitle: currentGame["title"] as String,
                  currentGame: _currentGameIndex + 1,
                  totalGames: _games.length,
                  score: _score,
                  timeRemaining: _timeRemaining,
                  isPaused: _isPaused,
                  onPauseToggle: _togglePause,
                  onHelpPressed: _showHelp,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: GameCardWidget(
                      game: currentGame,
                      onGameAction: _handleGameAction,
                    ),
                  ),
                ),
                GameControlsWidget(
                  currentGame: _currentGameIndex,
                  totalGames: _games.length,
                  onPrevious: _previousGame,
                  onNext: _nextGame,
                  onSubmit: _completeGame,
                ),
              ],
            ),
            if (_showInstructions)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _hideHelp,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.7),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.all(6.w),
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Instructions',
                                  style: theme.textTheme.titleLarge,
                                ),
                                IconButton(
                                  onPressed: _hideHelp,
                                  icon: CustomIconWidget(
                                    iconName: 'close',
                                    color: theme.colorScheme.onSurface,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              currentGame["instructions"] as String,
                              style: theme.textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 3.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _hideHelp,
                                child: const Text('Got it!'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
