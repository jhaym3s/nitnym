import 'package:flutter/material.dart';
import '../../core/constants.dart';


Future<T?> pushScreen<T>(BuildContext context, Widget screen) {
  return Navigator.of(context).push<T>(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: AppDurations.page,
      reverseTransitionDuration: AppDurations.page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          )),
          child: child,
        );
      },
    ),
  );
}


Future<T?> pushUpScreen<T>(BuildContext context, Widget screen) {
  return Navigator.of(context).push<T>(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: AppDurations.page,
      reverseTransitionDuration: AppDurations.page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    ),
  );
}