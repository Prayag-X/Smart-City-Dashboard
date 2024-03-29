import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:screenshot/screenshot.dart';

import '../../../data/downloadable_content.dart';
import '../widgets/charts/line_chart_parser.dart';
import '../widgets/load_balloon.dart';
import '../../../pages/dashboard/widgets/charts/pie_chart_parser.dart';
import '../../../utils/extensions.dart';
import '../../../constants/constants.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/csv_parser.dart';

class SeattleFinance extends ConsumerStatefulWidget {
  const SeattleFinance({super.key});

  @override
  ConsumerState createState() => _SeattleFinanceTabLeftState();
}

class _SeattleFinanceTabLeftState extends ConsumerState<SeattleFinance> {
  ScreenshotController screenshotController = ScreenshotController();
  List<List<dynamic>>? data;
  List<List<dynamic>>? fleetData;
  List<List<dynamic>>? endorsedBudgetData;
  List<List<dynamic>>? openBudgetData;
  List<List<dynamic>>? operatingBudgetData;
  List<List<dynamic>>? adoptedBudgetData;
  List<List<dynamic>>? cipData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Fleet for auction']!);
      setState(() {
        fleetData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['2014 Endorsed budget']!);
      setState(() {
        endorsedBudgetData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Open Budget']!);
      setState(() {
        openBudgetData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['2011-16 CIP']!);
      setState(() {
        cipData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Operating budget']!,
          limit: -1);
      setState(() {
        operatingBudgetData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['2019-20 Adopted Budget']!);
      setState(() {
        adoptedBudgetData = FileParser.transformer(data!);
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
                          translate('city_data.seattle.finance.auction_title'),
                      subTitle: translate('city_data.seattle.finance.auction'))
                  .chartParser(data: fleetData?[2]),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                title: translate(
                    'city_data.seattle.finance.endorsed_budget_title'),
                legendX: translate('city_data.seattle.finance.bcl'),
                chartData: {
                  translate('city_data.seattle.finance.expenditure_allowed'):
                      Colors.blue,
                },
              ).chartParser(
                dataX: endorsedBudgetData?[2],
                dataY: [
                  endorsedBudgetData?[5],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                title: translate('city_data.seattle.finance.open_budget_title'),
                legendX: translate('city_data.seattle.finance.year'),
                chartData: {
                  translate('city_data.seattle.finance.approved_amount'):
                      Colors.green,
                },
              ).chartParserWithDuplicate(
                sortX: true,
                dataX: openBudgetData?[0],
                dataY: [openBudgetData?[10]],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate('city_data.seattle.finance.cip_title'),
                      legendX: translate('city_data.seattle.finance.bcl_only'),
                      chartData: {
                        translate('city_data.seattle.finance.2011'):
                            Colors.blue,
                        translate('city_data.seattle.finance.2013'):
                            Colors.yellow,
                        translate('city_data.seattle.finance.2015'): Colors.red,
                      },
                      barWidth: 4,
                      markerIntervalY: 6)
                  .chartParser(
                dataX: cipData?[1],
                dataY: [
                  cipData?[3],
                  cipData?[5],
                  cipData?[7],
                ],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                title: translate(
                    'city_data.seattle.finance.operating_budget_title'),
                legendX: translate('city_data.seattle.finance.year'),
                chartData: {
                  translate('city_data.seattle.finance.approved_amount'):
                      Colors.green,
                },
              ).chartParserWithDuplicate(
                dataX: operatingBudgetData?[0],
                dataY: [operatingBudgetData?[8]],
              ),
              Const.dashboardUISpacing.ph,
              LineChartParser(
                      title: translate(
                          'city_data.seattle.finance.adopted_budget_title'),
                      legendX: translate('city_data.seattle.finance.code'),
                      chartData: {
                        translate('city_data.seattle.finance.2018_adopted'):
                            Colors.blue,
                        translate('city_data.seattle.finance.2019_adopted'):
                            Colors.yellow,
                        translate('city_data.seattle.finance.2020_endorsed'):
                            Colors.red.withOpacity(0.5),
                      },
                      barWidth: 4)
                  .chartParser(
                dataX: adoptedBudgetData?[0],
                dataY: [
                  adoptedBudgetData?[4],
                  adoptedBudgetData?[5],
                  adoptedBudgetData?[6],
                ],
              ),
              Const.dashboardUISpacing.ph,
            ],
          ),
        ),
      ),
    );
  }
}
