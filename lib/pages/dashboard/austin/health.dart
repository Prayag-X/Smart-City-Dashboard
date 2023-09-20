import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:screenshot/screenshot.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../constants/constants.dart';
import '../downloadable_content.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/dashboard_container.dart';
import '../widgets/load_balloon.dart';

class AustinHealth extends ConsumerStatefulWidget {
  const AustinHealth({super.key});

  @override
  ConsumerState createState() => _AustinHealthTabLeftState();
}

class _AustinHealthTabLeftState extends ConsumerState<AustinHealth> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? sa4Data;
  List<List<dynamic>>? sa5Data;
  List<List<dynamic>>? foodInspectionData;
  List<List<dynamic>>? insuranceData;
  List<List<dynamic>>? lakeData;
  List<List<dynamic>>? badHealthData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['SA4 Mental training']!);
      setState(() {
        sa4Data = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['SA5 Mental training']!);
      setState(() {
        sa5Data = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Food Inspection']!);
      setState(() {
        foodInspectionData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Below 65 no health insurance']!);
      setState(() {
        insuranceData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Creek lake good health']!);
      setState(() {
        lakeData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Bad mental health']!);
      setState(() {
        badHealthData = FileParser.transformer(data!);
      });
      if (!mounted) {
        return;
      }
      await BalloonLoader(ref: ref, mounted: mounted, context: context)
          .loadDashboardBalloon(screenshotController);
      ref.read(isLoadingProvider.notifier).state = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCSVData();
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: Const.animationDuration,
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: -Const.animationDistance,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              LineChartParser(
                      title: translate('city_data.austin.health.sa4_title'),
                      legendX: translate('city_data.austin.health.dept'),
                      chartData: {
                        translate('city_data.austin.health.attendees'):
                            Colors.yellow,
                        translate('city_data.austin.health.eligible'):
                            Colors.blue,
                      },
                      markerIntervalX: 6)
                  .chartParser(limitMarkerX: 14, dataX: sa4Data?[0], dataY: [
                sa4Data?[1],
                sa4Data?[2],
              ]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                  title: translate('city_data.austin.health.sa5_title'),
                  legendX: translate('city_data.austin.health.year'),
                  chartData: {
                    translate('city_data.austin.health.eligible'): Colors.blue,
                  }).chartParserWithDuplicate(
                  sortX: true,
                  dataX: sa5Data?[1],
                  dataY: [
                    sa5Data?[3],
                  ]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate('city_data.austin.health.food_title'),
                      legendX: translate('city_data.austin.health.restaurant'),
                      chartData: {
                        translate('city_data.austin.health.score'): Colors.blue,
                      },
                      barWidth: 2)
                  .chartParser(
                      dataX: foodInspectionData?[0],
                      dataY: [
                        foodInspectionData?[3],
                      ],
                      limitMarkerX: 6),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                  title: translate('city_data.austin.health.health_insurance'),
                  legendX: translate('city_data.austin.health.year'),
                  chartData: {
                    translate('city_data.austin.health.percent'): Colors.blue,
                  }).chartParserWithDuplicate(dataX: insuranceData?[0], dataY: [
                insuranceData?[1],
              ]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate('city_data.austin.health.lake_health'),
                      legendX: translate('city_data.austin.health.reach'),
                      chartData: {
                        translate('city_data.austin.health.score'): Colors.blue,
                      },
                      barWidth: 2)
                  .chartParser(dataX: lakeData?[0], dataY: [
                lakeData?[5],
              ]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                  title: translate('city_data.austin.health.bad_mental_health'),
                  legendX: translate('city_data.austin.health.year'),
                  chartData: {
                    translate('city_data.austin.health.percent'): Colors.blue,
                  }).chartParser(dataX: badHealthData?[0], dataY: [
                badHealthData?[1],
              ]),
              Const.dashboardUISpacing.ph,
            ],
          ),
        ),
      ),
    );
  }
}
