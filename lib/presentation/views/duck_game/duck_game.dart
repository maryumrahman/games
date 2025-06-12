import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:games/data/services/hive_services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../state_management/providers/games_user_provider.dart';

class DuckGameScreen extends StatefulWidget {
  const DuckGameScreen({super.key});

  @override
  State<DuckGameScreen> createState() => _DuckGameScreenState();
}

class _DuckGameScreenState extends State<DuckGameScreen> with SingleTickerProviderStateMixin {
  final String game = 'Duck Game';

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  late Color targetColor;
  int currentLevel = 0;
  int correctPresses = 0;
  int winCount = 0;
  final List<Duck> ducks = [];
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
      for (var duck in ducks) {
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
      ducks.clear();
      
      // Calculate speed multiplier based on level (starts at 1.0 and increases by 0.5 each level)
      double speedMultiplier = 1.0 + (currentLevel * 0.5);
      
      // First, add 3 ducks of the target color
      for (int i = 0; i < 3; i++) {
        ducks.add(Duck(
          color: targetColor,
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
      
      // Then add 7 more ducks with random colors
      for (int i = 0; i < 7; i++) {
        ducks.add(Duck(
          color: colors[random.nextInt(colors.length)],
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
      
      // Shuffle the ducks to mix up their positions
      ducks.shuffle(random);
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
        title: Text('Duck Game - Level ${currentLevel + 1}'),
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
                  'Find the ${_getColorName(targetColor)} ducks!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: targetColor,
                  ),
                ),
              ),
            ),
          ),

          // Ducks
          ...ducks.map((duck) => Positioned(
            left: duck.position.dx,
            top: duck.position.dy,
            child: GestureDetector(
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
                width: 50,
                height: 50,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/duck2.svg',
                    colorFilter: ColorFilter.mode(
                      duck.color,
                      BlendMode.srcIn,
                    ),
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
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
                bool tappedOnDuck = ducks.any((duck) {
                  final duckRect = Rect.fromLTWH(
                    duck.position.dx,
                    duck.position.dy,
                    50,
                    50,
                  );
                  return duckRect.contains(details.localPosition);
                });

                if (!tappedOnDuck) {
                  _playSound("sounds/flip.mp3");
                } else {
                  // Find the duck that was tapped
                  final tappedDuck = ducks.firstWhere((duck) {
                    final duckRect = Rect.fromLTWH(
                      duck.position.dx,
                      duck.position.dy,
                      50,
                      50,
                    );
                    return duckRect.contains(details.localPosition);
                  });

                  if (tappedDuck.color == targetColor) {
                    _playSound("sounds/success.mp3");
                    setState(() {
                      // Remove the tapped duck
                      ducks.remove(tappedDuck);
                      
                      // Add a new duck with random color
                      ducks.add(Duck(
                        color: colors[random.nextInt(colors.length)],
                        position: Offset(
                          random.nextDouble() * 300,
                          random.nextDouble() * 500,
                        ),
                        speed: Offset(
                          (random.nextDouble() - 0.5) * 2,
                          (random.nextDouble() - 0.5) * 2,
                        ),
                      ));
                      
                      // Check if we still have at least one target color duck
                      bool hasTargetColorDuck = ducks.any((duck) => duck.color == targetColor);
                      
                      // If no target color ducks left, replace one random duck with target color
                      if (!hasTargetColorDuck) {
                        final randomIndex = random.nextInt(ducks.length);
                        ducks[randomIndex] = Duck(
                          color: targetColor,
                          position: ducks[randomIndex].position,
                          speed: ducks[randomIndex].speed,
                        );
                      }
                      
                      correctPresses++;
                      if (correctPresses >= maxCorrectTaps) {
                        if (currentLevel < colors.length - 1) {
                          ///VICTORY
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

class Duck {
  final Color color;
  Offset position;
  Offset speed;

  Duck({
    required this.color,
    required this.position,
    required this.speed,
  });
} 