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

class TorontoGovernmentTabLeft extends ConsumerStatefulWidget {
  const TorontoGovernmentTabLeft({super.key});

  @override
  ConsumerState createState() => _TorontoGovernmentTabLeftState();
}

class _TorontoGovernmentTabLeftState extends ConsumerState<TorontoGovernmentTabLeft> {
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
              registryData != null
                  ? LineChartParser(
                  title:
                  translate('city_data.chicago.ethics.registry_title'),
                  legendX: translate('city_data.chicago.ethics.id'),
                  chartData: {
                    translate('city_data.chicago.ethics.registration'):
                    Colors.blue,
                  }, barWidth: 2
              ).chartParser(
                // limitMarkerX: 8,
                dataX: registryData![1],
                dataY: [
                  registryData![47],
                ],
              )
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              clientsData != null
                  ? PieChartParser(
                  title: translate(
                      'city_data.chicago.ethics.client_title'),
                  subTitle: translate(
                      'city_data.chicago.ethics.clients'))
                  .chartParser(data: clientsData![0])
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              lobbyistData != null
                  ? PieChartParser(
                  title: translate(
                      'city_data.chicago.ethics.lobbyist_title'),
                  subTitle: translate(
                      'city_data.chicago.ethics.lobbyist_title'))
                  .chartParser(data: lobbyistData![0])
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              contributorsData != null
                  ? LineChartParser(
                  title:
                  translate('city_data.chicago.ethics.contributions_title'),
                  legendX: translate('city_data.chicago.ethics.id'),
                  chartData: {
                    translate('city_data.chicago.ethics.amount'):
                    Colors.blue,
                  },barWidth: 2
              ).chartParser(
                limitMarkerX: 6,
                dataX: contributorsData![0],
                dataY: [
                  contributorsData![5],
                ],
              )
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              expenditure1Data != null
                  ? LineChartParser(
                title:
                translate('city_data.chicago.ethics.expense1_title'),
                legendX: translate('city_data.chicago.ethics.name'),
                chartData: {
                  translate('city_data.chicago.ethics.expenses'):
                  Colors.blue,
                },
              ).chartParser(
                limitMarkerX: 6,
                dataX: expenditure1Data![2],
                dataY: [
                  expenditure1Data![11],
                ],
              )
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              expenditure2Data != null
                  ? LineChartParser(
                  title:
                  translate('city_data.chicago.ethics.expense2_title'),
                  legendX: translate('city_data.chicago.ethics.id'),
                  chartData: {
                    translate('city_data.chicago.ethics.expenses'):
                    Colors.blue,
                  }, barWidth: 6
              ).chartParser(
                limitMarkerX: 6,
                dataX: expenditure2Data![0],
                dataY: [
                  expenditure2Data![7],
                ],
              )
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
