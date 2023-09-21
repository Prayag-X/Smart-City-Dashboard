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

class NYCEducation extends ConsumerStatefulWidget {
  const NYCEducation({super.key});

  @override
  ConsumerState createState() => _NYCEducationTabLeftState();
}

class _NYCEducationTabLeftState extends ConsumerState<NYCEducation> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? satData;
  List<List<dynamic>>? mathData;
  List<List<dynamic>>? attendanceData;
  List<List<dynamic>>? bilingualData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['SAT result']!);
      setState(() {
        satData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Math result']!);
      setState(() {
        mathData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Attendance']!);
      setState(() {
        attendanceData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Bilingual program']!);
      setState(() {
        bilingualData = FileParser.transformer(data!);
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
                          translate('city_data.new_york.education.sat_title'),
                      legendX: translate('city_data.new_york.education.dbn'),
                      chartData: {
                        translate('city_data.new_york.education.students'):
                            Colors.blue,
                        translate('city_data.new_york.education.reading'):
                            Colors.red.withOpacity(0.7),
                        translate('city_data.new_york.education.math'):
                            Colors.yellow.withOpacity(0.8),
                        translate('city_data.new_york.education.writing'):
                            Colors.green.withOpacity(0.8),
                      },
                      markerIntervalY: 7,
                      barWidth: 1)
                  .chartParser(
                dataX: satData?[0],
                dataY: [satData?[2], satData?[3], satData?[4], satData?[5]],
              ),
              Const.dashboardUISpacing.ph,
              PieChartParser(
                      title: translate(
                          'city_data.new_york.education.bilingual_title'),
                      subTitle:
                          translate('city_data.new_york.education.school'))
                  .chartParser(data: bilingualData?[7]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title:
                          translate('city_data.new_york.education.math_title'),
                      legendX: translate('city_data.new_york.education.year'),
                      chartData: {
                        translate('city_data.new_york.education.num'):
                            Colors.blue,
                        translate('city_data.new_york.education.score'):
                            Colors.brown,
                      },
                      markerIntervalX: 1)
                  .chartParserWithDuplicate(
                      dataX: mathData?[2],
                      dataY: [mathData?[4], mathData?[5]],
                      sortX: true),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.new_york.education.attendance_title'),
                      legendX:
                          translate('city_data.new_york.education.district'),
                      chartData: {
                        translate('city_data.new_york.education.attendance'):
                            Colors.yellow,
                        translate('city_data.new_york.education.enrollment'):
                            Colors.green,
                      },
                      markerIntervalX: 6)
                  .chartParser(
                dataX: attendanceData?[0],
                dataY: [attendanceData?[1], attendanceData?[2]],
              ),
              Const.dashboardUISpacing.ph,
            ],
          ),
        ),
      ),
    );
  }
}
