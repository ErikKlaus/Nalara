import 'package:flutter/widgets.dart';

class AppTokens {
  AppTokens._();

  static const double minTouchTarget = 48;
  static const double maxContentWidth = 760;
  static const double maxWideContentWidth = 1120;
  static const double navigationRailBreakpoint = 900;

  static const Duration quickMotion = Duration(milliseconds: 180);
  static const Duration standardMotion = Duration(milliseconds: 260);

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x0F0F172A), blurRadius: 24, offset: Offset(0, 8)),
  ];
}
