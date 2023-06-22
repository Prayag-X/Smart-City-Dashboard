import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/constants/text_styles.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';
import 'package:smart_city_dashboard/pages/dashboard/dashboard_right_panel.dart';
import 'package:smart_city_dashboard/widgets/extensions.dart';
import 'package:smart_city_dashboard/widgets/logo_shower.dart';

import '../../../constants/constants.dart';
import '../../../constants/texts.dart';
import '../../../constants/theme.dart';
import '../../../providers/data_providers.dart';

class WeatherTabRight extends ConsumerWidget {
  const WeatherTabRight({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ForecastWeather? weatherData = ref.watch(weatherDataProvider);
    int weatherDayClicked = ref.watch(weatherDayClickedProvider);
    return DashboardRightPanel(
        headers: [
          TextConst.forecast,
          TextConst.tempMax,
          TextConst.tempMin,
          TextConst.humidity
        ],
        headersFlex: const [6, 7, 6, 5],
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
                            ? Themes.darkHighlightColor
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
                                      ? TextConst.today
                                      : '${forecast.date.day}/${forecast.date.month}',
                                  style: textStyleNormalWhite.copyWith(
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
                                        style: textStyleNormalWhite.copyWith(
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
                                        style: textStyleNormalWhite.copyWith(
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
                                          logo: ImageConst.humidityLogo,
                                          size: Const.dashboardTextSize + 5),
                                      5.pw,
                                      Text(
                                        '${forecast.day.avghumidity}%',
                                        style: textStyleNormalWhite.copyWith(
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
