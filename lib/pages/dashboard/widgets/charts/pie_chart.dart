import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/text_styles.dart';
import '../../../../constants/theme.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/extensions.dart';

class DashboardPieChart extends StatefulWidget {
  const DashboardPieChart(
      {super.key,
      required this.title,
      required this.headers,
      required this.percentages});

  final String title;
  final List<String> headers;
  final List<double> percentages;

  @override
  State<DashboardPieChart> createState() => _DashboardPieChartState();
}

class _DashboardPieChartState extends State<DashboardPieChart> {
  int touchedIndex = -1;

  pieChart() => PieChart(
        PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            sections: widget.headers
                .map((header) => PieChartSectionData(
                      color: lightenColor(
                          const Color(0xFF1A254D),
                          widget.percentages[widget.headers.indexOf(header)] /
                              100 *
                              0.7),
                      value: widget.percentages[widget.headers.indexOf(header)],
                      title: header,
                      radius: widget.headers.indexOf(header) == touchedIndex
                          ? 60.0
                          : 50.0,
                      titleStyle: TextStyle(
                        fontSize: widget.headers.indexOf(header) == touchedIndex
                            ? 25.0
                            : 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: const [
                          // Shadow(color: Colors.black, blurRadius: 2343)
                        ],
                      ),
                    ))
                .toList()),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (screenSize(context).width -
              screenSize(context).width / Const.tabBarWidthDivider) /
          2,
      height: (screenSize(context).width -
              screenSize(context).width / Const.tabBarWidthDivider) *
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
                  fontSize: Const.dashboardChartTextSize - 3,
                  color: Colors.white.withOpacity(0.5)),
            ),
            SizedBox(
              height: (screenSize(context).width -
                          screenSize(context).width /
                              Const.tabBarWidthDivider) *
                      Const.dashboardUIHeightFactor /
                      2 -
                  60,
              width: (screenSize(context).width -
                          screenSize(context).width /
                              Const.tabBarWidthDivider) /
                      2 -
                  50,
              child: Row(
                children: [
                  Expanded(child: pieChart()),
                  30.pw,
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'this is a very very this is a very very this is a very very this is a very very long text',
                          style: textStyleNormal.copyWith(
                              fontSize: Const.dashboardChartTextSize - 3,
                              color: Colors.white.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
