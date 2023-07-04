import 'package:flutter/material.dart';

class ChartData {
  ChartData(this.x, this.y, [this.color = Colors.blue]);
  final String x;
  final double y;
  final Color color;
}