import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/text_styles.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/helper.dart';
import '../../../../constants/constants.dart';
import '../../../../constants/theme.dart';
import '../../../../providers/settings_providers.dart';

class DashboardLineChart extends ConsumerStatefulWidget {
  const DashboardLineChart(
      {super.key,
      required this.title,
      required this.chartData,
      required this.points,
      this.minX = 0,
      this.minY = 0,
      this.maxX = 20,
      this.maxY = 10,
      required this.markerY,
      required this.markerX,
      this.markerIntervalX = 5,
      this.markerIntervalY = 2,
      required this.legendX,
      required this.barWidth});

  final String title;
  final String legendX;
  final double barWidth;
  final Map<String, Color> chartData;
  final List<List<FlSpot>> points;
  final List<String> markerX;
  final List<List<String>> markerY;
  final int markerIntervalX;
  final int markerIntervalY;
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  @override
  ConsumerState<DashboardLineChart> createState() => _DashboardLineChartState();
}

class _DashboardLineChartState extends ConsumerState<DashboardLineChart> {
  Color lightColor =
      lightenColor(ThemesDark().highlightColor, 0.1).withOpacity(0.5);
  Color darkColor =
      lightenColor(ThemesDark().highlightColor, 0.1).withOpacity(0.5);

  LineChart lineChartCustom() => LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: darkColor,
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
    Widget marker = Container();
    if ((value.toInt() - 1) % widget.markerIntervalY == 0 &&
        value.toInt() != widget.maxY) {
      marker = Column(
        children: widget.markerY[value.toInt()]
            .map((marker) => Text(marker,
                style: textStyleNormal.copyWith(
                    fontSize: Const.dashboardChartTextSize - 5,
                    color: widget.chartData.values.elementAt(
                        widget.markerY[value.toInt()].indexOf(marker))),
                textAlign: TextAlign.center))
            .toList(),
      );
    }

