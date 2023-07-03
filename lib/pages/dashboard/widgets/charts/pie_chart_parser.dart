import 'package:flutter/material.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/pie_chart.dart';

class PieChartParser {
  late String title;
  late String subTitle;
  List<String> headers = [];
  List<double> percentages = [];

  PieChartParser({required this.title, required this.subTitle});

  Widget chartParser({required List<dynamic> data}) {
    List<int> frequency = [];

    for (var x in data) {
      if (headers.contains(x.toString())) {
        frequency[headers.indexOf(x.toString())]++;
      } else {
        headers.add(x.toString());
        frequency.add(0);
      }
    }

    for (int freq in frequency) {
      percentages.add(freq / data.length * 100);
    }

    return DashboardPieChart(
      title: title,
      subTitle: subTitle,
      headers: headers,
      percentages: percentages,
      total: data.length,
    );
  }
}
