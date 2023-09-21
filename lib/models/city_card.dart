import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/tab_button.dart';

class CityCardModel {
  String cityName;
  String cityNameEnglish;
  String country;
  String image;
  String description;
  LatLng location;
  List<TabButtonModel> availableTabs;
  List<LatLng> availableTours;

  CityCardModel({
    required this.cityName,
    required this.cityNameEnglish,
    required this.country,
    required this.image,
    required this.location,
    required this.availableTabs,
    required this.description,
    required this.availableTours,
  });
}
