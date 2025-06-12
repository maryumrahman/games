import 'package:flutter/material.dart';
import 'slide_game_route.dart';

extension NavigationExtensions on BuildContext {
  Future<T?> pushGameScreen<T>(Widget page, {String? heroTag}) {
    return Navigator.push<T>(
      this,
      SlideGameRoute<T>(
        page: page,
        heroTag: heroTag,
      ),
    );
  }

  Future<T?> replaceWithGameScreen<T>(Widget page, {String? heroTag}) {
    return Navigator.pushReplacement(
      this,
      SlideGameRoute<T>(
        page: page,
        heroTag: heroTag,
      ),
    );
  }
} 