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

class BoulderGovernmentTabLeft extends ConsumerStatefulWidget {
  const BoulderGovernmentTabLeft({super.key});

  @override
  ConsumerState createState() => _BoulderGovernmentTabLeftState();
}

class _BoulderGovernmentTabLeftState
    extends ConsumerState<BoulderGovernmentTabLeft> {
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
              boardData != null
                  ? PieChartParser(
                          title: translate(
                              'city_data.boulder.government.board_title'),
                          subTitle: translate(
                              'city_data.boulder.government.applicants'))
                      .chartParser(data: boardData![5])
                  : const BlankDashboardContainer(
                      heightMultiplier: 2,
                      widthMultiplier: 2,
                    ),
              Const.dashboardUISpacing.ph,
              accountData != null
                  ? LineChartParser(
                      title: translate(
                          'city_data.boulder.government.account_title'),
                      legendX: translate('city_data.boulder.government.id'),
                      chartData: {
                          translate('city_data.boulder.government.transaction'):
                              Colors.yellow,
                          translate(
                                  'city_data.boulder.government.fund'):
                              Colors.blue.withOpacity(0.5)
                        }, barWidth: 1).chartParser(
                      dataX: accountData![10],
                      dataY: [
                        accountData![2],
                        accountData![4]
                      ])
                  : const BlankDashboardContainer(
                      heightMultiplier: 2,
                      widthMultiplier: 2,
                    ),
              Const.dashboardUISpacing.ph,
              businessData != null
                  ? PieChartParser(
                  title: translate(
                      'city_data.boulder.government.business_title'),
                  subTitle: translate(
                      'city_data.boulder.government.businesses'))
                  .chartParser(data: businessData![5])
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              licenseData != null
                  ? PieChartParser(
                  title: translate(
                      'city_data.boulder.government.license_title'),
                  subTitle: translate(
                      'city_data.boulder.government.contractors'))
                  .chartParser(data: licenseData![2])
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              bicycleData != null
                  ? PieChartParser(
                  title: translate(
                      'city_data.boulder.government.bicyclist_title'),
                  subTitle: translate(
                      'city_data.boulder.government.people'))
                  .chartParser(data: bicycleData![13])
                  : const BlankDashboardContainer(
                heightMultiplier: 2,
                widthMultiplier: 2,
              ),
              Const.dashboardUISpacing.ph,
              osmpData != null
                  ? PieChartParser(
                  title: translate(
                      'city_data.boulder.government.osmp_title'),
                  subTitle: translate(
                      'city_data.boulder.government.osmp'))
                  .chartParser(data: osmpData![2])
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
