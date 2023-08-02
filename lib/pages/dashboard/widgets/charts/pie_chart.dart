import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../constants/constants.dart';
import '../../../../constants/text_styles.dart';
import '../../../../models/pie_chart_model.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/helper.dart';

class DashboardPieChart extends ConsumerStatefulWidget {
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
  ConsumerState<DashboardPieChart> createState() => _DashboardPieChartState();
}

class _DashboardPieChartState extends ConsumerState<DashboardPieChart> {
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
                    connectorLineSettings:
                        const ConnectorLineSettings(color: Colors.red),
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
              dataLabelMapper: (ChartData data, _) =>
                  '${data.y.toStringAsFixed(0)}%',
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: true,
                  labelPosition: ChartDataLabelPosition.inside,
                  textStyle: textStyleBold.copyWith(fontSize: 14),
                  overflowMode: OverflowMode.hide),
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
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    return Container(
      width: (screenSize(context).width -
              screenSize(context).width / Const.tabBarWidthDivider) /
          2,
      height: (screenSize(context).width -
              screenSize(context).width / Const.tabBarWidthDivider) *
          Const.dashboardUIHeightFactor /
          2,
      decoration: BoxDecoration(
        color: highlightColor,
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
              '${translate('dashboard.total')} ${widget.subTitle}: ${widget.total}',
              style: textStyleBold.copyWith(
                  color: oppositeColor,
                  fontSize: Const.dashboardChartTextSize - 2),
            ),
          ],
        ),
      ),
    );
  }
}

class VisualizerPieChart extends ConsumerStatefulWidget {
  const VisualizerPieChart({super.key, required this.chartData});

  final List<ChartData> chartData;

  @override
  ConsumerState<VisualizerPieChart> createState() => _VisualizerPieChartState();
}

class _VisualizerPieChartState extends ConsumerState<VisualizerPieChart> {
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
                    connectorLineSettings:
                        const ConnectorLineSettings(color: Colors.red),
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
              dataLabelMapper: (ChartData data, _) =>
                  '${data.y.toStringAsFixed(0)}%',
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  showZeroValue: true,
                  labelPosition: ChartDataLabelPosition.inside,
                  textStyle: textStyleBold.copyWith(fontSize: 14),
                  overflowMode: OverflowMode.hide),
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
    Color normalColor = ref.watch(normalColorProvider);
    Color oppositeColor = ref.watch(oppositeColorProvider);
    Color tabBarColor = ref.watch(tabBarColorProvider);
    Color highlightColor = ref.watch(highlightColorProvider);
    return Container(
      width: screenSize(context).width * 0.8 -
          screenSize(context).width / Const.tabBarWidthDivider,
      height: (screenSize(context).width -
              screenSize(context).width / Const.tabBarWidthDivider) *
          Const.dashboardUIHeightFactor *
          0.7,
      decoration: BoxDecoration(
        color: highlightColor,
        borderRadius: BorderRadius.circular(Const.dashboardUIRoundness),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
        child: ClipRRect(
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
      ),
    );
  }
}
