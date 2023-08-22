import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:screenshot/screenshot.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/pie_chart_parser.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../connections/ssh.dart';
import '../../../constants/constants.dart';
import '../../../kml_makers/balloon_makers.dart';
import '../../../providers/page_providers.dart';
import '../../../utils/helper.dart';
import '../downloadable_content.dart';
import '../../../constants/images.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/dashboard_container.dart';
import '../widgets/load_balloon.dart';

class MonterreyEnvironmentTabLeft extends ConsumerStatefulWidget {
  const MonterreyEnvironmentTabLeft({super.key});

  @override
  ConsumerState createState() => _MonterreyEnvironmentTabLeftState();
}

class _MonterreyEnvironmentTabLeftState extends ConsumerState<MonterreyEnvironmentTabLeft> {
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
              eirsData != null
                  ? PieChartParser(
                  title: translate(
                      'city_data.monterrey.environment.eirs_title'),
                  subTitle: translate(
                      'city_data.monterrey.environment.library'))
                  .chartParser(data: eirsData![9])
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              geologyData != null
                  ? PieChartParser(
                  title: translate(
                      'city_data.monterrey.environment.geology_title'),
                  subTitle: translate(
                      'city_data.monterrey.environment.class'))
                  .chartParser(data: geologyData![12])
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              mineralData != null
                  ? PieChartParser(
                  title: translate(
                      'city_data.monterrey.environment.mineral_title'),
                  subTitle: translate(
                      'city_data.monterrey.environment.mrz'))
                  .chartParser(data: mineralData![2])
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              erosionData != null
                  ? PieChartParser(
                  title: translate(
                      'city_data.monterrey.environment.erosion_title'),
                  subTitle: translate(
                      'city_data.monterrey.environment.rating'))
                  .chartParser(data: erosionData![3])
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              liquefactionData != null
                  ? PieChartParser(
                  title: translate(
                      'city_data.monterrey.environment.liquefaction_title'),
                  subTitle: translate(
                      'city_data.monterrey.environment.liquid'))
                  .chartParser(data: liquefactionData![2])
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
            ],
          ),
        ),
      ),
    );
  }
}
