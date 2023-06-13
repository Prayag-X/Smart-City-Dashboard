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
import 'package:smart_city_dashboard/providers/page_providers.dart';
import 'package:smart_city_dashboard/services/weather_api.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/helper.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';

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
    int weatherDayClicked = ref.watch(weatherDayClickedProvider);
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: Const.animationDuration,
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: Const.animationDistance,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: [
            SizedBox(
              height: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        TextConst.forecast,
                        style: textStyleNormal.copyWith(
                            fontSize: 17, color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Text(TextConst.tempMax,
                          style: textStyleNormal.copyWith(
                              fontSize: 17,
                              color: Colors.white.withOpacity(0.5))),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        TextConst.tempMin,
                        style: textStyleNormal.copyWith(
                            fontSize: 17, color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        TextConst.humidity,
                        style: textStyleNormal.copyWith(
                            fontSize: 17, color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            SizedBox(
              height: (screenSize(context).height - Const.appBarHeight) /
                  2 -
                  25 -
                  Const.dashboardUISpacing - 36,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: weatherData != null
                    ? AnimationLimiter(
                        child: Column(
                          children: AnimationConfiguration.toStaggeredList(
                            duration: Const.animationDuration,
                            childAnimationBuilder: (widget) => SlideAnimation(
                              horizontalOffset: Const.animationDistance,
                              child: FadeInAnimation(
                                child: widget,
                              ),
                            ),
                            children: [
                              Column(
                                children: weatherData.forecast.forecastday
                                    .map((forecast) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: GestureDetector(
                                            onTap: () => ref
                                                    .read(
                                                        weatherDayClickedProvider
                                                            .notifier)
                                                    .state =
                                                weatherData.forecast.forecastday
                                                    .indexOf(forecast),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: weatherDayClicked ==
                                                        weatherData.forecast
                                                            .forecastday
                                                            .indexOf(forecast)
                                                    ? Themes.darkHighlightColor
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(Const
                                                        .dashboardUIRoundness),
                                              ),
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 15.0,
                                                      horizontal: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          weatherData.forecast
                                                                      .forecastday
                                                                      .indexOf(
                                                                          forecast) ==
                                                                  0
                                                              ? TextConst.today
                                                              : '${forecast.date.day}/${forecast.date.month}',
                                                          style:
                                                              textStyleNormalWhite
                                                                  .copyWith(
                                                                      fontSize:
                                                                          25),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          flex: 6,
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .arrow_upward_rounded,
                                                                size: 25,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              5.pw,
                                                              Text(
                                                                '${forecast.day.maxtempC}°C',
                                                                style: textStyleNormalWhite
                                                                    .copyWith(
                                                                        fontSize:
                                                                            25),
                                                              ),
                                                            ],
                                                          )),
                                                      Expanded(
                                                          flex: 6,
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .arrow_downward_rounded,
                                                                size: 25,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              5.pw,
                                                              Text(
                                                                '${forecast.day.mintempC}°C',
                                                                style: textStyleNormalWhite
                                                                    .copyWith(
                                                                        fontSize:
                                                                            25),
                                                              ),
                                                            ],
                                                          )),
                                                      Expanded(
                                                          flex: 5,
                                                          child: Row(
                                                            children: [
                                                              const AssetLogoShower(
                                                                  logo: ImageConst
                                                                      .humidityLogo,
                                                                  size: 25),
                                                              5.pw,
                                                              Text(
                                                                '${forecast.day.avghumidity}%',
                                                                style: textStyleNormalWhite
                                                                    .copyWith(
                                                                        fontSize:
                                                                            25),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
