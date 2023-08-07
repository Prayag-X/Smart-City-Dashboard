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

class BoulderHealthTabLeft extends ConsumerStatefulWidget {
  const BoulderHealthTabLeft({super.key});

  @override
  ConsumerState createState() => _BoulderHealthTabLeftState();
}

class _BoulderHealthTabLeftState extends ConsumerState<BoulderHealthTabLeft> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? relationData;
  List<List<dynamic>>? equityData;
  List<List<dynamic>>? serviceData;
  List<List<dynamic>>? engagementData;
  List<List<dynamic>>? orgData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Human Relation Fund']!);
      setState(() {
        relationData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Human Equity Fund']!);
      setState(() {
        equityData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Human Services Fund']!);
      setState(() {
        serviceData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Parent Engagement Event']!);
      setState(() {
        engagementData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Community Organizations Fund']!);
      setState(() {
        orgData = FileParser.transformer(data!);
      });
      await Future.delayed(Const.screenshotDelay).then((x) async {
        screenshotController.capture().then((image) async {
          img.Image? imageDecoded = img.decodePng(Uint8List.fromList(image!));
          await SSH(ref: ref).imageFileUpload(context, image);
          if (!mounted) {
            return;
          }
          await SSH(ref: ref).imageFileUploadSlave(context);
          var initialMapPosition = CameraPosition(
            target: ref.read(cityDataProvider)!.location,
            zoom: Const.appZoomScale,
          );
          if (!mounted) {
            return;
          }
          String tabName = '';
          for (var pageTab in ref.read(cityDataProvider)!.availableTabs) {
            if (pageTab.tab == ref.read(tabProvider)) {
              tabName = pageTab.nameForUrl!;
            }
          }
          ref.read(lastBalloonProvider.notifier).state = await SSH(ref: ref)
              .renderInSlave(
              context,
              ref.read(rightmostRigProvider),
              BalloonMakers.dashboardBalloon(
                  initialMapPosition,
                  ref.read(cityDataProvider)!.cityNameEnglish,
                  tabName,
                  imageDecoded!.height / imageDecoded.width));
        }).catchError((onError) {
          showSnackBar(
              context: context,
              message:
              onError.toString());
        });
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
              relationData != null
                  ? LineChartParser(
                          title:
                              translate('city_data.boulder.health.relation_fund'),
                          legendX: translate('city_data.boulder.health.id'),
                          chartData: {
                            translate('city_data.boulder.health.requested'):
                                Colors.blue,
                            translate('city_data.boulder.health.received'):
                                Colors.green,
                          },
                          barWidth: 3)
                      .chartParser(dataX: relationData![0], dataY: [
                      relationData![5],
                      relationData![6],
                    ])
                  : const BlankDashboardContainer(
                      heightMultiplier: 2,
                      widthMultiplier: 2,
                    ),
              Const.dashboardUISpacing.ph,
              equityData != null
                  ? LineChartParser(
                          title:
                              translate('city_data.boulder.health.equity_fund'),
                          legendX: translate('city_data.boulder.health.id'),
                          chartData: {
                            translate('city_data.boulder.health.requested'):
                                Colors.blue,
                            translate('city_data.boulder.health.received'):
                                Colors.green,
                          },
                          barWidth: 3)
                      .chartParser(dataX: equityData![0], dataY: [
                      equityData![8],
                      equityData![9],
                    ])
                  : const BlankDashboardContainer(
                      heightMultiplier: 2,
                      widthMultiplier: 2,
                    ),
              Const.dashboardUISpacing.ph,
              serviceData != null
                  ? LineChartParser(
                          title:
                              translate('city_data.boulder.health.service_fund'),
                          legendX: translate('city_data.boulder.health.id'),
                          chartData: {
                            translate('city_data.boulder.health.requested'):
                                Colors.blue,
                            translate('city_data.boulder.health.received'):
                                Colors.green,
                          },
                          barWidth: 3)
                      .chartParser(dataX: serviceData![0], dataY: [
                      serviceData![9],
                      serviceData![10],
                    ])
                  : const BlankDashboardContainer(
                      heightMultiplier: 2,
                      widthMultiplier: 2,
                    ),
              Const.dashboardUISpacing.ph,
              engagementData != null
                  ? LineChartParser(
                          title: translate(
                              'city_data.boulder.health.parent_engagement_events'),
                          legendX: translate('city_data.boulder.health.id'),
                          chartData: {
                            translate('city_data.boulder.health.adults'):
                                Colors.blue,
                            translate('city_data.boulder.health.children'):
                                Colors.red,
                          },
                          barWidth: 3)
                      .chartParser(dataX: engagementData![0], dataY: [
                      engagementData![9],
                      engagementData![10],
                    ])
                  : const BlankDashboardContainer(
                      heightMultiplier: 2,
                      widthMultiplier: 2,
                    ),
              Const.dashboardUISpacing.ph,
              orgData != null
                  ? LineChartParser(
                          title: translate(
                              'city_data.boulder.health.org_service_fund'),
                          legendX: translate('city_data.boulder.health.id'),
                          chartData: {
                            translate('city_data.boulder.health.requested'):
                                Colors.blue,
                            translate('city_data.boulder.health.received'):
                                Colors.green,
                          },
                          barWidth: 3)
                      .chartParser(dataX: orgData![0], dataY: [
                      orgData![7],
                      orgData![8],
                    ])
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
