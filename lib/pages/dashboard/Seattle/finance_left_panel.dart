import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_city_dashboard/connections/downloader.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/kml_makers/kml_makers.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/pie_chart.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/pie_chart_parser.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/dashboard_right_panel.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../constants/constants.dart';
import '../../../constants/data.dart';
import '../downloadable_content.dart';
import '../../../constants/images.dart';
import '../../../constants/theme.dart';
import '../../../models/city_card_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../connections/ssh.dart';
import '../../../utils/csv_parser.dart';
import '../../../utils/helper.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/dashboard_container.dart';

class SeattleFinanceTabLeft extends ConsumerStatefulWidget {
  const SeattleFinanceTabLeft({super.key});

  @override
  ConsumerState createState() => _SeattleFinanceTabLeftState();
}

class _SeattleFinanceTabLeftState extends ConsumerState<SeattleFinanceTabLeft> {
  List<List<dynamic>>? data;
  List<List<dynamic>>? fleetData;
  List<List<dynamic>>? endorsedBudgetData;
  List<List<dynamic>>? openBudgetData;
  List<List<dynamic>>? operatingBudgetData;
  List<List<dynamic>>? adoptedBudgetData;
  List<List<dynamic>>? cipData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Fleet for auction']!);
      setState(() {
        fleetData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['2014 Endorsed budget']!);
      setState(() {
        endorsedBudgetData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Open Budget']!);
      setState(() {
        openBudgetData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['2011-16 CIP']!);
      setState(() {
        cipData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Operating budget']!);
      setState(() {
        operatingBudgetData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['2019-20 Adopted Budget']!);
      setState(() {
        adoptedBudgetData = FileParser.transformer(data!);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                covidCases != null ? DashboardContainer(
                  title: translate('city_data.new_york.health.case'),
                  data: covidCases!.toStringAsFixed(0),
                  image: ImageConst.corona,
                  showPercentage: true,
                  percentage: 1,
                  progressColor: Colors.yellow,
                ) : const BlankDashboardContainer(),
                covidDeaths != null ? DashboardContainer(
                  title: translate('city_data.new_york.health.death'),
                  data: covidDeaths!.toStringAsFixed(0),
                  image: ImageConst.corona,
                  showPercentage: true,
                  percentage: covidDeaths!/covidCases!,
                  progressColor: Colors.red,
                ) : const BlankDashboardContainer(),
              ],
            ),
            Const.dashboardUISpacing.ph,
            covidData != null
                ? LineChartParser(
                title:
                translate('city_data.new_york.health.covid_title'),
                legendX: translate('city_data.new_york.health.date'),
                chartData: {
                  translate('city_data.new_york.health.case'):
                  Colors.blue,
                  translate('city_data.new_york.health.death'):
                  Colors.red
                },
                markerIntervalX: 8)
                .chartParser(
              dataX: covidData![0],
              dataY: [covidData![1], covidData![4]],
            )
                : const BlankDashboardContainer(
              heightMultiplier: 2,
              widthMultiplier: 2,
            ),
            Const.dashboardUISpacing.ph,
            sars2Data != null
                ? LineChartParser(
                title:
                translate('city_data.new_york.health.sars_title'),
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
              dataX: sars2Data![0],
              dataY: [sars2Data![4], sars2Data![7]],
            )
                : const BlankDashboardContainer(
              heightMultiplier: 2,
              widthMultiplier: 2,
            ),
            Const.dashboardUISpacing.ph,
            infantData != null
                ? LineChartParser(
                title: translate('city_data.new_york.health.infant_title'),
                legendX: translate('city_data.new_york.health.year'),
                chartData: {
                  translate('city_data.new_york.health.infant_death'):
                  Colors.red,
                  translate('city_data.new_york.health.live_birth'):
                  Colors.green
                },
                markerIntervalX: 2)
                .chartParserWithDuplicate(
                dataX: infantData![0],
                dataY: [infantData![5], infantData![8]],
                sortX: true)
                : const BlankDashboardContainer(
              heightMultiplier: 2,
              widthMultiplier: 2,
            ),
            Const.dashboardUISpacing.ph,
            hivData != null
                ? LineChartParser(
                title: translate('city_data.new_york.health.hiv_title'),
                legendX: translate('city_data.new_york.health.year'),
                chartData: {
                  translate('city_data.new_york.health.hiv'):
                  Colors.red,
                  translate('city_data.new_york.health.aids'):
                  Colors.yellow
                },
                markerIntervalX: 3)
                .chartParserWithDuplicate(
                dataX: hivData![0],
                dataY: [hivData![5], hivData![9]],
                sortX: true)
                : const BlankDashboardContainer(
              heightMultiplier: 2,
              widthMultiplier: 2,
            ),
          ],
        ),
      ),
    );
  }
}