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
      if(x.toString() == '') {
        x = 'Unknown';
      }
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

    for (int i = 0; i < percentages.length - 1; i++) {
      for (int j = 0; j < percentages.length - i - 1; j++) {
        if (percentages[j] < percentages[j + 1]) {
          double temp = percentages[j];
          String temp2 = headers[j];
          percentages[j] = percentages[j + 1];
          headers[j] = headers[j + 1];
          percentages[j + 1] = temp;
          headers[j + 1] = temp2;
        }
      }
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
