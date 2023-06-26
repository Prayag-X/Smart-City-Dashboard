import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/pages/dashboard/dashboard_container.dart';
import 'package:smart_city_dashboard/pages/dashboard/weather_tab/weather_chart_parser.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/services/weather_api.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

import '../../../constants/constants.dart';
import '../../../constants/texts.dart';
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
                        percentage: weatherData
                            .current.feelslikeC.setTemperaturePercentage,
                        progressColor: Colors.orange,
                      )
                    : const BlankDashboardContainer(),
              ],
            ),
            Const.dashboardUISpacing.ph,
            weatherData != null
                ? WeatherChartParser().hourlyDataParser(weatherData, 0)
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
            weatherData != null
                ? WeatherChartParser().hourlyDataParser(weatherData, weatherDayClicked)
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
        ),
      ),
    );
  }
}
