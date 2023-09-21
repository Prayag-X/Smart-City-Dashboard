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

class SeattleTransportation extends ConsumerStatefulWidget {
  const SeattleTransportation({super.key});

  @override
  ConsumerState createState() => _SeattleTransportationTabLeftState();
}

class _SeattleTransportationTabLeftState
    extends ConsumerState<SeattleTransportation> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? fretmontCycleData;
  List<List<dynamic>>? brodwayCycleData;
  List<List<dynamic>>? westlakeCycleData;
  List<List<dynamic>>? annualParkingData;
  List<List<dynamic>>? trafficCountData;
  List<List<dynamic>>? nbpdData;
  List<List<dynamic>>? shortBikeData;
  List<List<dynamic>>? watData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Fretmont Cycle counter']!);
      setState(() {
        fretmontCycleData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Brodway Cycle counter']!);
      setState(() {
        brodwayCycleData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Westlake Cycle counter']!);
      setState(() {
        westlakeCycleData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Annual parking']!);
      setState(() {
        annualParkingData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Traffic counts']!);
      setState(() {
        trafficCountData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['NBPD Bike count']!);
      setState(() {
        nbpdData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Short Duration Bike count']!);
      setState(() {
        shortBikeData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['WAT 2017']!);
      setState(() {
        watData = FileParser.transformer(data!);
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
                          'city_data.seattle.transportation.fretmont_title'),
                      legendX:
                          translate('city_data.seattle.transportation.date'),
                      chartData: {
                        translate('city_data.seattle.transportation.south'):
                            Colors.blue,
                        translate('city_data.seattle.transportation.east'):
                            Colors.yellow,
                        translate('city_data.seattle.transportation.west'):
                            Colors.red,
                      },
                      markerIntervalX: 23,
                      barWidth: 1)
                  .chartParser(
                limitMarkerX: 10,
                dataX: fretmontCycleData?[0],
                dataY: [
                  fretmontCycleData?[1],
                  fretmontCycleData?[2],
                  fretmontCycleData?[3],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.seattle.transportation.brodway_title'),
                      legendX:
                          translate('city_data.seattle.transportation.date'),
                      chartData: {
                        translate('city_data.seattle.transportation.total'):
                            Colors.blue,
                        translate('city_data.seattle.transportation.nb'):
                            Colors.yellow,
                        translate('city_data.seattle.transportation.sb'):
                            Colors.red,
                      },
                      markerIntervalX: 23,
                      barWidth: 1)
                  .chartParser(
                limitMarkerX: 10,
                dataX: brodwayCycleData?[0],
                dataY: [
                  brodwayCycleData?[1],
                  brodwayCycleData?[2],
                  brodwayCycleData?[3],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.seattle.transportation.westlake_title'),
                      legendX:
                          translate('city_data.seattle.transportation.date'),
                      chartData: {
                        translate('city_data.seattle.transportation.total'):
                            Colors.blue,
                        translate('city_data.seattle.transportation.north'):
                            Colors.yellow,
                        translate('city_data.seattle.transportation.south'):
                            Colors.red,
                      },
                      markerIntervalX: 23,
                      barWidth: 1)
                  .chartParser(
                limitMarkerX: 10,
                dataX: westlakeCycleData?[0],
                dataY: [
                  westlakeCycleData?[1],
                  westlakeCycleData?[2],
                  westlakeCycleData?[3],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.seattle.transportation.annual_title'),
                      legendX:
                          translate('city_data.seattle.transportation.element'),
                      chartData: {
                        translate('city_data.seattle.transportation.spaces'):
                            Colors.blue,
                        translate(
                                'city_data.seattle.transportation.vehicle_count'):
                            Colors.yellow,
                      },
                      barWidth: 1)
                  .chartParser(
                dataX: annualParkingData?[0],
                dataY: [
                  annualParkingData?[7],
                  annualParkingData?[8],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.seattle.transportation.traffic_title'),
                      legendX: translate('city_data.seattle.transportation.id'),
                      chartData: {
                        translate(
                                'city_data.seattle.transportation.actual_days'):
                            Colors.blue,
                        translate(
                                'city_data.seattle.transportation.study_length'):
                            Colors.yellow,
                      },
                      barWidth: 4)
                  .chartParser(
                dataX: trafficCountData?[0],
                dataY: [
                  trafficCountData?[9],
                  trafficCountData?[11],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.seattle.transportation.npbd_title'),
                      legendX: translate(
                          'city_data.seattle.transportation.location'),
                      chartData: {
                        translate('city_data.seattle.transportation.may'):
                            Colors.blue,
                        translate('city_data.seattle.transportation.july'):
                            Colors.yellow,
                        translate('city_data.seattle.transportation.sept'):
                            Colors.red,
                      },
                      barWidth: 4,
                      markerIntervalX: 6)
                  .chartParser(
                limitMarkerX: 10,
                dataX: nbpdData?[0],
                dataY: [
                  nbpdData?[2],
                  nbpdData?[3],
                  nbpdData?[4],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.seattle.transportation.short_bike_title'),
                      legendX: translate('city_data.seattle.transportation.id'),
                      chartData: {
                        translate('city_data.seattle.transportation.day1'):
                            Colors.blue,
                        translate('city_data.seattle.transportation.day4'):
                            Colors.yellow,
                      },
                      barWidth: 4)
                  .chartParser(
                dataX: shortBikeData?[0],
                dataY: [
                  shortBikeData?[5],
                  shortBikeData?[8],
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
