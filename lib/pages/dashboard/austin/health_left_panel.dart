import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../constants/constants.dart';
import '../downloadable_content.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/dashboard_container.dart';

class AustinHealthTabLeft extends ConsumerStatefulWidget {
  const AustinHealthTabLeft({super.key});

  @override
  ConsumerState createState() => _AustinHealthTabLeftState();
}

class _AustinHealthTabLeftState extends ConsumerState<AustinHealthTabLeft> {
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
     return AnimationLimiter(
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
            imagineAustinData != null
                ? LineChartParser(
                title: translate(
                    'city_data.austin.environment.imagine_austin_title'),
                legendX: translate('city_data.austin.environment.tag'),
                chartData: {
                  translate('city_data.austin.environment.2007'):
                  Colors.blue,
                  translate('city_data.austin.environment.2012'):
                  Colors.yellow,
                  translate('city_data.austin.environment.2017'):
                  Colors.red,
                }).chartParser(dataX: imagineAustinData![0], dataY: [
              imagineAustinData![4],
              imagineAustinData![9],
              imagineAustinData![14],
            ])
                : const BlankDashboardContainer(
              heightMultiplier: 2,
              widthMultiplier: 2,
            ),
            Const.dashboardUISpacing.ph,
            cpi38Data != null
                ? LineChartParser(
                title:
                translate('city_data.austin.environment.cpi_38_title'),
                legendX: translate('city_data.austin.environment.year'),
                chartData: {
                  translate('city_data.austin.environment.victims'):
                  Colors.red,
                },markerIntervalX: 1).chartParserWithDuplicate(dataX: cpi38Data![0], dataY: [
              cpi38Data![4],
            ])
                : const BlankDashboardContainer(
              heightMultiplier: 2,
              widthMultiplier: 2,
            ),
            Const.dashboardUISpacing.ph,
            cpi33Data != null
                ? LineChartParser(
                title:
                translate('city_data.austin.environment.cpi_33_title'),
                legendX: translate('city_data.austin.environment.year'),
                chartData: {
                  translate('city_data.austin.environment.victims'):
                  Colors.red,
                },markerIntervalX: 1).chartParserWithDuplicate(dataX: cpi33Data![0], dataY: [
              cpi33Data![4],
            ])
                : const BlankDashboardContainer(
              heightMultiplier: 2,
              widthMultiplier: 2,
            ),
            Const.dashboardUISpacing.ph,
            greenBuildingData != null
                ? LineChartParser(
                title: translate(
                    'city_data.austin.environment.green_building_title'),
                legendX: translate('city_data.austin.environment.year'),
                chartData: {
                  translate('city_data.austin.environment.project_no'):
                  Colors.blue,
                  translate('city_data.austin.environment.energy'):
                  Colors.yellow,
                  translate('city_data.austin.environment.demand'):
                  Colors.red,
                }).chartParserWithDuplicate(
                sortX: true,
                dataX: greenBuildingData![1],
                dataY: [
                  greenBuildingData![2],
                  greenBuildingData![7],
                  greenBuildingData![8],
                ])
                : const BlankDashboardContainer(
              heightMultiplier: 2,
              widthMultiplier: 2,
            ),
            Const.dashboardUISpacing.ph,
            ecadData != null
                ? LineChartParser(
                title: translate('city_data.austin.environment.ecad_title'),
                legendX: translate('city_data.austin.environment.id'),
                chartData: {
                  translate('city_data.austin.environment.number'):
                  Colors.blue,
                  translate('city_data.austin.environment.apts'):
                  Colors.yellow,
                  translate('city_data.austin.environment.costs'):
                  Colors.red,
                },barWidth: 1).chartParser(dataX: ecadData![0], dataY: [
              ecadData![9],
              ecadData![10],
              ecadData![12],
            ])
                : const BlankDashboardContainer(
              heightMultiplier: 2,
              widthMultiplier: 2,
            ),
            Const.dashboardUISpacing.ph,
            renewableData != null
                ? LineChartParser(
                title: translate(
                    'city_data.austin.environment.renewable_title'),
                legendX: translate('city_data.austin.environment.year'),
                chartData: {
                  translate('city_data.austin.environment.percentage'):
                  Colors.blue,
                }).chartParser(dataX: renewableData![0], dataY: [
              renewableData![1],
            ])
                : const BlankDashboardContainer(
              heightMultiplier: 2,
              widthMultiplier: 2,
            ),
            Const.dashboardUISpacing.ph,
            hee5cData != null
                ? LineChartParser(
                title: translate('city_data.austin.environment.heec5'),
                legendX: translate('city_data.austin.environment.district'),
                chartData: {
                  translate('city_data.austin.environment.treated'):
                  Colors.blue,
                  translate('city_data.austin.environment.treatable'):
                  Colors.yellow,
                }).chartParserWithDuplicate(
                sortX: true,
                dataX: hee5cData![1],
                dataY: [
                  hee5cData![2],
                  hee5cData![3],
                ])
                : const BlankDashboardContainer(
              heightMultiplier: 2,
              widthMultiplier: 2,
            ),
            Const.dashboardUISpacing.ph,
          ],
        ),
      ),
    );
  }
}
