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

class BoulderLivableTabLeft extends ConsumerStatefulWidget {
  const BoulderLivableTabLeft({super.key});

  @override
  ConsumerState createState() => _BoulderLivableTabLeftState();
}

class _BoulderLivableTabLeftState extends ConsumerState<BoulderLivableTabLeft> {
  List<List<dynamic>>? data;
  List<List<dynamic>>? buildingData;
  List<List<dynamic>>? homelessnessData;
  List<List<dynamic>>? communityData;
  List<List<dynamic>>? policeData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Building Use and Square Footage']!);
      setState(() {
        buildingData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Homelessness program']!);
      setState(() {
        homelessnessData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Community Assessment']!);
      setState(() {
        communityData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Police Stops']!);
      setState(() {
        policeData = FileParser.transformer(data!);
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
            buildingData != null
                ? LineChartParser(
                    title:
                        translate('city_data.boulder.livable.building_title'),
                    legendX: translate('city_data.boulder.livable.id'),
                    chartData: {
                      translate('city_data.boulder.livable.areaSF'):
                          Colors.blue,
                      translate('city_data.boulder.livable.row'): Colors.yellow,
                    },
                  ).chartParser(dataX: buildingData![11], dataY: [
                    buildingData![7],
                    buildingData![2],
                  ])
                : const BlankDashboardContainer(
                    heightMultiplier: 2,
                    widthMultiplier: 2,
                  ),
            Const.dashboardUISpacing.ph,
            homelessnessData != null
                ? LineChartParser(
                    title: translate(
                        'city_data.boulder.livable.homelessness_title'),
                    legendX: translate('city_data.boulder.livable.id'),
                    chartData: {
                      translate('city_data.boulder.livable.attendance'):
                          Colors.blue,
                    },
                  ).chartParser(dataX: homelessnessData![0], dataY: [
                    homelessnessData![4],
                  ])
                : const BlankDashboardContainer(
                    heightMultiplier: 2,
                    widthMultiplier: 2,
                  ),
            Const.dashboardUISpacing.ph,
            communityData != null
                ? LineChartParser(
                    title:
                        translate('city_data.boulder.livable.community_title'),
                    legendX: translate('city_data.boulder.livable.id'),
                    chartData: {
                      translate('city_data.boulder.livable.no_people'):
                          Colors.blue,
                    },
                  ).chartParser(dataX: communityData![0], dataY: [
                    communityData![133],
                  ])
                : const BlankDashboardContainer(
                    heightMultiplier: 2,
                    widthMultiplier: 2,
                  ),
            Const.dashboardUISpacing.ph,
            policeData != null
                ? LineChartParser(
                    title: translate('city_data.boulder.livable.police_title'),
                    legendX: translate('city_data.boulder.livable.id'),
                    chartData: {
                      translate('city_data.boulder.livable.stop_time'):
                          Colors.blue,
                      translate('city_data.boulder.livable.min'): Colors.yellow,
                      translate('city_data.boulder.livable.dob'): Colors.red,
                    },
                  ).chartParser(dataX: policeData![0], dataY: [
                    policeData![2],
                    policeData![6],
                    policeData![10],
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
