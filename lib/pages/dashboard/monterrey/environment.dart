import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:screenshot/screenshot.dart';

import '../../../data/downloadable_content.dart';
import '../widgets/charts/pie_chart_parser.dart';
import '../widgets/load_balloon.dart';
import '../../../utils/extensions.dart';
import '../../../constants/constants.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';

class MonterreyEnvironment extends ConsumerStatefulWidget {
  const MonterreyEnvironment({super.key});

  @override
  ConsumerState createState() => _MonterreyEnvironmentTabLeftState();
}

class _MonterreyEnvironmentTabLeftState
    extends ConsumerState<MonterreyEnvironment> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? eirsData;
  List<List<dynamic>>? geologyData;
  List<List<dynamic>>? mineralData;
  List<List<dynamic>>? erosionData;
  List<List<dynamic>>? liquefactionData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['EIRs']!);
      setState(() {
        eirsData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Geology']!);
      setState(() {
        geologyData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Mineral Resource Zones']!);
      setState(() {
        mineralData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Erosion']!);
      setState(() {
        erosionData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Liquefaction']!);
      setState(() {
        liquefactionData = FileParser.transformer(data!);
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
              PieChartParser(
                      title: translate(
                          'city_data.monterrey.environment.eirs_title'),
                      subTitle:
                          translate('city_data.monterrey.environment.library'))
                  .chartParser(data: eirsData?[9]),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title: translate(
                          'city_data.monterrey.environment.geology_title'),
                      subTitle:
                          translate('city_data.monterrey.environment.class'))
                  .chartParser(data: geologyData?[12]),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title: translate(
                          'city_data.monterrey.environment.mineral_title'),
                      subTitle:
                          translate('city_data.monterrey.environment.mrz'))
                  .chartParser(data: mineralData?[2]),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title: translate(
                          'city_data.monterrey.environment.erosion_title'),
                      subTitle:
                          translate('city_data.monterrey.environment.rating'))
                  .chartParser(data: erosionData?[3]),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title: translate(
                          'city_data.monterrey.environment.liquefaction_title'),
                      subTitle:
                          translate('city_data.monterrey.environment.liquid'))
                  .chartParser(data: liquefactionData?[2]),
              Const.dashboardUISpacing.ph,
            ],
          ),
        ),
      ),
    );
  }
}
