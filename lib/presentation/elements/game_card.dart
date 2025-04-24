
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameCard {
  final int id;
  final String content;
  bool isFlipped;
  bool isMatched;

  GameCard({
    required this.id,
    required this.content,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class CardWidget extends StatefulWidget {
  final GameCard card;
  final VoidCallback onTap;

  const CardWidget({super.key, required this.card, required this.onTap});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> with SingleTickerProviderStateMixin {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: card.isFlipped || card.isMatched ? Colors.white : Colors.teal,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: hovered ? Colors.black26 : Colors.black12,
                blurRadius: hovered ? 12 : 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: card.isFlipped || card.isMatched ? 1 : 0,
              child: Text(
                card.content,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
