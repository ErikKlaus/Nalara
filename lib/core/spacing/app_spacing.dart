import 'package:flutter/widgets.dart';

class AppSpacing {
  AppSpacing._();

  static const double micro = 4;
  static const double xs = 8;
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 32;
  static const double xl = 40;
  static const double xxl = 48;

  static const EdgeInsets screen = EdgeInsets.all(md);
  static const EdgeInsets screenCompact = EdgeInsets.all(sm);
  static const EdgeInsets card = EdgeInsets.all(sm);
  static const EdgeInsets cardLarge = EdgeInsets.all(md);
  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}
