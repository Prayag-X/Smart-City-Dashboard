import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/pages/panels/tab_button.dart';

import 'texts.dart';
import 'images.dart';

class CityCardData {
  static List<CityCardModel> availableCities = [
    CityCardModel(
        cityName: translate('city_data.new_york.cityName'),
        country: translate('city_data.new_york.country'),
        description: translate('city_data.new_york.description'),
        image: ImageConst.newYork,
        number: 0,
        location: const LatLng(40.730610, -73.935242),
        availableTabs: [
          TabButton(
            logo: ImageConst.weather,
            name: TextConst.weather,
            tab: 0,
          ),
          TabButton(
            logo: ImageConst.environmentTab,
            name: TextConst.environment,
            tab: 1,
          ),
          TabButton(
            logo: ImageConst.about,
            name: TextConst.about,
            tab: 2,
          ),
        ],
        availableData: {
          ImageConst.weather: TextConst.weather,
          ImageConst.environmentTab: TextConst.environment,
          ImageConst.about: TextConst.about,
        },
        availableTours: [
          const LatLng(40.74847707639803, -73.98563946566026),
          const LatLng(40.70671461961566, -73.99707640509378),
          const LatLng(40.70482771858912, -74.013791931433),
          const LatLng(40.78027830508383, -73.96330202877064),
          const LatLng(40.821568328698696, -73.94909704948456),
        ],
        availableToursName: [
          'Empire State Building'
        ],
        availableToursDescription: [
          ''
        ]),
  ];
}
