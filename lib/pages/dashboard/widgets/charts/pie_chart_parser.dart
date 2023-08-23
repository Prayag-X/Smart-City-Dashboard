import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_city_dashboard/models/pie_chart_model.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/pie_chart.dart';

import '../../../../utils/helper.dart';
import '../dashboard_container.dart';

class PieChartParser {
  late String title;
  late String subTitle;
  List<ChartData> chartData = [];

  PieChartParser({required this.title, required this.subTitle});

  Widget chartParser({required List<dynamic>? data}) {
    if(data == null) {
      return const BlankDashboardContainer(
        heightMultiplier: 2,
        widthMultiplier: 2,
      );
    }

    List<int> frequency = [];
    List<String> headers = [];

    for (var x in data) {
      if (x.toString() == '') {
        x = 'Unknown';
      }
      if (headers.contains(x.toString())) {
        frequency[headers.indexOf(x.toString())]++;
      } else {
        headers.add(x.toString());
        frequency.add(0);
      }
    }

    for (int i = 0; i < headers.length; i++) {
      chartData.add(ChartData(
          headers[i],
          frequency[i] / data.length * 100,
          Random().nextInt(3) != 1
              ? Random().nextInt(3) != 1
                  ? lightenColor(
                      const Color(0xFF1A2A6B), Random().nextDouble() * 0.5)
                  : darkenColor(
                      const Color(0xFF003EFF), Random().nextDouble() * 0.3)
              : darkenColor(
                  const Color(0xFFFFCF00), Random().nextDouble() * 0.3)
          ));
    }

    for (int i = 0; i < chartData.length - 1; i++) {
      for (int j = 0; j < chartData.length - i - 1; j++) {
        if (chartData[j].y < chartData[j + 1].y) {
          ChartData temp = chartData[j];
          chartData[j] = chartData[j + 1];
          chartData[j + 1] = temp;
        }
      }
    }

    return DashboardPieChart(
      title: title,
      subTitle: subTitle,
      chartData: chartData,
      total: data.length,
    );
  }

  Widget chartParserForVisualizer({required List<dynamic> data}) {
    List<int> frequency = [];
    List<String> headers = [];

    for (var x in data) {
      if (x.toString() == '') {
        x = 'Unknown';
      }
      if (headers.contains(x.toString())) {
        frequency[headers.indexOf(x.toString())]++;
      } else {
        headers.add(x.toString());
        frequency.add(0);
      }
    }

    for (int i = 0; i < headers.length; i++) {
      chartData.add(ChartData(
          headers[i],
          frequency[i] / data.length * 100,
          Random().nextInt(3) != 1
              ? Random().nextInt(3) != 1
                  ? lightenColor(
                      const Color(0xFF1A2A6B), Random().nextDouble() * 0.5)
                  : darkenColor(
                      const Color(0xFF003EFF), Random().nextDouble() * 0.3)
              : darkenColor(
                  const Color(0xFFFFCF00), Random().nextDouble() * 0.3)
          ));
    }

    for (int i = 0; i < chartData.length - 1; i++) {
      for (int j = 0; j < chartData.length - i - 1; j++) {
        if (chartData[j].y < chartData[j + 1].y) {
          ChartData temp = chartData[j];
          chartData[j] = chartData[j + 1];
          chartData[j + 1] = temp;
        }
      }
    }

    return VisualizerPieChart(
      chartData: chartData,
    );
  }
}
