import 'package:flutter/material.dart';

PageRouteBuilder<T> createFadeSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide =
          Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic))
              .animate(animation);
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return SlideTransition(
        position: slide,
        child: FadeTransition(opacity: fade, child: child),
      );
    },
  );
}
