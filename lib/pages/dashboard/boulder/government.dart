import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:screenshot/screenshot.dart';

import '../downloadable_content.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/charts/pie_chart_parser.dart';
import '../widgets/load_balloon.dart';
import '../../../utils/extensions.dart';
import '../../../constants/constants.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';

class BoulderGovernment extends ConsumerStatefulWidget {
  const BoulderGovernment({super.key});

  @override
  ConsumerState createState() => _BoulderGovernmentTabLeftState();
}

class _BoulderGovernmentTabLeftState
    extends ConsumerState<BoulderGovernment> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? boardData;
  List<List<dynamic>>? accountData;
  List<List<dynamic>>? businessData;
  List<List<dynamic>>? licenseData;
  List<List<dynamic>>? bicycleData;
  List<List<dynamic>>? osmpData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Boards Applicants']!);
      setState(() {
        boardData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Account Payable']!);
      setState(() {
        accountData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Active Business Licenses']!);
      setState(() {
        businessData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Licensed Contractors']!);
      setState(() {
        licenseData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Bicyclist and Pedestrians']!);
      setState(() {
        bicycleData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['OSMP']!);
      setState(() {
        osmpData = FileParser.transformer(data!);
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
                      title:
                          translate('city_data.boulder.government.board_title'),
                      subTitle:
                          translate('city_data.boulder.government.applicants'))
                  .chartParser(data: boardData?[5]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.boulder.government.account_title'),
                      legendX: translate('city_data.boulder.government.id'),
                      chartData: {
                        translate('city_data.boulder.government.transaction'):
                            Colors.yellow,
                        translate('city_data.boulder.government.fund'):
                            Colors.blue.withOpacity(0.5)
                      },
                      barWidth: 1)
                  .chartParser(
                      dataX: accountData?[10],
                      dataY: [accountData?[2], accountData?[4]]),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title: translate(
                          'city_data.boulder.government.business_title'),
                      subTitle:
                          translate('city_data.boulder.government.businesses'))
                  .chartParser(data: businessData?[5]),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title: translate(
                          'city_data.boulder.government.license_title'),
                      subTitle:
                          translate('city_data.boulder.government.contractors'))
                  .chartParser(data: licenseData?[2]),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title: translate(
                          'city_data.boulder.government.bicyclist_title'),
                      subTitle:
                          translate('city_data.boulder.government.people'))
                  .chartParser(data: bicycleData?[13]),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title:
                          translate('city_data.boulder.government.osmp_title'),
                      subTitle: translate('city_data.boulder.government.osmp'))
                  .chartParser(data: osmpData?[2]),
              Const.dashboardUISpacing.ph,
            ],
          ),
        ),
      ),
    );
  }
}
