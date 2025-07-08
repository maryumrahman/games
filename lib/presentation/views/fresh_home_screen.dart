import 'package:flutter/material.dart';
import 'package:games/infrastructure/routes/navigation_helper.dart';

import 'fresh_choose_games_screen.dart';
import 'fresh_reading_game_screen.dart';



class FoxWidget extends StatelessWidget {
  const FoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.orange,
      ),
      child: const Icon(
        Icons.pets,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}


class FreshHomeScreen extends StatefulWidget {
  const FreshHomeScreen({super.key});

  @override
  State<FreshHomeScreen> createState() => _FreshHomeScreenState();
}

class _FreshHomeScreenState extends State<FreshHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _swayController;
  late Animation<double> _swayAnimation;

  @override
  void initState() {
    super.initState();
    _setupSwayAnimation();
    _startSwayAnimation();
  }

  void _setupSwayAnimation() {
    _swayController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _swayAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(
        parent: _swayController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startSwayAnimation() {
    _swayController.forward();

    _swayController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _swayController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(seconds: 20), () {
          if (mounted) {
            _swayController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _swayController.dispose();
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
              _buildReadingContent(),
              const SizedBox(height: 40),
              _buildAgeSelectors(),
              const Spacer(),
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
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Text(
            'Level 3',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.volume_up, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildReadingContent() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _swayAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _swayAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'BrightFox',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Hero(
              tag: 'fox',
              child: FoxWidget(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tap to hear me!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.play_circle_fill, color: Colors.green, size: 50),
                Icon(Icons.volume_up, color: Colors.grey, size: 50),
                Icon(Icons.pause_circle_filled, color: Colors.purple, size: 50),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Learning\nThrough Play',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeSelectors() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(                       onTap: () => _navigateToGamesScreen(),
    child: _buildAgeSelector('3-5 Years', Colors.pink)),
        _buildAgeSelector('6-8 Years', Colors.green),
      ],
    );
  }

  void _navigateToGamesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FreshChooseGamesScreen(),
      ),
    );
  }

  Widget _buildAgeSelector(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school,
              size: 30,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'START',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

////////////
