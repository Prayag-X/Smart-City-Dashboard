import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csv/csv.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/constants/data.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/models/realtime_weather.dart';
import 'package:smart_city_dashboard/pages/dashboard/dashboard_container.dart';
import 'package:smart_city_dashboard/pages/dashboard/weather_tab/chart_parser.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/services/weather_api.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';

import '../../../constants/constants.dart';
import '../../../constants/texts.dart';
import '../../../constants/theme.dart';
import '../../../providers/settings_providers.dart';
import '../../../ssh_lg/ssh.dart';
import '../dashboard_chart.dart';

class AboutTabLeft extends ConsumerStatefulWidget {
  const AboutTabLeft({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AboutTabLeftState();
}

class _AboutTabLeftState extends ConsumerState<AboutTabLeft> {
  List<List<dynamic>> data = [];
  int cityIndex = -1;

  loadCSVData() async {
    Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      final rawData = await rootBundle.loadString(DataConst.about);
      data = const CsvToListConverter(eol: '\n').convert(rawData);
      for (var row in data) {
        if (row[1].toLowerCase() ==
            ref.read(cityDataProvider)!.cityName.toLowerCase()) {
          cityIndex = data.indexOf(row);
        }
      }
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

          ],
        ),
      ),
    );
  }
}
