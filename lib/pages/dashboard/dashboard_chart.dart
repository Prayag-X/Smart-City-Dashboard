import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/models/realtime_weather.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/services/weather_api.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../constants/constants.dart';
import '../../constants/texts.dart';
import '../../constants/theme.dart';
import '../../providers/settings_providers.dart';
import '../../ssh_lg/ssh.dart';

class DashboardChart extends StatefulWidget {
  const DashboardChart(
      {super.key,
      required this.title,
      required this.chartData,
      required this.points,
      this.minX = 0,
      this.minY = 0,
      this.maxX = 20,
      this.maxY = 10,
      required this.verticalMarkers,
      required this.horizontalMarkers,
      this.markerIntervalX = 5,
      this.markerIntervalY = 2});

  final String title;
  final Map<String, Color> chartData;
  final List<List<FlSpot>> points;
  final List<String> verticalMarkers;
  final List<String> horizontalMarkers;
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;
  final int markerIntervalX;
  final int markerIntervalY;

  @override
  State<DashboardChart> createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
  Color lightColor =
      lightenColor(Themes.darkHighlightColor, 0.1).withOpacity(0.5);

  LineChart lineChartCustom() => LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: lightColor,
            ),
          ),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: lightColor,
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: lightColor,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                interval: 1,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 1,
                getTitlesWidget: leftTitleWidgets,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: lightColor, width: 4),
              left: BorderSide(color: lightColor, width: 4),
              right: BorderSide(color: lightColor, width: 1),
              top: BorderSide(color: lightColor, width: 1),
            ),
          ),
          lineBarsData: widget.points
              .map((chartPoint) => lineChartBarData(
                  widget.chartData.values
                      .elementAt(widget.points.indexOf(chartPoint)),
                  chartPoint))
              .toList(),
          minX: widget.minX,
          maxX: widget.maxX,
          minY: widget.minY,
          maxY: widget.maxY,
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String marker = '';
    if ((value.toInt() - 1) % widget.markerIntervalY == 0) {
      marker = widget.verticalMarkers[value.toInt()];
    }

    return Text(marker,
        style: textStyleNormalWhite.copyWith(fontSize: 15),
        textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String marker = '';
    if ((value.toInt() - 1) % widget.markerIntervalX == 0) {
      marker = widget.verticalMarkers[value.toInt()];
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(
        marker,
        style: textStyleNormalWhite.copyWith(fontSize: 15),
      ),
    );
  }

  LineChartBarData lineChartBarData(Color color, List<FlSpot> points) =>
      LineChartBarData(
        isCurved: true,
        color: color,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: points,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (screenSize(context).width - Const.tabBarWidth) / 2,
      height: (screenSize(context).width - Const.tabBarWidth) *
          Const.dashboardUIHeightFactor /
          2,
      decoration: BoxDecoration(
        color: Themes.darkHighlightColor,
        borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: textStyleNormal.copyWith(
                  fontSize: 17, color: Colors.white.withOpacity(0.5)),
            ),
            SizedBox(
                height: (screenSize(context).width - Const.tabBarWidth) *
                    Const.dashboardUIHeightFactor *
                    0.7 /
                    2,
                child: lineChartCustom()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.chartData.entries
                  .map((entry) => Row(
                        children: [
                          Container(
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(
                                color: entry.value,
                                borderRadius: BorderRadius.circular(35.0)),
                          ),
                          5.pw,
                          Text(
                            entry.key,
                            style: textStyleNormal.copyWith(
                                fontSize: 17,
                                color: Colors.white.withOpacity(0.8)),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
