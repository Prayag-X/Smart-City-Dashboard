import 'package:flutter/material.dart';

abstract class Themes {
  Color get normalColor;
  Color get oppositeColor;
  Color get tabBarColor;
  Color get highlightColor;
}

class ThemesDark implements Themes {
  @override
  final Color normalColor = const Color(0xFF15151A);
  @override
  final Color oppositeColor = Colors.white;
  @override
  final Color tabBarColor = const Color(0xFF1E2026);
  @override
  final Color highlightColor = const Color(0xFF252F52);
}

class ThemesLight implements Themes {
  @override
  final Color normalColor = const Color(0xFF585869);
  @override
  final Color oppositeColor = const Color(0xFFFFFFFF);
  @override
  final Color tabBarColor = const Color(0xFF3E4954);
  @override
  final Color highlightColor = const Color(0xFF555D85);
}
