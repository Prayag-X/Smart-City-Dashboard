import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_city_dashboard/constants/texts.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/text_styles.dart';
import '../../../../constants/theme.dart';
import '../../../../models/pie_chart_model.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/extensions.dart';

class DashboardPieChart extends StatefulWidget {
  const DashboardPieChart(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.chartData,
      required this.total});

  final String title;
  final String subTitle;
  final int total;
  final List<ChartData> chartData;

  @override
  State<DashboardPieChart> createState() => _DashboardPieChartState();
}

class _DashboardPieChartState extends State<DashboardPieChart> {
  int touchedIndex = -1;
  Color chartColor = const Color(0xFF0021C7);
  List<Color> chartColors = [
    const Color(0xFF4660D9),
    const Color(0xFFFF0005),
    const Color(0xFFFFEB00),
    const Color(0xFF5B6A88),
    const Color(0xFF887859),
    const Color(0xFFFFDF00),
    const Color(0xFF0E2185),
    const Color(0xFFFF0000),
    const Color(0xFF00104B),
    const Color(0xFF00104B),
    const Color(0xFF00104B),
    const Color(0xFF00104B),
    const Color(0xFF00104B),
    const Color(0xFF00104B),
    const Color(0xFF00104B),
  ];

  pieChart() => Stack(
        children: [
          SfCircularChart(series: <CircularSeries>[
            // Renders doughnut chart
            DoughnutSeries<ChartData, String>(
                dataSource: widget.chartData,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                dataLabelMapper: (ChartData data, _) => data.x,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    showZeroValue: true,
                    borderRadius: 5,
                    overflowMode: OverflowMode.hide,
                    labelPosition: ChartDataLabelPosition.outside,
                    connectorLineSettings: ConnectorLineSettings(color: Colors.white),
                    textStyle: textStyleNormal.copyWith(fontSize: 12),
                    useSeriesColor: true),
                innerRadius: '100%',
                radius: '80%',
                // explodeGesture: ActivationMode.none,
                // explode: true,
                // explodeIndex: touchedIndex,
                animationDuration: 1000)
          ]),
          SfCircularChart(series: <CircularSeries>[
            // Renders doughnut chart
            DoughnutSeries<ChartData, String>(
              dataSource: widget.chartData,
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelMapper: (ChartData data, _) => '${data.y.toStringAsFixed(0)}%',
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: true,
                  labelPosition: ChartDataLabelPosition.inside,
                  textStyle: textStyleBold.copyWith(fontSize: 14),
                  overflowMode: OverflowMode.hide
              ),
              // onPointTap: (x) {
              //   if (x.pointIndex != null) {
              //     setState(() {
              //       touchedIndex = x.pointIndex!;
              //     });
              //   }
              // },
              innerRadius: '40%',
              radius: '80%',
              // explodeGesture: ActivationMode.singleTap,
              // explode: true,
              animationDuration: 1000,
            )
          ]),
        ],
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
            ClipRRect(
              child: SizedBox(
                  height: (screenSize(context).width -
                              screenSize(context).width /
                                  Const.tabBarWidthDivider) *
                          Const.dashboardUIHeightFactor /
                          2 -
                      70,
                  width: (screenSize(context).width -
                              screenSize(context).width /
                                  Const.tabBarWidthDivider) /
                          2 -
                      50,
                  child: pieChart()),
            ),
            Text(
              '${TextConst.total} ${widget.subTitle}: ${widget.total}',
              style: textStyleBoldWhite.copyWith(
                  fontSize: Const.dashboardChartTextSize - 2),
            ),
          ],
        ),
      ),
    );
  }
}
