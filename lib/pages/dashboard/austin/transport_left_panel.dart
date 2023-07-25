import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../constants/constants.dart';
import '../downloadable_content.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/dashboard_container.dart';

class AustinTransportTabLeft extends ConsumerStatefulWidget {
  const AustinTransportTabLeft({super.key});

  @override
  ConsumerState createState() => _AustinTransportTabLeftState();
}

class _AustinTransportTabLeftState extends ConsumerState<AustinTransportTabLeft> {
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
            sa4Data != null
                ? LineChartParser(
                title: translate('city_data.austin.health.sa4_title'),
                legendX: translate('city_data.austin.health.dept'),
                chartData: {
                  translate('city_data.austin.health.attendees'):
                  Colors.yellow,
                  translate('city_data.austin.health.eligible'):
                  Colors.blue,
                }, markerIntervalX: 6).chartParser(
                limitMarkerX: 14,
                dataX: sa4Data![0], dataY: [
              sa4Data![1],
              sa4Data![2],
            ])
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
