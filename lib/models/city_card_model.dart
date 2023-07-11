import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/models/tab_button.dart';

class CityCardModel {
  String cityName;
  String cityNameEnglish;
  String country;
  String image;
  String description;
  LatLng location;
  int number;
  List<TabButtonModel> availableTabs;
  List<LatLng> availableTours;
  List<String> availableToursName;
  List<String> availableToursDescription;

  CityCardModel({
    required this.cityName,
    required this.cityNameEnglish,
    required this.country,
    required this.image,
    required this.location,
    required this.number,
    required this.availableTabs,
    required this.description,
    required this.availableTours,
    required this.availableToursName,
    required this.availableToursDescription,
  });
}
