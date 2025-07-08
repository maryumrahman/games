import 'package:flutter/material.dart';
import 'home/all_games_home_screen.dart';
import 'scoreboard/scoreboard.dart';
import 'login/login_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 1; // Start with home tab
  Widget? _activeGame;

  void setActiveGame(Widget game) {
    setState(() {
      _activeGame = game;
      _selectedIndex = 0; // Switch to game tab
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _activeGame ?? const NoActiveGameScreen(),
      AllGamesHomeScreen(onGameSelected: setActiveGame),
      const ScoreboardScreen(),
      const LoginScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeInOut,
        child:       _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0 && _activeGame == null) {
            // If trying to go to game tab with no active game
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Start a game from the Home tab first!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Current Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.scoreboard),
            label: 'Scoreboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Login',
          ),
        ],
      ),
    );
  }
}

class NoActiveGameScreen extends StatelessWidget {
  const NoActiveGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_esports_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No game in progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start a game from the Home tab!',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
} 