import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/pie_chart_parser.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../constants/constants.dart';
import '../downloadable_content.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/dashboard_container.dart';

class CharlotteMiscTabLeft extends ConsumerStatefulWidget {
  const CharlotteMiscTabLeft({super.key});

  @override
  ConsumerState createState() => _CharlotteMiscTabLeftState();
}

class _CharlotteMiscTabLeftState extends ConsumerState<CharlotteMiscTabLeft> {
  List<List<dynamic>>? data;
  List<List<dynamic>>? serviceData;
  List<List<dynamic>>? trafficData;
  List<List<dynamic>>? demandData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Calls for service']!);
      setState(() {
        serviceData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Traffic stops']!);
      setState(() {
        trafficData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Housing demand']!);
      setState(() {
        demandData = FileParser.transformer(data!);
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
            serviceData != null
                ? LineChartParser(
                    title: translate('city_data.charlotte.misc.service_title'),
                    legendX: translate('city_data.charlotte.misc.year'),
                    chartData: {
                        translate('city_data.charlotte.misc.calls'):
                            Colors.yellow,
                      }).chartParserWithDuplicate(
                    dataX: serviceData![3],
                    dataY: [
                        serviceData![6],
                      ])
                : const BlankDashboardContainer(
                    heightMultiplier: 2,
                    widthMultiplier: 2,
                  ),
            Const.dashboardUISpacing.ph,
            trafficData != null
                ? PieChartParser(
                        title: translate(
                            'city_data.charlotte.misc.traffic_title'),
                        subTitle: translate(
                            'city_data.charlotte.misc.traffic_title'))
                    .chartParser(data: trafficData![2])
                : const BlankDashboardContainer(
                    heightMultiplier: 2,
                    widthMultiplier: 2,
                  ),
            Const.dashboardUISpacing.ph,
            demandData != null
                ? LineChartParser(
                    title: translate('city_data.charlotte.misc.housing_title'),
                    legendX: translate('city_data.charlotte.misc.object'),
                    chartData: {
                        translate('city_data.charlotte.misc.puma'):
                            Colors.blue,
                      translate('city_data.charlotte.misc.bdsp'):
                            Colors.yellow,
                      translate('city_data.charlotte.misc.elep'):
                            Colors.red,
                      },barWidth: 1).chartParser(dataX: demandData![0], dataY: [
              demandData![4],
              demandData![16],
              demandData![23],
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
