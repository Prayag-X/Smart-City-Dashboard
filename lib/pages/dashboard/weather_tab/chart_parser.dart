import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/models/realtime_weather.dart';
import 'package:smart_city_dashboard/pages/dashboard/dashboard_container.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/services/weather_api.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';

import '../../../constants/constants.dart';
import '../../../constants/texts.dart';
import '../../../constants/theme.dart';
import '../../../providers/settings_providers.dart';
import '../../../ssh_lg/ssh.dart';
import '../dashboard_chart.dart';

class ChartParser {
  late String title;
  Map<String, Color> chartData = {
    TextConst.temperature: Colors.red,
    TextConst.humidity: Colors.blue
  };
  List<List<FlSpot>> points = [[], []];
  List<String> markerX = [];
  List<List<String>> markerY = [];
  double minX = 0;
  double minY = 0;
  double maxX = 24;
  double maxY = 10;
  int markerIntervalX = 4;
  int markerIntervalY = 4;

  Widget hourlyDataParser(ForecastWeather weather, int day) {
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

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
