import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

import '../../elements/game_card.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GameScreen()),
              ),
              child: const Text('Play Memory Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("TicTacToe coming soon!")),
                );
              },
              child: const Text('TicTacToe (Coming Soon)'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> emojis = ['🍎', '🎲', '🚗', '🐶', '🏀', '🎧'];
  late List<GameCard> cards;
  GameCard? firstFlipped;
  String? bgImageUrl;
  final AudioPlayer _player = AudioPlayer();
  int matchedPairs = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
    _fetchBackgroundImage();
  }

  void _initGame() {
    matchedPairs = 0;
    final contents = [...emojis, ...emojis];
    contents.shuffle();
    cards = List.generate(contents.length,
            (i) => GameCard(id: i, content: contents[i], isFlipped: false));
  }

  Future<void> _fetchBackgroundImage() async {
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/random?query=games&client_id=YOUR_ACCESS_KEY'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        bgImageUrl = data['urls']['regular'];
      });
    }
  }

  void _playSound(String asset) {
    _player.play(AssetSource(asset));
  }

  void _onCardTap(int index) async {
    if (cards[index].isFlipped || cards[index].isMatched) return;

    setState(() {
      cards[index].isFlipped = true;
    });
    _playSound("sounds/flip.mp3");

    if (firstFlipped == null) {
      firstFlipped = cards[index];
    } else {
      if (firstFlipped!.content == cards[index].content) {
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
          cards[index].isMatched = true;
          firstFlipped!.isMatched = true;
          matchedPairs++;
        });
        _playSound("sounds/success.mp3");

        if (matchedPairs == emojis.length) {
          Future.delayed(const Duration(milliseconds: 600), _showVictoryDialog);
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 600));
        setState(() {
          cards[index].isFlipped = false;
          firstFlipped!.isFlipped = false;
        });
      }
      firstFlipped = null;
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Congratulations!"),
        content: const Text("You've completed the game! 🎉"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _initGame());
            },
            child: const Text("Play Again"),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final totalPairs = emojis.length;
    final progress = matchedPairs / totalPairs;

    return Scaffold(
      body: Stack(
        children: [
          if (bgImageUrl != null)
            Positioned.fill(
              child: Image.network(
                bgImageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.teal.shade200, width: 2),
                    ),
                    child: GridView.builder(
                      itemCount: cards.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size.width > 600 ? 6 : 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        return CardWidget(
                          card: cards[index],
                          onTap: () => _onCardTap(index),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
