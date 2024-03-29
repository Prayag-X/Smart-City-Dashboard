import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:screenshot/screenshot.dart';

import '../../../data/downloadable_content.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/dashboard_container.dart';
import '../widgets/load_balloon.dart';
import '../../../constants/images.dart';
import '../../../utils/extensions.dart';
import '../../../constants/constants.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';

class NYCHealth extends ConsumerStatefulWidget {
  const NYCHealth({super.key});

  @override
  ConsumerState createState() => _NYCHealthTabLeftState();
}

class _NYCHealthTabLeftState extends ConsumerState<NYCHealth> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? hivData;
  List<List<dynamic>>? covidData;
  double? covidCases;
  double? covidDeaths;
  List<List<dynamic>>? sars2Data;
  List<List<dynamic>>? infantData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['HIV diagnosis']!);
      setState(() {
        hivData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Covid cases NYC']!);
      setState(() {
        covidData = FileParser.transformer(data!);
        covidCases = FileParser.totalColumn(data: covidData![1]);
        covidDeaths = FileParser.totalColumn(data: covidData![4]);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['SARS CoV2']!);
      setState(() {
        sars2Data = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Infant Mortality']!);
      setState(() {
        infantData = FileParser.transformer(data!);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  covidCases != null
                      ? DashboardContainer(
                          title: translate('city_data.new_york.health.case'),
                          data: covidCases!.toStringAsFixed(0),
                          image: ImageConst.corona,
                          showPercentage: true,
                          percentage: 1,
                          progressColor: Colors.yellow,
                        )
                      : const BlankDashboardContainer(),
                  covidDeaths != null
                      ? DashboardContainer(
                          title: translate('city_data.new_york.health.death'),
                          data: covidDeaths!.toStringAsFixed(0),
                          image: ImageConst.corona,
                          showPercentage: true,
                          percentage: covidDeaths! / covidCases!,
                          progressColor: Colors.red,
                        )
                      : const BlankDashboardContainer(),
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate('city_data.new_york.health.covid_title'),
                      legendX: translate('city_data.new_york.health.date'),
                      chartData: {
                        translate('city_data.new_york.health.case'):
                            Colors.blue,
                        translate('city_data.new_york.health.death'): Colors.red
                      },
                      markerIntervalX: 8)
                  .chartParser(
                dataX: covidData?[0],
                dataY: [covidData?[1], covidData?[4]],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate('city_data.new_york.health.sars_title'),
                      legendX: translate('city_data.new_york.health.date'),
                      chartData: {
                        translate('city_data.new_york.health.concentration'):
                            Colors.green,
                        translate('city_data.new_york.health.served'):
                            Colors.brown
                      },
                      barWidth: 0.1,
                      markerIntervalX: 8)
                  .chartParser(
                dataX: sars2Data?[0],
                dataY: [sars2Data?[4], sars2Data?[7]],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title:
                          translate('city_data.new_york.health.infant_title'),
                      legendX: translate('city_data.new_york.health.year'),
                      chartData: {
                        translate('city_data.new_york.health.infant_death'):
                            Colors.red,
                        translate('city_data.new_york.health.live_birth'):
                            Colors.green
                      },
                      markerIntervalX: 2)
                  .chartParserWithDuplicate(
                      dataX: infantData?[0],
                      dataY: [infantData?[5], infantData?[8]],
                      sortX: true),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate('city_data.new_york.health.hiv_title'),
                      legendX: translate('city_data.new_york.health.year'),
                      chartData: {
                        translate('city_data.new_york.health.hiv'): Colors.red,
                        translate('city_data.new_york.health.aids'):
                            Colors.yellow
                      },
                      markerIntervalX: 3)
                  .chartParserWithDuplicate(
                      dataX: hivData?[0],
                      dataY: [hivData?[5], hivData?[9]],
                      sortX: true),
              Const.dashboardUISpacing.ph,
            ],
          ),
        ),
      ),
    );
  }
}
