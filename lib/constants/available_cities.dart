import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/pages/panels/tab_button.dart';

import '../models/tab_button.dart';
import '../pages/dashboard/new_york/environment/left_panel.dart';
import '../pages/dashboard/new_york/environment/right_panel.dart';
import 'texts.dart';
import 'images.dart';

class CityCardData {
  static List<CityCardModel> availableCities = [
    CityCardModel(
        cityName: translate('city_data.new_york.cityName'),
        cityNameEnglish: 'New York',
        country: translate('city_data.new_york.country'),
        description: translate('city_data.new_york.description'),
        image: ImageConst.newYork,
        number: 0,
        location: const LatLng(40.730610, -73.935242),
        availableTabs: [
          TabButtonModel(
            logo: ImageConst.weather,
            name: TextConst.weather,
            tab: 0,
          ),
          TabButtonModel(
            logo: ImageConst.environmentTab,
            name: TextConst.environment,
            tab: 1,
            leftTab: const NYCEnvironmentTabLeft(),
            rightTab: const NYCEnvironmentTabRight(),
          ),
          TabButtonModel(
            logo: ImageConst.about,
            name: TextConst.about,
            tab: 2,
          ),
        ],
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
    CityCardModel(
        cityName: translate('city_data.charlotte.cityName'),
        cityNameEnglish: 'Charlotte',
        country: translate('city_data.charlotte.country'),
        description: translate('city_data.charlotte.description'),
        image: ImageConst.charlotte,
        number: 1,
        location: const LatLng(35.1340053, -81.0202533),
        availableTabs: [
          TabButtonModel(
            logo: ImageConst.weather,
            name: TextConst.weather,
            tab: 0,
          ),
          TabButtonModel(
            logo: ImageConst.about,
            name: TextConst.about,
            tab: 1,
          ),
        ],
        availableTours: [
          const LatLng(40.74847707639803, -73.98563946566026),
        ],
        availableToursName: [],
        availableToursDescription: [
          ''
        ]),
    CityCardModel(
        cityName: translate('city_data.seattle.cityName'),
        cityNameEnglish: 'Seattle',
        country: translate('city_data.seattle.country'),
        description: translate('city_data.seattle.description'),
        image: ImageConst.seattle,
        number: 2,
        location: const LatLng(30.4882, -97.7618),
        availableTabs: [
          TabButtonModel(
            logo: ImageConst.weather,
            name: TextConst.weather,
            tab: 0,
          ),
          TabButtonModel(
            logo: ImageConst.about,
            name: TextConst.about,
            tab: 1,
          ),
        ],
        availableTours: [
          const LatLng(40.74847707639803, -73.98563946566026),
        ],
        availableToursName: [],
        availableToursDescription: [
          ''
        ]),
    CityCardModel(
        cityName: translate('city_data.austin.cityName'),
        cityNameEnglish: 'Austin',
        country: translate('city_data.austin.country'),
        description: translate('city_data.austin.description'),
        image: ImageConst.austin,
        number: 3,
        location: const LatLng(30.4882, -97.7618),
        availableTabs: [
          TabButtonModel(
            logo: ImageConst.weather,
            name: TextConst.weather,
            tab: 0,
          ),
          TabButtonModel(
            logo: ImageConst.about,
            name: TextConst.about,
            tab: 1,
          ),
        ],
        availableTours: [
          const LatLng(40.74847707639803, -73.98563946566026),
        ],
        availableToursName: [],
        availableToursDescription: [
          ''
        ]),
    CityCardModel(
        cityName: translate('city_data.boulder.cityName'),
        cityNameEnglish: 'Boulder',
        country: translate('city_data.boulder.country'),
        description: translate('city_data.boulder.description'),
        image: ImageConst.boulder,
        number: 4,
        location: const LatLng(30.4882, -97.7618),
        availableTabs: [
          TabButtonModel(
            logo: ImageConst.weather,
            name: TextConst.weather,
            tab: 0,
          ),
          TabButtonModel(
            logo: ImageConst.about,
            name: TextConst.about,
            tab: 1,
          ),
        ],
        availableTours: [
          const LatLng(40.74847707639803, -73.98563946566026),
        ],
        availableToursName: [],
        availableToursDescription: [
          ''
        ]),
  ];
}
