import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:screenshot/screenshot.dart';

import '../downloadable_content.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/charts/pie_chart_parser.dart';
import '../widgets/dashboard_container.dart';
import '../widgets/load_balloon.dart';
import '../../../constants/images.dart';
import '../../../utils/extensions.dart';
import '../../../constants/constants.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';

class NYCEnvironment extends ConsumerStatefulWidget {
  const NYCEnvironment({super.key});

  @override
  ConsumerState createState() => _NYCEnvironmentTabLeftState();
}

class _NYCEnvironmentTabLeftState extends ConsumerState<NYCEnvironment> {
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
              LineChartParser(
                  title: translate(
                      'city_data.new_york.environment.water_consumption_title'),
                  legendX: translate('city_data.new_york.environment.year'),
                  chartData: {
                    translate('city_data.new_york.environment.population'):
                        Colors.red,
                    translate(
                            'city_data.new_york.environment.water_consumption'):
                        Colors.blue
                  }).chartParser(
                  dataX: waterConsumptionData?[0],
                  dataY: [waterConsumptionData?[1], waterConsumptionData?[2]]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate('city_data.new_york.environment.gas'),
                      chartData: {
                        translate('city_data.new_york.environment.consumption'):
                            Colors.greenAccent,
                      },
                      legendX: translate('city_data.new_york.environment.zip'),
                      barWidth: 3)
                  .chartParser(limitMarkerX: 5, dataX: gasData?[0], dataY: [
                gasData?[2],
              ]),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title: translate(
                          'city_data.new_york.environment.squirrel_data'),
                      subTitle:
                          translate('city_data.new_york.environment.squirrel'))
                  .chartParser(data: squirrelData?[9]),
              Const.dashboardUISpacing.ph,
            ],
          ),
        ),
      ),
    );
  }
}
