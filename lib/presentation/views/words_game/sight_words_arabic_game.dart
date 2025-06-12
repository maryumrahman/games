import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/services/hive_services.dart';
import '../../../state_management/providers/games_user_provider.dart';

class WordsGameScreen extends StatefulWidget {
  const WordsGameScreen({super.key});

  @override
  State<WordsGameScreen> createState() => _WordsGameScreenState();
}

class _WordsGameScreenState extends State<WordsGameScreen> with SingleTickerProviderStateMixin {
  final String game = 'Words Game';

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  final List<String> arabicWords = [
    'السلام عليكم',
    'صباح الخير',
    'مساء الخير',
    'شكراً',
    'عفواً',
  ];

  late Color targetColor;
  int currentLevel = 0;
  int correctPresses = 0;
  int winCount = 0;
  final List<Word> all_words = [];
  final Random random = Random();
  late AnimationController _animationController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  static const int maxCorrectTaps = 12;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();
    _animationController.addListener(_updateDuckPositions);
    startNewLevel();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _updateDuckPositions() {
    setState(() {
      for (var duck in all_words) {
        duck.position += duck.speed;

        // Bounce off screen edges
        if (duck.position.dx < 0 || duck.position.dx > 300) {
          duck.speed = Offset(-duck.speed.dx, duck.speed.dy);
        }
        if (duck.position.dy < 0 || duck.position.dy > 500) {
          duck.speed = Offset(duck.speed.dx, -duck.speed.dy);
        }
      }
    });
  }

  void startNewLevel() {
    setState(() {
      targetColor = colors[currentLevel];
      correctPresses = 0;
      all_words.clear();

      // Calculate speed multiplier based on level (starts at 1.0 and increases by 0.5 each level)
      double speedMultiplier = 1.0 + (currentLevel * 0.5);

      // Add all words with the same word for this level, just different colors
      for (int i = 0; i < 10; i++) {
        all_words.add(Word(
          color: colors[random.nextInt(colors.length)],
          word: arabicWords[currentLevel],
          position: Offset(
            random.nextDouble() * 300,
            random.nextDouble() * 500,
          ),
          speed: Offset(
            (random.nextDouble() - 0.5) * 2 * speedMultiplier,
            (random.nextDouble() - 0.5) * 2 * speedMultiplier,
          ),
        ));
      }

      // Ensure at least one word has the target color
      if (!all_words.any((word) => word.color == targetColor)) {
        all_words[0] = Word(
          color: targetColor,
          word: arabicWords[currentLevel],
          position: all_words[0].position,
          speed: all_words[0].speed,
        );
      }

      // Shuffle the words to mix up their positions
      all_words.shuffle(random);
    });
  }

  void _playSound(String asset) {
    _audioPlayer.play(AssetSource(asset));
  }

  void _updateWinCount() {
    final userProvider = Provider.of<LoadUsersGamesProvider>(context, listen: false);
    if (HiveFunctions.hasActivePlayer1() ) {
      userProvider.addWin(game);
    }
  }

