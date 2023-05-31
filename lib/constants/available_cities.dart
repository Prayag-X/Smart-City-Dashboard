import 'package:smart_city_dashboard/models/city_card_model.dart';

import 'texts.dart';
import 'images.dart';

class CityCardData {
  static List<CityCardModel> availableCities = [
    CityCardModel(
        cityName: 'New York',
        country: 'USA',
        image: ImageConst.newYork,
        number: 0,
        availableData: {
          ImageConst.settingLogo: TextConst.settings,
          ImageConst.lgLogo: TextConst.option,
        }),
    CityCardModel(
        cityName: 'New York',
        country: 'USA',
        image: ImageConst.newYork,
        number: 0,
        availableData: {
          ImageConst.settingLogo: TextConst.settings,
          ImageConst.lgLogo: TextConst.option,
        })
  ];
}
