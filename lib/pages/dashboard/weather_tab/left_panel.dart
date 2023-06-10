import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/models/realtime_weather.dart';
import 'package:smart_city_dashboard/pages/dashboard/dashboard_container.dart';
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
import '../waste.dart';

class WeatherTabLeft extends ConsumerStatefulWidget {
  const WeatherTabLeft({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LeftPanelState();
}

class _LeftPanelState extends ConsumerState<WeatherTabLeft> {
  getWeather() async {
    await Future.delayed(Duration.zero).then((x) async {
      ref.read(isLoadingProvider.notifier).state = true;
      ref.read(weatherDataProvider.notifier).state = null;
      ref.read(weatherDataProvider.notifier).state = await WeatherApi()
          .getForecastWeather(ref.read(cityDataProvider)!.cityName);
      ref.read(isLoadingProvider.notifier).state = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    int weatherDayClicked = ref.watch(weatherDayClickedProvider);
    return weatherDayClicked == 0 ? today() : otherDay();
  }

  Column today() {
    ForecastWeather? weatherData = ref.watch(weatherDataProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.now,
                    data: weatherData.current.condition.text!,
                    image: weatherData.current.condition.icon!.parseIcon,
                  )
                : const BlankDashboardContainer(),
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.time,
                    data: weatherData.location.localtime.parseTime,
                    image: weatherData.current.isDay == 1
                        ? ImageConst.dayLogo
                        : ImageConst.nightLogo,
                  )
                : const BlankDashboardContainer(),
          ],
        ),
        Const.dashboardUISpacing.ph,
        weatherData != null
            ? DashboardContainer(
                widthMultiplier: 2,
                title: TextConst.wind,
                data:
                    '${weatherData.current.windKph} Km/h ${weatherData.current.windDegree}°${weatherData.current.windDir}',
                image: ImageConst.windLogo,
              )
            : const BlankDashboardContainer(
                widthMultiplier: 2,
              ),
        Const.dashboardUISpacing.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.temperature,
                    data: '${weatherData.current.tempC}°C',
                    image: ImageConst.temperatureLogo,
                    showPercentage: true,
                    percentage:
                        weatherData.current.tempC.setTemperaturePercentage,
                    progressColor: Colors.red,
                  )
                : const BlankDashboardContainer(),
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.feels,
                    data: '${weatherData.current.feelslikeC}°C',
                    image: ImageConst.temperatureLogo,
                    showPercentage: true,
                    percentage:
                        weatherData.current.feelslikeC.setTemperaturePercentage,
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
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.humidity,
                    data: '${weatherData.current.humidity}%',
                    image: ImageConst.humidityLogo,
                    showPercentage: true,
                    percentage: weatherData.current.humidity.setPercentage,
                    progressColor: Colors.blue,
                  )
                : const BlankDashboardContainer(),
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.cloud,
                    data: '${weatherData.current.cloud}%',
                    image: ImageConst.cloudLogo,
                    showPercentage: true,
                    percentage: weatherData.current.cloud.setPercentage,
                    progressColor: Colors.purple,
                  )
                : const BlankDashboardContainer(),
          ],
        ),
        Const.dashboardUISpacing.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.uv,
                    data: '${weatherData.current.uv}',
                    image: ImageConst.uvLogo,
                    showPercentage: true,
                    percentage: weatherData.current.uv.setUVPercentage,
                    progressColor: Colors.yellow,
                  )
                : const BlankDashboardContainer(),
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.pressure,
                    data: '${weatherData.current.pressureMb} mb',
                    image: ImageConst.pressureLogo,
                    showPercentage: true,
                    percentage:
                        weatherData.current.pressureMb.setPressurePercentage,
                    progressColor: Colors.pinkAccent,
                  )
                : const BlankDashboardContainer(),
          ],
        ),
        Const.dashboardUISpacing.ph,
        LineChartSample1(),
        Const.dashboardUISpacing.ph,
      ],
    );
  }

  Column otherDay() {
    ForecastWeather? weatherData = ref.watch(weatherDataProvider);
    int weatherDayClicked = ref.watch(weatherDayClickedProvider);
    Forecastday? forecastData =
        weatherData?.forecast.forecastday[weatherDayClicked];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.condition,
                    data: forecastData!.day.condition.text!,
                    image: forecastData.day.condition.icon!.parseIcon,
                  )
                : const BlankDashboardContainer(),
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.date,
                    data:
                        '${forecastData!.date.day}/${forecastData.date.month}',
                    image: ImageConst.calenderLogo,
                  )
                : const BlankDashboardContainer(),
          ],
        ),
        Const.dashboardUISpacing.ph,
        weatherData != null
            ? DashboardContainer(
                widthMultiplier: 2,
                title: TextConst.windMax,
                data: '${forecastData!.day.maxwindKph} Km/h',
                image: ImageConst.windLogo,
              )
            : const BlankDashboardContainer(
                widthMultiplier: 2,
              ),
        Const.dashboardUISpacing.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.tempMaxFull,
                    data: '${forecastData!.day.maxtempC}°C',
                    image: ImageConst.temperatureLogo,
                    showPercentage: true,
                    percentage:
                        forecastData.day.maxtempC.setTemperaturePercentage,
                    progressColor: Colors.red,
                  )
                : const BlankDashboardContainer(),
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.tempMaxFull,
                    data: '${forecastData!.day.mintempC}°C',
                    image: ImageConst.temperatureLogo,
                    showPercentage: true,
                    percentage:
                        forecastData.day.mintempC.setTemperaturePercentage,
                    progressColor: Colors.blue,
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
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.uv,
                    data: forecastData!.day.uv.toString(),
                    image: ImageConst.uvLogo,
                    showPercentage: true,
                    percentage: forecastData.day.uv.setUVPercentage,
                    progressColor: Colors.yellow,
                  )
                : const BlankDashboardContainer(),
            weatherData != null
                ? DashboardContainer(
                    title: TextConst.humidityAvg,
                    data: '${forecastData!.day.avghumidity}%',
                    image: ImageConst.humidityLogo,
                    showPercentage: true,
                    percentage: forecastData.day.avghumidity.setPercentage,
                    progressColor: Colors.blue,
                  )
                : const BlankDashboardContainer(),
          ],
        ),
        Const.dashboardUISpacing.ph,
      ],
    );
  }
}
