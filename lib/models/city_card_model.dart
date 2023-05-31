import 'package:smart_city_dashboard/pages/homepage/tab_button.dart';

class CityCardModel {
  String cityName;
  String country;
  String image;
  int number;
  List<TabButton> availableTabs;
  Map<String, String> availableData;

  CityCardModel(
      {required this.cityName,
      required this.country,
      required this.image,
      required this.number,
        required this.availableTabs,
      required this.availableData});
}