  void showNextLevelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Level Complete!'),
        content: const Text('Ready for the next level?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _updateWinCount();
              setState(() {
                currentLevel++;
              });
              startNewLevel();
            },
            child: const Text('Next Level'),
          ),
        ],
      ),
    );
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: const Text('You completed all levels!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _updateWinCount();
              setState(() {
                winCount++;
                currentLevel = 0;
              });
              startNewLevel();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Game - Level ${currentLevel + 1}'),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/sky_grass_bkrnd.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Target color display
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Find the ${_getColorName(targetColor)} ${arabicWords[currentLevel] }!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: targetColor,
                  ),
                ),
              ),
            ),
          ),

          // Words
          ...all_words.map((duck) => Positioned(
            left: duck.position.dx,
            top: duck.position.dy,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textPainter = TextPainter(
                  text: TextSpan(
                    text: duck.word,
                    style: TextStyle(
                      fontFamily: 'Saleem',
                      fontSize: 32,
                      color: duck.color,
                    ),
                  ),
                  textDirection: TextDirection.rtl,
                )..layout();

                final textSize = textPainter.size;
                final padding = 20.0; // Add some padding around the text

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (duck.color == targetColor) {
                      _playSound("sounds/success.mp3");
                      setState(() {
                        if (correctPresses < maxCorrectTaps) {
                          correctPresses++;
                          if (correctPresses >= maxCorrectTaps) {
                            if (currentLevel < colors.length - 1) {
                              showNextLevelDialog();
                            } else {
                              showWinDialog();
                            }
                          }
                        }
                      });
                    } else {
                      _playSound("sounds/flip.mp3");
                    }
                  },
                  child: Container(
                    width: textSize.width + padding,
                    height: textSize.height + padding,
                    child: Center(
                      child: Text(
                        duck.word,
                        style: TextStyle(
                          fontFamily: 'Saleem',
                          fontSize: 32,
                          color: duck.color,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                );
              },
            ),
          )).toList(),

          // Score display
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Correct: $correctPresses/$maxCorrectTaps | Wins: $winCount',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Invisible tap detector for empty areas
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (details) {
                // Check if the tap is on any duck
                bool tappedOnDuck = all_words.any((duck) {
                  final textPainter = TextPainter(
                    text: TextSpan(
                      text: duck.word,
                      style: TextStyle(
                        fontFamily: 'Saleem',
                        fontSize: 32,
                        color: duck.color,
                      ),
                    ),
                    textDirection: TextDirection.rtl,
                  )..layout();

                  final textSize = textPainter.size;
                  final padding = 20.0;

                  final duckRect = Rect.fromLTWH(
                    duck.position.dx,
                    duck.position.dy,
                    textSize.width + padding,
                    textSize.height + padding,
                  );
                  return duckRect.contains(details.localPosition);
                });

                if (!tappedOnDuck) {
                  _playSound("sounds/flip.mp3");
                } else {
                  // Find the duck that was tapped
                  final tappedDuck = all_words.firstWhere((duck) {
                    final textPainter = TextPainter(
                      text: TextSpan(
                        text: duck.word,
                        style: TextStyle(
                          fontFamily: 'Saleem',
                          fontSize: 32,
                          color: duck.color,
                        ),
                      ),
                      textDirection: TextDirection.rtl,
                    )..layout();

                    final textSize = textPainter.size;
                    final padding = 20.0;

                    final duckRect = Rect.fromLTWH(
                      duck.position.dx,
                      duck.position.dy,
                      textSize.width + padding,
                      textSize.height + padding,
                    );
                    return duckRect.contains(details.localPosition);
                  });

                  if (tappedDuck.color == targetColor) {
                    _playSound("sounds/success.mp3");
                    setState(() {
                      // Remove the tapped word
                      all_words.remove(tappedDuck);

                      // Add a new word with the target color
                      all_words.add(Word(
                        color: targetColor,
                        word: arabicWords[currentLevel],
                        position: Offset(
                          random.nextDouble() * 300,
                          random.nextDouble() * 500,
                        ),
                        speed: Offset(
                          (random.nextDouble() - 0.5) * 2,
                          (random.nextDouble() - 0.5) * 2,
                        ),
                      ));

                      // Add another word with random color to maintain word count
                      all_words.add(Word(
                        color: colors[random.nextInt(colors.length)],
                        word: arabicWords[currentLevel],
                        position: Offset(
                          random.nextDouble() * 300,
                          random.nextDouble() * 500,
                        ),
                        speed: Offset(
                          (random.nextDouble() - 0.5) * 2,
                          (random.nextDouble() - 0.5) * 2,
                        ),
                      ));

                      correctPresses++;
                      if (correctPresses >= maxCorrectTaps) {
                        if (currentLevel < colors.length - 1) {
                          showNextLevelDialog();
                        } else {
                          showWinDialog();
                          winCount++;
                          currentLevel = 0;
                        }
                      }
                    });
                  } else {
                    _playSound("sounds/flip.mp3");
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getColorName(Color color) {
    if (color == Colors.red) return 'red';
    if (color == Colors.blue) return 'blue';
    if (color == Colors.green) return 'green';
    if (color == Colors.yellow) return 'yellow';
    if (color == Colors.purple) return 'purple';
    return 'unknown';
  }
}

class Word {
  final Color color;
  final String word;
  Offset position;
  Offset speed;

  Word({
    required this.color,
    required this.word,
    required this.position,
    required this.speed,
  });
}