import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../widgets/dashboard_right_panel.dart';
import '../../../constants/images.dart';
import '../../../constants/text_styles.dart';
import '../../../models/forecast_weather.dart';
import '../../../utils/extensions.dart';
import '../../../utils/logo_shower.dart';
import '../../../constants/constants.dart';
import '../../../constants/theme.dart';
import '../../../providers/data_providers.dart';
import '../../../providers/settings_providers.dart';

class WeatherTabRight extends ConsumerWidget {
  const WeatherTabRight({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes themes = ref.watch(themesProvider);
    ForecastWeather? weatherData = ref.watch(weatherDataProvider);
    int weatherDayClicked = ref.watch(weatherDayClickedProvider);
    return DashboardRightPanel(
        headers: [
          translate('dashboard.weather.forecast'),
          translate('dashboard.weather.temp_max'),
          translate('dashboard.weather.temp_min'),
          translate('dashboard.weather.humidity')
        ],
        headersFlex: const [
          6,
          7,
          6,
          5
        ],
        panelList: weatherData?.forecast.forecastday
            .map((forecast) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: GestureDetector(
                    onTap: () =>
                        ref.read(weatherDayClickedProvider.notifier).state =
                            weatherData.forecast.forecastday.indexOf(forecast),
                    child: Container(
                      decoration: BoxDecoration(
                        color: weatherDayClicked ==
                                weatherData.forecast.forecastday
                                    .indexOf(forecast)
                            ? themes.highlightColor
                            : null,
                        borderRadius:
                            BorderRadius.circular(Const.dashboardUIRoundness),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Text(
                                  weatherData.forecast.forecastday
                                              .indexOf(forecast) ==
                                          0
                                      ? translate('dashboard.weather.today')
                                      : '${forecast.date.day}/${forecast.date.month}',
                                  style: textStyleNormal.copyWith(
                                      color: themes.oppositeColor,
                                      fontSize: Const.dashboardTextSize + 5),
                                ),
                              ),
                              Expanded(
                                  flex: 6,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_upward_rounded,
                                        size: Const.dashboardTextSize + 5,
                                        color: Colors.red,
                                      ),
                                      5.pw,
                                      Text(
                                        '${forecast.day.maxtempC}°C',
                                        style: textStyleNormal.copyWith(
                                            color: themes.oppositeColor,
                                            fontSize:
                                                Const.dashboardTextSize + 5),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  flex: 6,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_downward_rounded,
                                        size: Const.dashboardTextSize + 5,
                                        color: Colors.blue,
                                      ),
                                      5.pw,
                                      Text(
                                        '${forecast.day.mintempC}°C',
                                        style: textStyleNormal.copyWith(
                                            color: themes.oppositeColor,
                                            fontSize:
                                                Const.dashboardTextSize + 5),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: Row(
                                    children: [
                                      AssetLogoShower(
                                          logo: ImageConst.humidity,
                                          size: Const.dashboardTextSize + 5),
                                      5.pw,
                                      Text(
                                        '${forecast.day.avghumidity}%',
                                        style: textStyleNormal.copyWith(
                                            color: themes.oppositeColor,
                                            fontSize:
                                                Const.dashboardTextSize + 5),
                                      ),
                                    ],
                                  )),
                            ],
                          )),
                    ),
                  ),
                ))
            .toList());
  }
}
