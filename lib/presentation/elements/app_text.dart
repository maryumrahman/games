import 'package:flutter/material.dart';

class AppText extends StatelessWidget {

  final String text;
  final int? maxLines;
  final double? fontSize;
  final Color? color;
  const AppText({super.key, required this.text, required this.maxLines, required this.fontSize, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text, maxLines: maxLines??2, style: TextStyle(fontSize: fontSize, color: color  ),
    );
  }
}
