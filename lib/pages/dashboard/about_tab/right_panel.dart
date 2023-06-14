import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

class AboutTabRight extends ConsumerStatefulWidget {
  const AboutTabRight({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AboutTabRightState();
}

class _AboutTabRightState extends ConsumerState<AboutTabRight> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
