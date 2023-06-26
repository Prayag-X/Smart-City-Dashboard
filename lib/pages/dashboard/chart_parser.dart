import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../../constants/texts.dart';
import 'dashboard_chart.dart';

class WeatherChartParser {
  late String title;
  late Map<String, Color> chartData;
  List<List<FlSpot>> points = [[], []];
  List<String> markerX = [];
  List<List<String>> markerY = [];
  double minX = 0;
  double minY = 0;
  double maxX = 25;
  double maxY = 10;
  int markerIntervalX = 4;
  int markerIntervalY = 4;

  Widget hourlyDataParser(
      {required List<dynamic> dataX, required List<List<num>> dataY}) {
    List<List<double>> dataArranged = [];
    List<double> maxValues = [];
    List<double> minValues = [];
    List<double> interval = [];

    for (int i = 0; i < dataY[0].length; i++) {
      dataArranged.add([]);
    }

    for (var x in dataY) {
      int c = 0;
      for (var y in x) {
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
   // this much
    List<double> temperatures = [];
    List<double> humidity = [];
    List<Hour> forecastData = weather.forecast.forecastday[day].hour;

    forecastData.asMap().forEach((index, data) {
      markerX.add(data.time.split(' ').last);
      temperatures.add(data.tempC);
      humidity.add(data.humidity.toDouble());
    });

    double maxTemp = temperatures.reduce(max);
    double minTemp = temperatures.reduce(min);
    double interval = (maxTemp - minTemp) / 10;
    double maxHumid = humidity.reduce(max);
    double minHumid = humidity.reduce(min);
    double intervalHumid = (maxHumid - minHumid) / 10;

    forecastData.asMap().forEach((index, data) {
      points[0].add(FlSpot(
          index.toDouble(), roundDouble((data.tempC - minTemp) / interval, 2)));
      points[1].add(FlSpot(
          index.toDouble(),
          roundDouble(
              (data.humidity.toDouble() - minHumid) / intervalHumid, 2)));
    });

    for (var i = 0; i < 10; i++) {
      markerY.add([minTemp.toStringAsFixed(1), minHumid.toStringAsFixed(1)]);
      minTemp += interval;
      minHumid += intervalHumid;
    }

    return DashboardChart(
        title: TextConst.hourly,
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
