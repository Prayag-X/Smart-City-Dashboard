import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/pages/homepage/tab_button.dart';

import 'texts.dart';
import 'images.dart';

class CityCardData {
  static List<CityCardModel> availableCities = [
    CityCardModel(
        cityName: 'New York',
        country: 'USA',
        image: ImageConst.newYork,
        number: 0,
        availableTabs:[
          TabButton(logo: ImageConst.weatherLogo, name: TextConst.weather, tab: 0,),
          TabButton(logo: ImageConst.aboutLogo, name: TextConst.about, tab: 1,),
        ],
        availableData: {
          ImageConst.weatherLogo: TextConst.weather,
          ImageConst.aboutLogo: TextConst.about,
        }),
    // CityCardModel(
    //     cityName: 'New York',
    //     country: 'USA',
    //     image: ImageConst.newYork,
    //     number: 0,
    //     availableData: {
    //       ImageConst.weatherLogo: TextConst.weather,
    //       ImageConst.aboutLogo: TextConst.about,
    //     })
  ];
}
