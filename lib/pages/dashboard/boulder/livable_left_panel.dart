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

class BoulderLivableTabLeft extends ConsumerStatefulWidget {
  const BoulderLivableTabLeft({super.key});

  @override
  ConsumerState createState() => _BoulderLivableTabLeftState();
}

class _BoulderLivableTabLeftState extends ConsumerState<BoulderLivableTabLeft> {
  List<List<dynamic>>? data;
  List<List<dynamic>>? buildingData;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Building Use and Square Footage']!);
      setState(() {
        buildingData = FileParser.transformer(data!);
      });
      data = await FileParser.parseCSVFromStorage(
          DownloadableContent.content['Building Use and Square Footage']!);
      setState(() {
        buildingData = FileParser.transformer(data!);
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
          ],
        ),
      ),
    );
  }
}
