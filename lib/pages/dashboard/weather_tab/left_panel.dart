import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/charts/line_chart_parser.dart';
import 'package:smart_city_dashboard/pages/dashboard/widgets/dashboard_container.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/services/weather_api.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../connections/ssh.dart';
import '../../../constants/constants.dart';
import '../../../kml_makers/balloon_makers.dart';
import '../../../providers/settings_providers.dart';

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
          .getForecastWeather(ref.read(cityDataProvider)!.cityNameEnglish);
      ref.read(isLoadingProvider.notifier).state = false;
    });
    var initialMapPosition = CameraPosition(
      target: ref.read(cityDataProvider)!.location,
      zoom: 11,
    );
    ForecastWeather? weatherData = ref.read(weatherDataProvider)!;
    await SSH(ref: ref).renderInSlave(
        ref.read(rightmostRigProvider),
        BalloonMakers.weatherBalloon(
            initialMapPosition,
            ref.read(cityDataProvider)!.cityNameEnglish,
            ref.read(cityDataProvider)!.image,
            weatherData.current.condition.text!,
            weatherData.current.condition.icon!.parseIconOnline,
            '${weatherData.current.tempC.toString()}°C',
            '${weatherData.current.windKph} Km/h',
            '${weatherData.current.windDegree}°${ref.read(weatherDataProvider)!.current.windDir}',
            '${weatherData.current.humidity}%',
            '${weatherData.current.cloud}%',
            '${weatherData.current.uv}',
            '${weatherData.current.pressureMb} mb'));
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

  AnimationLimiter today() {
    ForecastWeather? weatherData = ref.watch(weatherDataProvider);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                weatherData != null
                    ? DashboardContainer(
                        title: translate('dashboard.weather.now'),
                        data: weatherData.current.condition.text!,
                        image: weatherData.current.condition.icon!.parseIcon,
                      )
                    : const BlankDashboardContainer(),
                weatherData != null
                    ? DashboardContainer(
                        title: translate('dashboard.weather.time'),
                        data: weatherData.location.localtime.parseTime,
                        image: weatherData.current.isDay == 1
                            ? ImageConst.day
                            : ImageConst.night,
                      )
                    : const BlankDashboardContainer(),
              ],
            ),
            Const.dashboardUISpacing.ph,
            weatherData != null
                ? DashboardContainer(
                    widthMultiplier: 2,
                    title: translate('dashboard.weather.wind'),
                    data:
                        '${weatherData.current.windKph} Km/h ${weatherData.current.windDegree}°${weatherData.current.windDir}',
                    image: ImageConst.wind,
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
                        title: translate('dashboard.weather.temperature'),
                        data: '${weatherData.current.tempC}°C',
                        image: ImageConst.temperature,
                        showPercentage: true,
                        percentage:
                            weatherData.current.tempC.setTemperaturePercentage,
                        progressColor: Colors.red,
                      )
                    : const BlankDashboardContainer(),
                weatherData != null
                    ? DashboardContainer(
                        title: translate('dashboard.weather.feels'),
                        data: '${weatherData.current.feelslikeC}°C',
                        image: ImageConst.temperature,
                        showPercentage: true,
                        percentage: weatherData
                            .current.feelslikeC.setTemperaturePercentage,
                        progressColor: Colors.orange,
                      )
                    : const BlankDashboardContainer(),
              ],
            ),
            Const.dashboardUISpacing.ph,
            weatherData != null
                ? LineChartParser(chartData: {
                    translate('dashboard.weather.temperature'): Colors.red,
                    translate('dashboard.weather.humidity'): Colors.blue
                  }, title: translate('dashboard.weather.hourly'))
                    .weatherHourlyDataParser(weatherData, 0)
                : const BlankDashboardContainer(
                    heightMultiplier: 2,
                    widthMultiplier: 2,
                  ),
            Const.dashboardUISpacing.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                weatherData != null
                    ? DashboardContainer(
                        title: translate('dashboard.weather.humidity'),
                        data: '${weatherData.current.humidity}%',
                        image: ImageConst.humidity,
                        showPercentage: true,
                        percentage: weatherData.current.humidity.setPercentage,
                        progressColor: Colors.blue,
                      )
                    : const BlankDashboardContainer(),
                weatherData != null
                    ? DashboardContainer(
                        title: translate('dashboard.weather.cloud'),
                        data: '${weatherData.current.cloud}%',
                        image: ImageConst.cloud,
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
                        title: translate('dashboard.weather.uv'),
                        data: '${weatherData.current.uv}',
                        image: ImageConst.uv,
                        showPercentage: true,
                        percentage: weatherData.current.uv.setUVPercentage,
                        progressColor: Colors.yellow,
                      )
                    : const BlankDashboardContainer(),
                weatherData != null
                    ? DashboardContainer(
                        title: translate('dashboard.weather.pressure'),
                        data: '${weatherData.current.pressureMb} mb',
                        image: ImageConst.pressure,
                        showPercentage: true,
                        percentage: weatherData
                            .current.pressureMb.setPressurePercentage,
                        progressColor: Colors.pinkAccent,
                      )
                    : const BlankDashboardContainer(),
              ],
            ),
            Const.dashboardUISpacing.ph,
          ],
        ),
      ),
    );
  }

  AnimationLimiter otherDay() {
    ForecastWeather? weatherData = ref.watch(weatherDataProvider);
    int weatherDayClicked = ref.watch(weatherDayClickedProvider);
    Forecastday? forecastData =
        weatherData?.forecast.forecastday[weatherDayClicked];
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                weatherData != null
                    ? DashboardContainer(
                        title: translate('dashboard.weather.condition'),
                        data: forecastData!.day.condition.text!,
                        image: forecastData.day.condition.icon!.parseIcon,
                      )
                    : const BlankDashboardContainer(),
                weatherData != null
                    ? DashboardContainer(
                        title: translate('dashboard.weather.date'),
                        data:
                            '${forecastData!.date.day}/${forecastData.date.month}',
                        image: ImageConst.calender,
                      )
                    : const BlankDashboardContainer(),
              ],
            ),
            Const.dashboardUISpacing.ph,
            weatherData != null
                ? DashboardContainer(
                    widthMultiplier: 2,
                    title: translate('dashboard.weather.wind_max'),
                    data: '${forecastData!.day.maxwindKph} Km/h',
                    image: ImageConst.wind,
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
                        title: translate('dashboard.weather.temp_max_full'),
                        data: '${forecastData!.day.maxtempC}°C',
                        image: ImageConst.temperature,
                        showPercentage: true,
                        percentage:
                            forecastData.day.maxtempC.setTemperaturePercentage,
                        progressColor: Colors.red,
                      )
                    : const BlankDashboardContainer(),
                weatherData != null
                    ? DashboardContainer(
                        title: translate('dashboard.weather.temp_min_full'),
                        data: '${forecastData!.day.mintempC}°C',
                        image: ImageConst.temperature,
                        showPercentage: true,
                        percentage:
                            forecastData.day.mintempC.setTemperaturePercentage,
                        progressColor: Colors.blue,
                      )
                    : const BlankDashboardContainer(),
              ],
            ),
            Const.dashboardUISpacing.ph,
            weatherData != null
                ? LineChartParser(chartData: {
                    translate('dashboard.weather.temperature'): Colors.red,
                    translate('dashboard.weather.humidity'): Colors.blue
                  }, title: translate('dashboard.weather.hourly'))
                    .weatherHourlyDataParser(weatherData, weatherDayClicked)
                : const BlankDashboardContainer(
                    heightMultiplier: 2,
                    widthMultiplier: 2,
                  ),
            Const.dashboardUISpacing.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                weatherData != null
                    ? DashboardContainer(
                        title: translate('dashboard.weather.uv'),
                        data: forecastData!.day.uv.toString(),
                        image: ImageConst.uv,
                        showPercentage: true,
                        percentage: forecastData.day.uv.setUVPercentage,
                        progressColor: Colors.yellow,
                      )
                    : const BlankDashboardContainer(),
                weatherData != null
                    ? DashboardContainer(
                        title: translate('dashboard.weather.humidity_avg'),
                        data: '${forecastData!.day.avghumidity}%',
                        image: ImageConst.humidity,
                        showPercentage: true,
                        percentage: forecastData.day.avghumidity.setPercentage,
                        progressColor: Colors.blue,
                      )
                    : const BlankDashboardContainer(),
              ],
            ),
            Const.dashboardUISpacing.ph,
          ],
        ),
      ),
    );
  }
}
