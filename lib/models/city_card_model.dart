import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/pages/panels/tab_button.dart';

class CityCardModel {
  String cityName;
  String country;
  String image;
  LatLng location;
  int number;
  List<TabButton> availableTabs;
  Map<String, String> availableData;

  CityCardModel(
      {required this.cityName,
      required this.country,
      required this.image,
        required this.location,
      required this.number,
        required this.availableTabs,
      required this.availableData});
}
