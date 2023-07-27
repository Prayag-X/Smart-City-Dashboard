import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/pages/dashboard/Seattle/finance_left_panel.dart';
import 'package:smart_city_dashboard/pages/dashboard/austin/transport_left_panel.dart';
import 'package:smart_city_dashboard/pages/dashboard/boulder/health_left_panel.dart';
import 'package:smart_city_dashboard/pages/dashboard/new_york/education_left_panel.dart';
import 'package:smart_city_dashboard/pages/panels/tab_button.dart';

import '../../models/tab_button.dart';
import 'Seattle/education_left_panel.dart';
import 'Seattle/transportation_left_panel.dart';
import 'austin/environment_left_panel.dart';
import 'austin/health_left_panel.dart';
import 'charlotte/misc_left_panel.dart';
import 'charlotte/society_left_panel.dart';
import 'downloadable_content.dart';
import 'new_york/environment_left_panel.dart';
import '../../constants/images.dart';
import 'new_york/health_left_panel.dart';

class AllCityData {
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
            name: translate('city_page.weather'),
            tab: 0,
          ),
          TabButtonModel(
            logo: ImageConst.environmentTab,
            name: translate('dashboard.environment.environment'),
            tab: 1,
            leftTab: const NYCEnvironmentTabLeft(),
            rightTabData: DownloadableContent.nycEnvironmentKml,
          ),
          TabButtonModel(
            logo: ImageConst.health,
            name: translate('city_data.new_york.health.health'),
            tab: 2,
            leftTab: const NYCHealthTabLeft(),
            rightTabData: DownloadableContent.nycHealthKml,
          ),
          TabButtonModel(
            logo: ImageConst.education,
            name: translate('city_data.new_york.education.education'),
            tab: 3,
            leftTab: const NYCEducationTabLeft(),
            rightTabData: DownloadableContent.nycEducationKml,
          ),
          TabButtonModel(
            logo: ImageConst.about,
            name: translate('homepage.about'),
            tab: 4,
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
        location: const LatLng(35.226841065880684, -80.84285320438734),
        availableTabs: [
          TabButtonModel(
            logo: ImageConst.weather,
            name: translate('city_page.weather'),
            tab: 0,
          ),
          TabButtonModel(
            logo: ImageConst.people,
            name: translate('city_data.charlotte.production.production'),
            tab: 1,
            leftTab: const CharlotteSocietyTabLeft(),
            rightTabData: DownloadableContent.charlotteProductionKml,
          ),
          TabButtonModel(
            logo: ImageConst.misc,
            name: translate('city_data.charlotte.misc.misc'),
            tab: 2,
            leftTab: const CharlotteMiscTabLeft(),
            rightTabData: DownloadableContent.charlotteMiscKml,
          ),
          TabButtonModel(
            logo: ImageConst.about,
            name: translate('homepage.about'),
            tab: 3,
          ),
        ],
        availableTours: [
          const LatLng(35.19802709514496, -80.81439580678503),
          const LatLng(35.20616267388421, -80.79800214535496),
          const LatLng(35.21506879539595, -80.82074727779712),
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
        location: const LatLng(47.61088523425851, -122.32392408029098),
        availableTabs: [
          TabButtonModel(
            logo: ImageConst.weather,
            name: translate('city_page.weather'),
            tab: 0,
          ),
          TabButtonModel(
            logo: ImageConst.finance,
            name: translate('city_data.seattle.finance.finance'),
            tab: 1,
            leftTab: const SeattleFinanceTabLeft(),
            rightTabData: DownloadableContent.blankKml,
          ),
          TabButtonModel(
            logo: ImageConst.transportation,
            name: translate('city_data.seattle.transportation.transportation'),
            tab: 2,
            leftTab: const SeattleTransportationTabLeft(),
            rightTabData: DownloadableContent.seattleTransportKml,
          ),
          TabButtonModel(
            logo: ImageConst.education,
            name: translate('city_data.seattle.education.education'),
            tab: 3,
            leftTab: const SeattleEducationTabLeft(),
            rightTabData: DownloadableContent.blankKml,
          ),
          TabButtonModel(
            logo: ImageConst.about,
            name: translate('homepage.about'),
            tab: 4,
          ),
        ],
        availableTours: [
          const LatLng(47.60796303093698, -122.33769990580109),
          const LatLng(47.60321771936339, -122.3145685354345),
          const LatLng(47.59795107695832, -122.31577016509245),
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
        location: const LatLng(30.29304532971849, -97.73443720721826),
        availableTabs: [
          TabButtonModel(
            logo: ImageConst.weather,
            name: translate('city_page.weather'),
            tab: 0,
          ),
          TabButtonModel(
            logo: ImageConst.environmentTab,
            name: translate('dashboard.environment.environment'),
            tab: 1,
            leftTab: const AustinEnvironmentTabLeft(),
            rightTabData: DownloadableContent.austinEnvironmentKml,
          ),
          TabButtonModel(
            logo: ImageConst.health,
            name: translate('city_data.austin.health.health'),
            tab: 2,
            leftTab: const AustinHealthTabLeft(),
            rightTabData: DownloadableContent.austinHealthKml,
          ),
          TabButtonModel(
            logo: ImageConst.transportation,
            name: translate('city_data.austin.transport.transport'),
            tab: 3,
            leftTab: const AustinTransportTabLeft(),
            rightTabData: DownloadableContent.austinTransportKml,
          ),
          TabButtonModel(
            logo: ImageConst.about,
            name: translate('homepage.about'),
            tab: 4,
          ),
        ],
        availableTours: [
          const LatLng(30.281409198164788, -97.73864291082809),
          const LatLng(30.292971218094596, -97.69366763014077),
          const LatLng(30.328686283420616, -97.74121783146857),
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
        location: const LatLng(40.015116174616196, -105.26924937530075),
        availableTabs: [
          TabButtonModel(
            logo: ImageConst.weather,
            name: translate('city_page.weather'),
            tab: 0,
          ),
          TabButtonModel(
            logo: ImageConst.health,
            name: translate('city_data.boulder.health.health'),
            leftTab: const BoulderHealthTabLeft(),
            rightTabData: DownloadableContent.blankKml,
            tab: 1,
          ),
          TabButtonModel(
            logo: ImageConst.about,
            name: translate('homepage.about'),
            tab: 2,
          ),
        ],
        availableTours: [
          const LatLng(40.01409726578651, -105.25852053941347),
          const LatLng(40.0311469853605, -105.2873682987872),
          const LatLng(39.96302696330601, -105.20033598076574),
        ],
        availableToursName: [],
        availableToursDescription: [
          ''
        ]),
  ];
}
