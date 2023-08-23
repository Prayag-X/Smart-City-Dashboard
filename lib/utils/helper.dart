import 'dart:async';
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

Future waitWhile(bool Function() test,
    [Duration pollInterval = Duration.zero]) {
  var completer = Completer();
  check() {
    if (!test()) {
      completer.complete();
    } else {
      Timer(pollInterval, check);
    }
  }

  check();
  return completer.future;
}

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

Color invertColor(Color color) {
  final r = 255 - color.red;
  final g = 255 - color.green;
  final b = 255 - color.blue;

  return lightenColor(
      Color.fromARGB((color.opacity * 255).round(), r, g, b), 0.4);
}

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

String shortenNum(double value) {
  int length = value.toStringAsFixed(0).length;
  for (MapEntry<String, int> plot
      in {'B': 9, 'C': 8, 'M': 7, 'L': 6, 'K': 3}.entries) {
    if (length > plot.value) {
      return '${value.toStringAsFixed(0).substring(0, length - plot.value)}.${value.toStringAsFixed(0).substring(length - plot.value, length - plot.value + 1)}${plot.key}';
    }
  }
  return value.toStringAsFixed(1);
}

showSnackBar(
        {required BuildContext context,
        required String message,
        int duration = 3,
        Color color = Colors.green}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 14, color: color),
        ),
        backgroundColor: Colors.black.withOpacity(0.9),
        duration: Duration(seconds: duration),
      ),
    );
