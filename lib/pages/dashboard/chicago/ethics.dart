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

class ChicagoEthics extends ConsumerStatefulWidget {
  const ChicagoEthics({super.key});

  @override
  ConsumerState createState() => _ChicagoEthicsTabLeftState();
}

class _ChicagoEthicsTabLeftState extends ConsumerState<ChicagoEthics> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? registryData;
  List<List<dynamic>>? clientsData;
  List<List<dynamic>>? lobbyistData;
  List<List<dynamic>>? contributorsData;
  List<List<dynamic>>? expenditure1Data;
  List<List<dynamic>>? expenditure2Data;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Registry']!);
      setState(() {
        registryData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Lobby Clients']!);
      setState(() {
        clientsData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Lobby lobbyist']!);
      setState(() {
        lobbyistData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Lobby contributors']!);
      setState(() {
        contributorsData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Lobby expenditure 1']!);
      setState(() {
        expenditure1Data = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Lobby expenditure 2']!);
      setState(() {
        expenditure2Data = FileParser.transformer(data!);
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
                          translate('city_data.chicago.ethics.registry_title'),
                      legendX: translate('city_data.chicago.ethics.id'),
                      chartData: {
                        translate('city_data.chicago.ethics.registration'):
                            Colors.blue,
                      },
                      barWidth: 2)
                  .chartParser(
                // limitMarkerX: 8,
                dataX: registryData?[1],
                dataY: [
                  registryData?[47],
                ],
              ),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title: translate('city_data.chicago.ethics.client_title'),
                      subTitle: translate('city_data.chicago.ethics.clients'))
                  .chartParser(data: clientsData?[0]),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title:
                          translate('city_data.chicago.ethics.lobbyist_title'),
                      subTitle:
                          translate('city_data.chicago.ethics.lobbyist_title'))
                  .chartParser(data: lobbyistData?[0]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.chicago.ethics.contributions_title'),
                      legendX: translate('city_data.chicago.ethics.id'),
                      chartData: {
                        translate('city_data.chicago.ethics.amount'):
                            Colors.blue,
                      },
                      barWidth: 2)
                  .chartParser(
                limitMarkerX: 6,
                dataX: contributorsData?[0],
                dataY: [
                  contributorsData?[5],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                title: translate('city_data.chicago.ethics.expense1_title'),
                legendX: translate('city_data.chicago.ethics.name'),
                chartData: {
                  translate('city_data.chicago.ethics.expenses'): Colors.blue,
                },
              ).chartParser(
                limitMarkerX: 6,
                dataX: expenditure1Data?[2],
                dataY: [
                  expenditure1Data?[11],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title:
                          translate('city_data.chicago.ethics.expense2_title'),
                      legendX: translate('city_data.chicago.ethics.id'),
                      chartData: {
                        translate('city_data.chicago.ethics.expenses'):
                            Colors.blue,
                      },
                      barWidth: 6)
                  .chartParser(
                limitMarkerX: 6,
                dataX: expenditure2Data?[0],
                dataY: [
                  expenditure2Data?[7],
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