    return marker;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String marker = '';
    if ((value.toInt()) % widget.markerIntervalX == 0 &&
        value.toInt() != widget.maxX) {
      marker = widget.markerX[value.toInt()];
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(
        marker,
        style: textStyleNormal.copyWith(
            fontSize: Const.dashboardChartTextSize - 5,
            color: lightenColor(ThemesDark().highlightColor, 0.4)),
      ),
    );
  }

  LineChartBarData lineChartBarData(Color color, List<FlSpot> points) =>
      LineChartBarData(
        isCurved: true,
        color: color,
        barWidth: widget.barWidth,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: points,
      );

  @override
  Widget build(BuildContext context) {
    Themes themes = ref.watch(themesProvider);
    return Container(
      width: (screenSize(context).width -
              screenSize(context).width / Const.tabBarWidthDivider) /
          2,
      height: (screenSize(context).width -
              screenSize(context).width / Const.tabBarWidthDivider) *
          Const.dashboardUIHeightFactor /
          2,
      decoration: BoxDecoration(
        color: themes.highlightColor,
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
                  fontSize: Const.dashboardChartTextSize - 3,
                  color: Colors.white.withOpacity(0.5)),
            ),
            SizedBox(
                height: (screenSize(context).width -
                        screenSize(context).width / Const.tabBarWidthDivider) *
                    Const.dashboardUIHeightFactor *
                    0.6 /
                    2,
                child: lineChartCustom()),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Row(
                children: [
                  Row(
                    children: widget.chartData.entries
                        .map((entry) => Row(
                              children: [
                                Container(
                                  width: Const.dashboardChartTextSize - 7,
                                  height: Const.dashboardChartTextSize - 7,
                                  decoration: BoxDecoration(
                                      color: entry.value,
                                      borderRadius:
                                          BorderRadius.circular(35.0)),
                                ),
                                5.pw,
                                Text(
                                  entry.key,
                                  style: textStyleNormal.copyWith(
                                      color: themes.oppositeColor,
                                      fontSize:
                                          Const.dashboardChartTextSize - 3),
                                ),
                                15.pw,
                              ],
                            ))
                        .toList(),
                  ),
                  Row(
                    children: [
                      Container(
                        width: Const.dashboardChartTextSize - 7,
                        height: Const.dashboardChartTextSize - 7,
                        decoration: BoxDecoration(
                            color: lightenColor(ThemesDark().highlightColor, 0.3),
                            borderRadius: BorderRadius.circular(35.0)),
                      ),
                      5.pw,
                      Text(
                        widget.legendX,
                        style: textStyleNormal.copyWith(
                            color: themes.oppositeColor,
                            fontSize: Const.dashboardChartTextSize - 3),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class VisualizerLineChart extends ConsumerStatefulWidget {
  const VisualizerLineChart(
      {super.key,
      required this.chartColors,
      required this.points,
      this.minX = 0,
      this.minY = 0,
      this.maxX = 20,
      this.maxY = 10,
      required this.markerY,
      required this.markerX,
      this.markerIntervalX = 5,
      this.markerIntervalY = 2,
      required this.barWidth});

  final double barWidth;
  final List<Color> chartColors;
  final List<List<FlSpot>> points;
  final List<String> markerX;
  final List<List<String>> markerY;
  final int markerIntervalX;
  final int markerIntervalY;
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  @override
  ConsumerState<VisualizerLineChart> createState() =>
      _VisualizerLineChartState();
}

class _VisualizerLineChartState extends ConsumerState<VisualizerLineChart> {
  Color lightColor =
      lightenColor(ThemesDark().highlightColor, 0.1).withOpacity(0.5);
  Color darkColor =
      lightenColor(ThemesDark().highlightColor, 0.1).withOpacity(0.5);

  LineChart lineChartCustom() => LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: darkColor,
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
                  widget.chartColors[widget.points.indexOf(chartPoint)],
                  chartPoint))
              .toList(),
          minX: widget.minX,
          maxX: widget.maxX,
          minY: widget.minY,
          maxY: widget.maxY,
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    Widget marker = Container();
    if ((value.toInt() - 1) % widget.markerIntervalY == 0 &&
        value.toInt() != widget.maxY) {
      marker = Column(
        children: widget.markerY[value.toInt()]
            .map((marker) => Text(marker,
                style: textStyleNormal.copyWith(
                    fontSize: Const.dashboardChartTextSize - 5,
                    color: widget.chartColors[
                        widget.markerY[value.toInt()].indexOf(marker)]),
                textAlign: TextAlign.center))
            .toList(),
      );
    }

    return marker;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String marker = '';
    if ((value.toInt()) % widget.markerIntervalX == 0 &&
        value.toInt() != widget.maxX) {
      marker = widget.markerX[value.toInt()];
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(
        marker,
        style: textStyleNormal.copyWith(
            fontSize: Const.dashboardChartTextSize - 5,
            color: lightenColor(ThemesDark().highlightColor, 0.4)),
      ),
    );
  }

  LineChartBarData lineChartBarData(Color color, List<FlSpot> points) =>
      LineChartBarData(
        isCurved: true,
        color: color,
        barWidth: widget.barWidth,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: points,
      );

  @override
  Widget build(BuildContext context) {
    Themes themes = ref.watch(themesProvider);
    return Container(
      width: screenSize(context).width * 0.8 -
          screenSize(context).width / Const.tabBarWidthDivider,
      height: (screenSize(context).width -
              screenSize(context).width / Const.tabBarWidthDivider) *
          Const.dashboardUIHeightFactor * 0.7,
      decoration: BoxDecoration(
        color: themes.highlightColor,
        borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
        child: SizedBox(
            height: (screenSize(context).width -
                    screenSize(context).width / Const.tabBarWidthDivider) *
                Const.dashboardUIHeightFactor *
                0.6 /
                2,
            child: lineChartCustom()),
      ),
    );
  }
}
