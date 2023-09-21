import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:screenshot/screenshot.dart';

import '../downloadable_content.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/load_balloon.dart';
import '../../../utils/extensions.dart';
import '../../../constants/constants.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';

class SeattleEducation extends ConsumerStatefulWidget {
  const SeattleEducation({super.key});

  @override
  ConsumerState createState() => _SeattleEducationTabLeftState();
}

class _SeattleEducationTabLeftState
    extends ConsumerState<SeattleEducation> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? tsgOverallData;
  List<List<dynamic>>? tsgDomainData;
  List<List<dynamic>>? sppEnrollmentData;
  List<List<dynamic>>? sppSPSData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['TSG Overall']!);
      setState(() {
        tsgOverallData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['TSG domain']!);
      setState(() {
        tsgDomainData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['SPP enrollment']!);
      setState(() {
        sppEnrollmentData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['SPP vs SPS']!);
      setState(() {
        sppSPSData = FileParser.transformer(data!);
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
                      title: translate(
                          'city_data.seattle.education.tsg_overall_title'),
                      legendX: translate('city_data.seattle.education.group'),
                      chartData: {
                        translate('city_data.seattle.education.percentage'):
                            Colors.blue,
                        translate('city_data.seattle.education.avg_met'):
                            Colors.yellow,
                        translate('city_data.seattle.education.children_count'):
                            Colors.red,
                      },
                      barWidth: 4)
                  .chartParser(
                limitMarkerX: 10,
                dataX: tsgOverallData?[1],
                dataY: [
                  tsgOverallData?[2],
                  tsgOverallData?[3],
                  tsgOverallData?[4],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.seattle.education.tsg_domain_title'),
                      legendX: translate('city_data.seattle.education.group'),
                      chartData: {
                        translate('city_data.seattle.education.lan_met'):
                            Colors.blue,
                        translate('city_data.seattle.education.literacy_met'):
                            Colors.yellow,
                        translate('city_data.seattle.education.children_count'):
                            Colors.red,
                      },
                      barWidth: 4)
                  .chartParser(
                limitMarkerX: 10,
                dataX: tsgDomainData?[1],
                dataY: [
                  tsgDomainData?[2],
                  tsgDomainData?[3],
                  tsgDomainData?[8],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate('city_data.seattle.education.spp_title'),
                      legendX: translate('city_data.seattle.education.year'),
                      chartData: {
                        translate('city_data.seattle.education.children_count'):
                            Colors.blue,
                      },
                      barWidth: 4)
                  .chartParser(
                limitMarkerX: 8,
                dataX: sppEnrollmentData?[0],
                dataY: [
                  sppEnrollmentData?[2],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.seattle.education.spp_sps_title'),
                      legendX: translate('city_data.seattle.education.year'),
                      chartData: {
                        translate('city_data.seattle.education.children_count'):
                            Colors.blue,
                      },
                      barWidth: 4)
                  .chartParser(
                limitMarkerX: 8,
                dataX: sppSPSData?[1],
                dataY: [
                  sppSPSData?[2],
                ],
              ),
              Const.dashboardUISpacing.ph,
            ],
          ),
        ),
      ),
    );
  }
}
