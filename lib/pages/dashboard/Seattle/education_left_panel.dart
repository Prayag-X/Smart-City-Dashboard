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

class SeattleEducationTabLeft extends ConsumerStatefulWidget {
  const SeattleEducationTabLeft({super.key});

  @override
  ConsumerState createState() => _SeattleEducationTabLeftState();
}

class _SeattleEducationTabLeftState
    extends ConsumerState<SeattleEducationTabLeft> {
  ScreenshotController screenshotController = ScreenshotController();
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
              tsgOverallData != null
                  ? LineChartParser(
                          title: translate(
                              'city_data.seattle.education.tsg_overall_title'),
                          legendX: translate('city_data.seattle.education.group'),
                          chartData: {
                            translate('city_data.seattle.education.percentage'):
                                Colors.blue,
                            translate('city_data.seattle.education.avg_met'):
                                Colors.yellow,
                            translate(
                                    'city_data.seattle.education.children_count'):
                                Colors.red,
                          },
                          barWidth: 4)
                      .chartParser(
                      limitMarkerX: 10,
                      dataX: tsgOverallData![1],
                      dataY: [
                        tsgOverallData![2],
                        tsgOverallData![3],
                        tsgOverallData![4],
                      ],
                    )
                  : const BlankDashboardContainer(
                      heightMultiplier: 2,
                      widthMultiplier: 2,
                    ),
              Const.dashboardUISpacing.ph,
              tsgDomainData != null
                  ? LineChartParser(
                          title: translate(
                              'city_data.seattle.education.tsg_domain_title'),
                          legendX: translate('city_data.seattle.education.group'),
                          chartData: {
                            translate('city_data.seattle.education.lan_met'):
                                Colors.blue,
                            translate('city_data.seattle.education.literacy_met'):
                                Colors.yellow,
                            translate(
                                    'city_data.seattle.education.children_count'):
                                Colors.red,
                          },
                          barWidth: 4)
                      .chartParser(
                      limitMarkerX: 10,
                      dataX: tsgDomainData![1],
                      dataY: [
                        tsgDomainData![2],
                        tsgDomainData![3],
                        tsgDomainData![8],
                      ],
                    )
                  : const BlankDashboardContainer(
                      heightMultiplier: 2,
                      widthMultiplier: 2,
                    ),
              Const.dashboardUISpacing.ph,
              sppEnrollmentData != null
                  ? LineChartParser(
                          title: translate(
                              'city_data.seattle.education.spp_title'),
                          legendX: translate('city_data.seattle.education.year'),
                          chartData: {
                            translate(
                                    'city_data.seattle.education.children_count'):
                                Colors.blue,
                          },
                          barWidth: 4)
                      .chartParser(
                      limitMarkerX: 8,
                      dataX: sppEnrollmentData![0],
                      dataY: [
                        sppEnrollmentData![2],
                      ],
                    )
                  : const BlankDashboardContainer(
                      heightMultiplier: 2,
                      widthMultiplier: 2,
                    ),
              Const.dashboardUISpacing.ph,
              sppSPSData != null
                  ? LineChartParser(
                          title: translate(
                              'city_data.seattle.education.spp_sps_title'),
                          legendX: translate('city_data.seattle.education.year'),
                          chartData: {
                            translate(
                                    'city_data.seattle.education.children_count'):
                                Colors.blue,
                          },
                          barWidth: 4)
                      .chartParser(
                      limitMarkerX: 8,
                      dataX: sppSPSData![1],
                      dataY: [
                        sppSPSData![2],
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
