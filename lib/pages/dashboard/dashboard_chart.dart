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

class LineChartCustom extends StatelessWidget {
  const LineChartCustom({super.key});

  @override
  Widget build(BuildContext context) {
    Color lightColor = lightenColor(Themes.darkHighlightColor, 0.1).withOpacity(0.5);
    return LineChart(
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
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              getTitlesWidget: leftTitleWidgets,
              showTitles: true,
              interval: 1,
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
                color: lightColor, width: 4),
            left: BorderSide(
                color: lightColor, width: 4),
            right: BorderSide(color: lightColor, width: 1),
            top: BorderSide(color: lightColor, width: 1),
          ),
        ),
        lineBarsData: [
          lineChartBarData1_1,
          lineChartBarData1_2,
        ],
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1m';
        break;
      case 2:
        text = '2m';
        break;
      case 3:
        text = '3m';
        break;
      case 4:
        text = '5m';
        break;
      case 5:
        text = '6m';
        break;
      default:
        return Container();
    }

    return Text(text, style: textStyleNormalWhite.copyWith(fontSize: 15), textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 2:
        text = 'SEPT';
        break;
      case 7:
        text = 'OCT';
        break;
      case 12:
        text = 'DEC';
        break;
      default:
        text = '';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: textStyleNormalWhite.copyWith(fontSize: 15),),
    );
  }

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: Colors.green,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Colors.blue,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: Colors.blue.withOpacity(0),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );
}

class DashboardChart extends StatefulWidget {
  const DashboardChart({super.key, required this.title});
  final String title;

  @override
  State<DashboardChart> createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
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
                child: LineChartCustom()),
            const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
