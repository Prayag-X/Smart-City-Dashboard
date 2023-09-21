import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:screenshot/screenshot.dart';

import '../widgets/charts/line_chart_parser.dart';
import '../widgets/load_balloon.dart';
import '../downloadable_content.dart';
import '../../../constants/constants.dart';
import '../../../utils/extensions.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';

class TorontoGovernment extends ConsumerStatefulWidget {
  const TorontoGovernment({super.key});

  @override
  ConsumerState createState() => _TorontoGovernmentTabLeftState();
}

class _TorontoGovernmentTabLeftState
    extends ConsumerState<TorontoGovernment> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? polisData;
  List<List<dynamic>>? shelterData;
  List<List<dynamic>>? evaluationData;
  List<List<dynamic>>? registrationData;
  List<List<dynamic>>? measuresData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Polis Data']!);
      setState(() {
        polisData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Daily Shelter']!);
      setState(() {
        shelterData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Apartment Evaluation']!);
      setState(() {
        evaluationData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Apartment Registration']!);
      setState(() {
        registrationData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Measures']!);
      setState(() {
        measuresData = FileParser.transformer(data!);
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
                      title:
                          translate('city_data.toronto.government.polis_title'),
                      legendX: translate('city_data.toronto.government.id'),
                      chartData: {
                        translate('city_data.toronto.government.pass_rate'):
                            Colors.blue,
                        translate(
                                'city_data.toronto.government.potential_voters'):
                            Colors.yellow,
                      },
                      barWidth: 2)
                  .chartParser(
                // limitMarkerX: 8,
                dataX: polisData?[0],
                dataY: [
                  polisData?[18],
                  polisData?[23],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.toronto.government.shelter_title'),
                      legendX: translate('city_data.toronto.government.id'),
                      chartData: {
                        translate('city_data.toronto.government.users'):
                            Colors.blue,
                        translate(
                                'city_data.toronto.government.occupancy_rate'):
                            Colors.yellow,
                      },
                      barWidth: 1)
                  .chartParser(
                // limitMarkerX: 8,
                dataX: shelterData?[0],
                dataY: [
                  shelterData?[18],
                  shelterData?[31],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.toronto.government.evaluation_title'),
                      legendX: translate('city_data.toronto.government.id'),
                      chartData: {
                        translate('city_data.toronto.government.year_built'):
                            Colors.blue,
                        translate('city_data.toronto.government.storeys'):
                            Colors.yellow,
                        translate('city_data.toronto.government.score'):
                            Colors.red,
                      },
                      barWidth: 1)
                  .chartParser(
                // limitMarkerX: 8,
                dataX: evaluationData?[0],
                dataY: [
                  evaluationData?[4],
                  evaluationData?[9],
                  evaluationData?[12],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.toronto.government.registration_title'),
                      legendX: translate('city_data.toronto.government.id'),
                      chartData: {
                        translate('city_data.toronto.government.year_built'):
                            Colors.blue,
                        translate(
                                'city_data.toronto.government.year_registered'):
                            Colors.yellow,
                        translate('city_data.toronto.government.storeys'):
                            Colors.red,
                      },
                      barWidth: 2)
                  .chartParser(
                // limitMarkerX: 8,
                dataX: registrationData?[0],
                dataY: [
                  registrationData?[59],
                  registrationData?[61],
                  registrationData?[9],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                title: translate('city_data.toronto.government.measures_title'),
                legendX: translate('city_data.toronto.government.id'),
                chartData: {
                  translate('city_data.toronto.government.result'): Colors.blue,
                },
              ).chartParser(
                // limitMarkerX: 8,
                dataX: measuresData?[0],
                dataY: [
                  measuresData?[10],
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
