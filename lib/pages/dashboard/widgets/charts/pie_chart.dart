import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
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
      required this.subTitle,
      required this.headers,
      required this.percentages,
      required this.total});

  final String title;
  final String subTitle;
  final int total;
  final List<String> headers;
  final List<double> percentages;

  @override
  State<DashboardPieChart> createState() => _DashboardPieChartState();
}

class _DashboardPieChartState extends State<DashboardPieChart> {
  int touchedIndex = -1;
  Color chartColor = const Color(0xFF00104B);

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
            sectionsSpace: 5,
            centerSpaceRadius: 35,
            sections: widget.headers
                .map((header) => PieChartSectionData(
                      color: lightenColor(
                          chartColor,
                          widget.percentages[widget.headers.indexOf(header)] /
                              100 *
                              0.7),
                      value: widget.percentages[widget.headers.indexOf(header)],
                      title: '${widget.percentages[widget.headers.indexOf(header)].toStringAsFixed(0)}%',
                      showTitle: widget.percentages[widget.headers.indexOf(header)] > 3 ? true : false,
                      radius: widget.headers.indexOf(header) == touchedIndex
                          ? 57.0
                          : 50.0,
                      titleStyle: TextStyle(
                        fontSize: widget.headers.indexOf(header) == touchedIndex
                            ? 20.0
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${TextConst.total} ${widget.subTitle}: ${widget.total}',
                          style: textStyleBoldWhite.copyWith(
                              fontSize: Const.dashboardChartTextSize - 2),
                        ),
                        15.ph,
                        Column(
                            children: widget.headers
                                .map(
                                  (header) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: Const.dashboardChartTextSize - 5,
                                          height:
                                              Const.dashboardChartTextSize - 5,
                                          decoration: BoxDecoration(
                                              color: lightenColor(
                                                  chartColor,
                                                  widget.percentages[widget
                                                          .headers
                                                          .indexOf(header)] /
                                                      100 *
                                                      0.7),
                                              borderRadius:
                                                  BorderRadius.circular(35.0)),
                                        ),
                                        8.pw,
                                        Text(
                                          header,
                                          style: textStyleNormal.copyWith(
                                              fontSize:
                                                  Const.dashboardChartTextSize - 2
                                                      ,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList()),
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
