import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:screenshot/screenshot.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../constants/constants.dart';
import '../downloadable_content.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/dashboard_container.dart';
import '../widgets/load_balloon.dart';

class AustinTransport extends ConsumerStatefulWidget {
  const AustinTransport({super.key});

  @override
  ConsumerState createState() => _AustinTransportTabLeftState();
}

class _AustinTransportTabLeftState
    extends ConsumerState<AustinTransport> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? emsData;
  List<List<dynamic>>? transportConstructionData;
  List<List<dynamic>>? resignalData;
  List<List<dynamic>>? kioskData;
  List<List<dynamic>>? bidBookData;
  List<List<dynamic>>? selfWageData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['EMS Transport']!);
      setState(() {
        emsData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Active Transport Construction']!);
      setState(() {
        transportConstructionData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Traffic Resignal Timing']!);
      setState(() {
        resignalData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Metro bike Kiosk Locations']!);
      setState(() {
        kioskData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Bid Book Spreadsheet']!);
      setState(() {
        bidBookData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Self Sufficiency wage']!);
      setState(() {
        selfWageData = FileParser.transformer(data!);
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
                      title: translate('city_data.austin.transport.ems_title'),
                      legendX:
                          translate('city_data.austin.transport.dest_code'),
                      chartData: {
                        translate('city_data.austin.transport.count'):
                            Colors.yellow,
                      },
                      barWidth: 1)
                  .chartParser(dataX: emsData?[2], dataY: [
                emsData?[4],
              ]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.austin.transport.transport_construction_title'),
                      legendX: translate('city_data.austin.transport.id'),
                      chartData: {
                        translate('city_data.austin.transport.population'):
                            Colors.blue,
                        translate('city_data.austin.transport.length'):
                            Colors.red,
                        translate('city_data.austin.transport.percent'):
                            Colors.yellow,
                      },
                      barWidth: 1)
                  .chartParser(dataX: transportConstructionData?[0], dataY: [
                transportConstructionData?[10],
                transportConstructionData?[11],
                transportConstructionData?[8],
              ]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.austin.transport.resignal_title'),
                      legendX: translate('city_data.austin.transport.id'),
                      chartData: {
                        translate('city_data.austin.transport.vol'):
                            Colors.blue,
                        translate('city_data.austin.transport.seconds'):
                            Colors.red,
                        translate('city_data.austin.transport.count'):
                            Colors.yellow,
                      },
                      barWidth: 4)
                  .chartParser(dataX: resignalData?[0], dataY: [
                resignalData?[6],
                resignalData?[8],
                resignalData?[9],
              ]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title:
                          translate('city_data.austin.transport.kiosk_title'),
                      legendX: translate('city_data.austin.transport.id'),
                      chartData: {
                        translate('city_data.austin.transport.docks'):
                            Colors.blue,
                        translate('city_data.austin.transport.length'):
                            Colors.red,
                        translate('city_data.austin.transport.width'):
                            Colors.yellow,
                      },
                      barWidth: 2)
                  .chartParser(dataX: kioskData?[0], dataY: [
                kioskData?[8],
                kioskData?[10],
                kioskData?[11],
              ]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                title: translate('city_data.austin.transport.bid_book_title'),
                legendX: translate('city_data.austin.transport.agency_code'),
                chartData: {
                  translate('city_data.austin.transport.quantity'):
                      Colors.yellow,
                },
              ).chartParser(dataX: bidBookData?[0], dataY: [
                bidBookData?[6],
              ]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.austin.transport.self_wage_title'),
                      legendX: translate('city_data.austin.transport.fam_code'),
                      chartData: {
                        translate('city_data.austin.transport.housing_cost'):
                            Colors.blue,
                        translate('city_data.austin.transport.transport_cost'):
                            Colors.yellow,
                      },
                      barWidth: 2)
                  .chartParser(
                      dataX: selfWageData?[4],
                      dataY: [
                        selfWageData?[10],
                        selfWageData?[14],
                      ],
                      limitMarkerX: 6),
              Const.dashboardUISpacing.ph,
            ],
          ),
        ),
      ),
    );
  }
}
