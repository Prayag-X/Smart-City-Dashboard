import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:screenshot/screenshot.dart';

import '../../../data/downloadable_content.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/charts/pie_chart_parser.dart';
import '../widgets/load_balloon.dart';
import '../../../utils/extensions.dart';
import '../../../constants/constants.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';

class CharlotteMisc extends ConsumerStatefulWidget {
  const CharlotteMisc({super.key});

  @override
  ConsumerState createState() => _CharlotteMiscTabLeftState();
}

class _CharlotteMiscTabLeftState extends ConsumerState<CharlotteMisc> {
  ScreenshotController screenshotController = ScreenshotController();
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
                  title: translate('city_data.charlotte.misc.service_title'),
                  legendX: translate('city_data.charlotte.misc.year'),
                  chartData: {
                    translate('city_data.charlotte.misc.calls'): Colors.yellow,
                  }).chartParserWithDuplicate(dataX: serviceData?[3], dataY: [
                serviceData?[6],
              ]),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title:
                          translate('city_data.charlotte.misc.traffic_title'),
                      subTitle:
                          translate('city_data.charlotte.misc.traffic_title'))
                  .chartParser(data: trafficData?[2]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title:
                          translate('city_data.charlotte.misc.housing_title'),
                      legendX: translate('city_data.charlotte.misc.object'),
                      chartData: {
                        translate('city_data.charlotte.misc.puma'): Colors.blue,
                        translate('city_data.charlotte.misc.bdsp'):
                            Colors.yellow,
                        translate('city_data.charlotte.misc.elep'): Colors.red,
                      },
                      barWidth: 1)
                  .chartParser(dataX: demandData?[0], dataY: [
                demandData?[4],
                demandData?[16],
                demandData?[23],
              ]),
              Const.dashboardUISpacing.ph,
            ],
          ),
        ),
      ),
    );
  }
}
