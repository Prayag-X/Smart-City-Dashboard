import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/utils/helper.dart';

import '../../../../constants/texts.dart';
import 'line_chart.dart';

class LineChartParser {
  late String title;
  String legendX;
  late Map<String, Color> chartData;
  double barWidth;
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

  LineChartParser(
      {required this.title,
      required this.chartData,
      this.legendX = '',
      this.barWidth = 8});

  Widget chartParser(
      {required List<dynamic> dataX,
      required List<List<dynamic>> dataY,
      int? limitMarkerX}) {
    List<List<double>> dataYNum = [];
    List<double> maxValuesY = [];
    List<double> minValuesY = [];
    List<double> intervalY = [];
    double minValueX = 0;

    for (int i = 0; i < dataY.length; i++) {
      dataYNum.add([]);
      points.add([]);
    }

    for (int i = 0; i < dataY.length; i++) {
      for (dynamic y in dataY[i]) {
        if (y == '') {
          dataYNum[i].add(0);
        } else {
          dataYNum[i].add(y.toDouble());
        }
      }
    }

    for (List<double> x in dataYNum) {
      double maxValue = x.reduce(max);
      double minValue = x.reduce(min);

      maxValuesY.add(maxValue);
      minValuesY.add(minValue);
      intervalY.add((maxValue - minValue) / maxY);
    }

    double intervalXFactor = dataX.length / maxX;

    for (int i = 0; i < maxX; i++) {
      if (shortenX) {
        markerX.add(dataX[(i * intervalXFactor).round()].toString());
      } else {
        markerX.add(limitMarkerX == null
            ? dataX[(i * intervalXFactor).round()].toString()
            : dataX[(i * intervalXFactor).round()]
                .toString()
                .substring(0, limitMarkerX));
      }
    }

    for (int i = 0; i < dataX.length; i++) {
      for (int j = 0; j < dataYNum.length; j++) {
        points[j].add(FlSpot(minValueX,
            roundDouble((dataYNum[j][i] - minValuesY[j]) / intervalY[j], 2)));
      }
      minValueX += 1 / intervalXFactor;
    }

    for (int i = 0; i < maxY; i++) {
      List<String> row = [];
      for (int j = 0; j < minValuesY.length; j++) {
        row.add(shortenNum(minValuesY[j]));
        minValuesY[j] += intervalY[j];
      }
      markerY.add(row);
    }

    return DashboardLineChart(
      title: title,
      legendX: legendX,
      chartData: chartData,
      points: points,
      markerY: markerY,
      markerX: markerX,
      maxX: maxX,
      maxY: maxY,
      markerIntervalX: markerIntervalX,
      markerIntervalY: markerIntervalY,
      barWidth: barWidth,
    );
  }

  Widget weatherHourlyDataParser(ForecastWeather weather, int day) {
    maxX = 24;
    markerIntervalX = 4;
    points = [[], []];

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

    return DashboardLineChart(
        title: TextConst.hourly,
        legendX: TextConst.time,
        chartData: chartData,
        points: points,
        markerY: markerY,
        markerX: markerX,
        maxX: maxX,
        maxY: maxY,
        markerIntervalX: markerIntervalX,
        markerIntervalY: markerIntervalY,
        barWidth: barWidth);
  }
}
