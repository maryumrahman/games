import 'package:flutter/material.dart';
import 'package:games/presentation/views/fresh_reading_game_screen.dart';

import 'fresh_home_screen.dart';

class FreshChooseGamesScreen extends StatefulWidget {
  const FreshChooseGamesScreen({super.key});

  @override
  State<FreshChooseGamesScreen> createState() => _FreshChooseGamesScreenState();
}

class _FreshChooseGamesScreenState extends State<FreshChooseGamesScreen>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _glowController;
  late Animation<double> _numbersAnimation;
  late Animation<double> _puzzlesAnimation;
  late Animation<double> _readingAnimation;
  late Animation<double> _drawingAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _numbersAnimation = Tween<double>(begin: -300, end: 0).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _puzzlesAnimation = Tween<double>(begin: -300, end: 0).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: const Interval(0.1, 0.5, curve: Curves.elasticOut),
      ),
    );

    _readingAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
      ),
    );

    _drawingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimations() {
    _cardController.forward();
    _glowController.forward();

    // Repeat glow every 10 seconds
    _glowController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 10), () {
          if (mounted) {
            _glowController.reset();
            _glowController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _cardController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB),
              Color(0xFF00BFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 40),
              _buildMainContent(),
              const Spacer(),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'For ages 3-5',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Hero(
            tag: 'fox',
            child: FoxWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'What do you\nwant to do?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildAnimatedCard(
                    _numbersAnimation,
                    const NumbersCard(),
                    isTranslation: true,
                  ),
                  _buildAnimatedCard(
                    _readingAnimation,
                    ReadingCard(
                      onTap: () => _navigateToReading(),
                    ),
                    isTranslation: false,
                  ),
                  _buildAnimatedCard(
                    _puzzlesAnimation,
                    const PuzzlesCard(),
                    isTranslation: true,
                  ),
                  _buildAnimatedCard(
                    _drawingAnimation,
                    const DrawingCard(),
                    isTranslation: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(
      Animation<double> animation,
      Widget card,
      {required bool isTranslation}
      ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        if (isTranslation) {
          return Transform.translate(
            offset: Offset(animation.value, 0),
            child: card,
          );
        } else {
          if (card is DrawingCard) {
            return Transform.rotate(
              angle: (1 - animation.value) * 6.28,
              child: card,
            );
          } else {
            return Transform.translate(
              offset: Offset(0, animation.value),
              child: card,
            );
          }
        }
      },
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.apps, color: Colors.white, size: 30),
          Icon(Icons.info_outline, color: Colors.white, size: 30),
        ],
      ),
    );
  }

  void _navigateToReading() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FreshLevel3ReadingScreen(),
      ),
    );
  }
}




///TO DO: MAEK SEPERATE FILE FOR THESE:
///


class NumbersCard extends StatelessWidget {
  const NumbersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '123',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Numbers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class ReadingCard extends StatelessWidget {
  final VoidCallback onTap;

  const ReadingCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              'Reading',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PuzzlesCard extends StatelessWidget {
  const PuzzlesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.extension,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(height: 8),
          Text(
            'Puzzles',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingCard extends StatelessWidget {
  const DrawingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.brush,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(height: 8),
          Text(
            'Drawing',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
