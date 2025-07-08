import 'package:flutter/material.dart';

class SlideGameRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final String? heroTag;

  SlideGameRoute({
    required this.page,
    this.heroTag,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            // Slide animation
            var slideAnimation = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            );

            // Scale animation
            var scaleAnimation = Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            );

            // Fade animation
            var fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
            );

            return Stack(
              children: [
                // Add a fade-in background
                FadeTransition(
                  opacity: fadeAnimation,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                // Combine slide and scale animations
                SlideTransition(
                  position: slideAnimation,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: child,
                  ),
                ),
              ],
            );
          },
          // Customize transition duration
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          // Add iOS-style page curve
          barrierColor: Colors.black12,
          opaque: true,
          maintainState: true,
        );

  Route createRoute(BuildContext context) {
    return this;
  }
} 