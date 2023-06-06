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
import '../../../providers/settings_providers.dart';
import '../../../ssh_lg/ssh.dart';

class WeatherTab extends ConsumerStatefulWidget {
  const WeatherTab({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LeftPanelState();
}

class _LeftPanelState extends ConsumerState<WeatherTab> {
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            realtimeWeather != null
                ? DashboardContainer(
                    title: TextConst.today,
                    data: realtimeWeather!.current.condition.text,
                    image: realtimeWeather!.current.condition.icon.parseIcon,
                  )
                : const BlankDashboardContainer(),
            realtimeWeather != null
                ? DashboardContainer(
                    title: TextConst.wind,
                    data:
                        '${realtimeWeather!.current.windKph} Km/h ${realtimeWeather!.current.windDegree}°${realtimeWeather!.current.windDir}',
                    image: ImageConst.windLogo,
                  )
                : const BlankDashboardContainer(),
          ],
        ),
        Const.dashboardUISpacing.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            realtimeWeather != null
                ? DashboardContainer(
                    title: TextConst.temperature,
                    data: '${realtimeWeather!.current.tempC}°C',
                    image: ImageConst.temperatureLogo,
                    showPercentage: true,
                    percentage:
                        realtimeWeather!.current.tempC.setTemperaturePercentage,
                    progressColor: Colors.red,
                  )
                : const BlankDashboardContainer(),
            realtimeWeather != null
                ? DashboardContainer(
              title: TextConst.feels,
              data: '${realtimeWeather!.current.feelslikeC}°C',
              image: ImageConst.temperatureLogo,
              showPercentage: true,
              percentage:  realtimeWeather!.current.feelslikeC.setTemperaturePercentage,
              progressColor: Colors.orange,
            )
                : const BlankDashboardContainer(),
          ],
        ),
        Const.dashboardUISpacing.ph,
        const BlankDashboardContainer(
          heightMultiplier: 2,
          widthMultiplier: 2,
        ),
        Const.dashboardUISpacing.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            realtimeWeather != null
                ? DashboardContainer(
              title: TextConst.humidity,
              data: '${realtimeWeather!.current.humidity}%',
              image: ImageConst.humidityLogo,
              showPercentage: true,
              percentage: realtimeWeather!.current.humidity.setPercentage,
              progressColor: Colors.blue,
            )
                : const BlankDashboardContainer(),
            realtimeWeather != null
                ? DashboardContainer(
                    title: TextConst.cloud,
                    data: '${realtimeWeather!.current.cloud}%',
                    image: ImageConst.cloudLogo,
                    showPercentage: true,
                    percentage: realtimeWeather!.current.cloud.setPercentage,
                    progressColor: Colors.purple,
                  )
                : const BlankDashboardContainer(),
          ],
        ),
        Const.dashboardUISpacing.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            realtimeWeather != null
                ? DashboardContainer(
              title: TextConst.uv,
              data: '${realtimeWeather!.current.uv}%',
              image: ImageConst.uvLogo,
              showPercentage: true,
              percentage: realtimeWeather!.current.uv.setPercentage,
              progressColor: Colors.yellow,
            )
                : const BlankDashboardContainer(),
            realtimeWeather != null
                ? DashboardContainer(
              title: TextConst.pressure,
              data: '${realtimeWeather!.current.pressureMb} mb',
              image: ImageConst.pressureLogo,
              showPercentage: true,
              percentage: realtimeWeather!.current.pressureMb.setPressurePercentage,
              progressColor: Colors.pinkAccent,
            )
                : const BlankDashboardContainer(),
          ],
        ),
      ],
    );
  }
}
