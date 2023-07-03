import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../utils/helper.dart';

class DashboardPieChart extends StatefulWidget {
  const DashboardPieChart({super.key, required this.title});

  final String title;

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
          sections: List.generate(4, (i) {
            final isTouched = i == touchedIndex;
            final fontSize = isTouched ? 25.0 : 16.0;
            final radius = isTouched ? 60.0 : 50.0;
            const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
            switch (i) {
              case 0:
                return PieChartSectionData(
                  color: Colors.blue,
                  value: 40,
                  title: '40%',
                  radius: radius,
                  titleStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: shadows,
                  ),
                );
              case 1:
                return PieChartSectionData(
                  color: Colors.yellow,
                  value: 30,
                  title: '30%',
                  radius: radius,
                  titleStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: shadows,
                  ),
                );
              case 2:
                return PieChartSectionData(
                  color: Colors.purple,
                  value: 15,
                  title: '15%',
                  radius: radius,
                  titleStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: shadows,
                  ),
                );
              case 3:
                return PieChartSectionData(
                  color: Colors.green,
                  value: 15,
                  title: '15%',
                  radius: radius,
                  titleStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: shadows,
                  ),
                );
              default:
                throw Error();
            }
          }),
        ),
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
            Row(
              children: [
                Expanded(child: pieChart()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[],
                ),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
