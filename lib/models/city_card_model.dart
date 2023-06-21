import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/pages/panels/tab_button.dart';

class CityCardModel {
  String cityName;
  String country;
  String image;
  String description;
  LatLng location;
  int number;
  List<TabButton> availableTabs;
  List<LatLng> availableTours;
  List<String> availableToursName;
  List<String> availableToursDescription;
  Map<String, String> availableData;

  CityCardModel({
    required this.cityName,
    required this.country,
    required this.image,
    required this.location,
    required this.number,
    required this.availableTabs,
    required this.description,
    required this.availableData,
    required this.availableTours,
    required this.availableToursName,
    required this.availableToursDescription,
  });
}
