import 'dart:math';

import 'package:flutter/material.dart';

Size screenSize(context) => MediaQuery.of(context).size;

double bottomInsets(context) => MediaQuery.of(context).viewInsets.bottom;

double statusBarSize(context) => MediaQuery.of(context).viewPadding.top;

nextScreen(context, String pageName) async =>
    await Navigator.pushNamed(context, '/$pageName');

nextScreenReplace(context, String pageName) async =>
    await Navigator.pushReplacementNamed(context, '/$pageName');

nextScreenOnly(context, String pageName) async => await Navigator.of(context)
    .pushNamedAndRemoveUntil('/$pageName', ModalRoute.withName('/'));

screenPop(context) => Navigator.of(context).pop();

Color darkenColor(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

Color lightenColor(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslLight.toColor();
}

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

showSnackBar(context, String message, int duration) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: Colors.black54,
        duration: Duration(seconds: duration),
      ),
    );
