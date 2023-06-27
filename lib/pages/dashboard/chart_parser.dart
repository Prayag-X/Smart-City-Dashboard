import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../../constants/texts.dart';
import 'dashboard_chart.dart';

class ChartParser {
  late String title;
  late Map<String, Color> chartData;
  List<List<FlSpot>> points = [];
  List<String> markerX = [];
  List<List<String>> markerY = [];
  bool shortenX = false;
  double minX = 0;
  double minY = 0;
  double maxX = 25;
  double maxY = 10;
  int markerIntervalX = 4;
  int markerIntervalY = 4;

  Widget chartParser(
      {required List<dynamic> dataX, required List<List<num>> dataY}) {
    List<List<double>> dataArranged = [];
    List<double> maxValues = [];
    List<double> minValues = [];
    List<double> interval = [];

    for (int i = 0; i < dataY[0].length; i++) {
      dataArranged.add([]);
      points.add([]);
    }

    for (List<num> x in dataY) {
      int c = 0;
      for (num y in x) {
        dataArranged[c++].add(y.toDouble());
      }
    }

    for (List<double> x in dataArranged) {
      double maxValue = x.reduce(max);
      double minValue = x.reduce(min);

      maxValues.add(maxValue);
      minValues.add(minValue);
      interval.add((maxValue - minValue) / maxY);
    }

    double intervalXFactor = dataX.length / maxX;

    for (int i = 0; i < maxX; i++) {
      if (shortenX) {
        markerX.add(shortenNum(dataX[(i * intervalXFactor).round()]));
      } else {
        markerX.add(dataX[(i * intervalXFactor).round()].toString());
      }
    }

    for (int i = 0; i < dataX.length; i++) {
      for (int j = 0; j < dataArranged.length; j++) {
        points[j].add(FlSpot(dataX[i].toDouble(),
            roundDouble((dataArranged[j][i] - minValues[j]) / interval[j], 2)));
      }
    }

    for (int i = 0; i < maxY; i++) {
      List<String> row = [];
      for (int j = 0; j < minValues.length; j++) {
        row.add(shortenNum(minValues[j]));
        minValues[j] += interval[j];
      }
      markerY.add(row);
    }

    return DashboardChart(
        title: title,
        chartData: chartData,
        points: points,
        markerY: markerY,
        markerX: markerX,
        maxX: maxX,
        maxY: maxY,
        markerIntervalX: markerIntervalX,
        markerIntervalY: markerIntervalY);
  }
}
