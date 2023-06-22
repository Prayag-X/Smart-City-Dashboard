import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';

StateProvider<MapType> mapTypeProvider = StateProvider((ref) => MapType.hybrid);
StateProvider<CityCardModel?> cityDataProvider = StateProvider((ref) => null);
StateProvider<ForecastWeather?> weatherDataProvider = StateProvider((ref) => null);
StateProvider<int> weatherDayClickedProvider = StateProvider((ref) => 0);
StateProvider<CameraPosition?> lastGMapPositionProvider = StateProvider((ref) => null);