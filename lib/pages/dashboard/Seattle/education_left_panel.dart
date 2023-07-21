import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_city_dashboard/connections/downloader.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/kml_makers/kml_makers.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/pie_chart.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/pie_chart_parser.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/dashboard_right_panel.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../constants/constants.dart';
import '../../../constants/data.dart';
import '../downloadable_content.dart';
import '../../../constants/images.dart';
import '../../../constants/theme.dart';
import '../../../models/city_card_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../connections/ssh.dart';
import '../../../utils/csv_parser.dart';
import '../../../utils/helper.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/dashboard_container.dart';

class SeattleEducationTabLeft extends ConsumerStatefulWidget {
  const SeattleEducationTabLeft({super.key});

  @override
  ConsumerState createState() => _SeattleEducationTabLeftState();
}

class _SeattleEducationTabLeftState extends ConsumerState<SeattleEducationTabLeft> {
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
            fretmontCycleData != null
                ? LineChartParser(
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
              dataX: fretmontCycleData![0],
              dataY: [
                fretmontCycleData![1],
                fretmontCycleData![2],
                fretmontCycleData![3],
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
    );
  }
}
