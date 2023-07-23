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

class CharlotteSocietyTabLeft extends ConsumerStatefulWidget {
  const CharlotteSocietyTabLeft({super.key});

  @override
  ConsumerState createState() => _CharlotteProductionTabLeftState();
}

class _CharlotteProductionTabLeftState
    extends ConsumerState<CharlotteSocietyTabLeft> {
  List<List<dynamic>>? data;
  List<List<dynamic>>? crimeData;
  List<List<dynamic>>? requestData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Violent crimes']!);
      setState(() {
        crimeData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Public Requests']!);
      setState(() {
        requestData = FileParser.transformer(data!);
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
            crimeData != null
                ? LineChartParser(
                    title: translate(
                        'city_data.charlotte.production.crime_title'),
                    legendX: translate('city_data.charlotte.production.year'),
                    chartData: {
                        translate('city_data.charlotte.production.offense'):
                            Colors.red,
                      }).chartParserWithDuplicate(dataX: crimeData![3], dataY: [
                    crimeData![6],
                  ])
                : const BlankDashboardContainer(
                    heightMultiplier: 2,
                    widthMultiplier: 2,
                  ),
            Const.dashboardUISpacing.ph,
            crimeData != null
                ? PieChartParser(
                        title: translate(
                            'city_data.charlotte.production.crime_title'),
                        subTitle: translate(
                            'city_data.charlotte.production.offenses'))
                    .chartParser(data: crimeData![5])
                : const BlankDashboardContainer(
                    heightMultiplier: 2,
                    widthMultiplier: 2,
                  ),
            Const.dashboardUISpacing.ph,
            requestData != null
                ? PieChartParser(
                        title: translate(
                            'city_data.charlotte.production.requests_title'),
                        subTitle: translate(
                            'city_data.charlotte.production.requests'))
                    .chartParser(data: requestData![6])
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
