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

class WeatherTabRight extends ConsumerStatefulWidget {
  const WeatherTabRight({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LeftPanelState();
}

class _LeftPanelState extends ConsumerState<WeatherTabRight> {
  WeatherApi weatherApi = WeatherApi();
  RealtimeWeather? realtimeWeather;
  ForecastWeather? forecastWeather;

  getWeather() async {
    await Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      var realtimeWeatherX = await weatherApi
          .getCurrentWeather(ref.read(cityDataProvider)!.cityName);
      var forecastWeatherY = await weatherApi
          .getForecastWeather(ref.read(cityDataProvider)!.cityName);
      setState(() {
        realtimeWeather = realtimeWeatherX;
        forecastWeather = forecastWeatherY;
      });
      ref.read(isLoadingProvider.notifier).state = false;
    });
    // print(x);
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
