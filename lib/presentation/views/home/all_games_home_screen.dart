import 'package:flutter/material.dart';
import 'package:games/presentation/views/coming_soon/coming_soon.dart';
import '../../../generated/assets.dart';
import '../memory_cards_game/memory_cards_game.dart';
import '../duck_game/duck_game.dart';
import '../words_game/sight_words_arabic_game.dart';
import 'game_item_card.dart';

class AllGamesHomeScreen extends StatelessWidget {
  final Function(Widget) onGameSelected;

  const AllGamesHomeScreen({
    super.key,
    required this.onGameSelected,
  });

  @override
  Widget build(BuildContext context) {
    final games = [
      {
        'title': 'Memory Game',
        'description': 'Test your memory by matching pairs of cards!',
        'image': 'https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?q=80&w=500',
        'icon': Icons.grid_view_rounded,
        'isComingSoon': false,
        'gameWidget': const MemoryCardsGame(),
      },
      {
        'title': 'TicTacToe',
        'description': 'Classic game of X\'s and O\'s!',
        'image': 'https://images.unsplash.com/photo-1611996575749-79a3a250f948?q=80&w=500',
        'icon': Icons.close,
        'isComingSoon': true,
        'gameWidget': const ComingSoon(),
      },
      {
        'title': 'Duck Game',
        'description': 'Tap the colored Duck!',
        'image': 'https://images.unsplash.com/photo-1611996575749-79a3a250f948?q=80&w=500',
        'icon':  Icons.pets,
        'isComingSoon': false,
        'gameWidget': const DuckGameScreen(),
      },
      {
        'title': 'Arabic Words Game',
        'description': 'Tap the colored Word!',
        'image': 'https://images.unsplash.com/photo-1611996575749-79a3a250f948?q=80&w=500',
        'icon': Icons.abc,
        'isComingSoon': false,
        'gameWidget': const WordsGameScreen(),
      },
      // Add more games here as needed
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade50,
              Colors.white,
              Colors.teal.shade50,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Game Center',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.teal.shade400,
                        Colors.teal.shade200,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.games,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final game = games[index];
                    return Hero(
                      tag: 'game-${game['title']}',
                      child: GameItemCard(
                        title: game['title'] as String,
                        description: game['description'] as String,
                        imageUrl: game['image'] as String,
                        gameIcon: game['icon'] as IconData,
                        isComingSoon: game['isComingSoon'] as bool,
                        onTap: () {
                          if (game['isComingSoon'] as bool) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${game['title']} coming soon!"),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          } else {
                            onGameSelected(game['gameWidget'] as Widget);
                          }
                        },
                      ),
                    );
                  },
                  childCount: games.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
