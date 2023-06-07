import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';
import 'package:smart_city_dashboard/models/forecast_weather.dart';

StateProvider<ForecastWeather?> weatherDataProvider = StateProvider((ref) => null);