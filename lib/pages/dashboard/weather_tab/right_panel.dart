import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/models/realtime_weather.dart';
import 'package:smart_city_dashboard/pages/dashboard/dashboard_container.dart';
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/services/weather_api.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';

import '../../../constants/constants.dart';
import '../../../constants/texts.dart';
import '../../../constants/theme.dart';
import '../../../providers/data_providers.dart';
import '../../../providers/settings_providers.dart';
import '../../../ssh_lg/ssh.dart';

class WeatherTabRight extends ConsumerWidget {
  const WeatherTabRight({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ForecastWeather? weatherData = ref.watch(weatherDataProvider);
    return Column(
      children: [
        Container(height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(TextConst.upcoming,
              style: textStyleNormal.copyWith(
                  fontSize: 17, color: Colors.white.withOpacity(0.5)),
            ),
            Text(TextConst.tempMax,
              style: textStyleNormal.copyWith(
                  fontSize: 17, color: Colors.white.withOpacity(0.5)),
            ),
            Text(TextConst.tempMin,
              style: textStyleNormal.copyWith(
                  fontSize: 17, color: Colors.white.withOpacity(0.5)),
            ),
            Text(TextConst.humidity,
              style: textStyleNormal.copyWith(
                  fontSize: 17, color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),),
        Divider(
          color: Colors.white,
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Container(),
        )
      ],
    );
  }
}
