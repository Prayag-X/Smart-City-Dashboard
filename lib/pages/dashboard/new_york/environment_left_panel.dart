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

class NYCEnvironmentTabLeft extends ConsumerStatefulWidget {
  const NYCEnvironmentTabLeft({super.key});

  @override
  ConsumerState createState() => _NYCEnvironmentTabLeftState();
}

class _NYCEnvironmentTabLeftState extends ConsumerState<NYCEnvironmentTabLeft> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? waterConsumptionData;
  List<List<dynamic>>? squirrelData;
  List<List<dynamic>>? gasData;
  int trees = 683788;
  int recycleBins = 135;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Water Consumption']!);
      setState(() {
        waterConsumptionData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Squirrel Data']!);
      setState(() {
        squirrelData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Natural gas consumption']!);
      setState(() {
        gasData = FileParser.transformer(data!);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashboardContainer(
                    title: translate('city_data.new_york.environment.trees'),
                    data: trees.toString(),
                    image: ImageConst.tree,
                    showPercentage: true,
                    percentage: trees.setTreePercentage,
                    progressColor: Colors.green,
                  ),
                  DashboardContainer(
                    title: translate('city_data.new_york.environment.bins'),
                    data: recycleBins.toString(),
                    image: ImageConst.bin,
                    showPercentage: true,
                    percentage: 0,
                  ),
                ],
              ),
              Const.dashboardUISpacing.ph,
              waterConsumptionData != null
                  ? LineChartParser(
                      title: translate(
                          'city_data.new_york.environment.water_consumption_title'),
                      legendX: translate('city_data.new_york.environment.year'),
                      chartData: {
                          translate(
                                  'city_data.new_york.environment.population'):
                              Colors.red,
                          translate(
                                  'city_data.new_york.environment.water_consumption'):
                              Colors.blue
                        }).chartParser(dataX: waterConsumptionData![0], dataY: [
                      waterConsumptionData![1],
                      waterConsumptionData![2]
                    ])
                  : const BlankDashboardContainer(
                      heightMultiplier: 2,
                      widthMultiplier: 2,
                    ),
              Const.dashboardUISpacing.ph,
              gasData != null
                  ? LineChartParser(
                          title:
                              translate('city_data.new_york.environment.gas'),
                          chartData: {
                            translate(
                                    'city_data.new_york.environment.consumption'):
                                Colors.greenAccent,
                          },
                          legendX:
                              translate('city_data.new_york.environment.zip'),
                          barWidth: 3)
                      .chartParser(limitMarkerX: 5, dataX: gasData![0], dataY: [
                      gasData![2],
                    ])
                  : const BlankDashboardContainer(
                      heightMultiplier: 2,
                      widthMultiplier: 2,
                    ),
              Const.dashboardUISpacing.ph,
              squirrelData != null
                  ? PieChartParser(
                          title: translate(
                              'city_data.new_york.environment.squirrel_data'),
                          subTitle: translate(
                              'city_data.new_york.environment.squirrel'))
                      .chartParser(data: squirrelData![9])
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
