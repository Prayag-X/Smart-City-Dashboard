import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';

StateProvider<bool> isHomePageProvider = StateProvider((ref) => true);
StateProvider<int> tabProvider = StateProvider((ref) => 0);
StateProvider<MapType> mapTypeProvider = StateProvider((ref) => MapType.hybrid);
StateProvider<CityCardModel?> cityDataProvider = StateProvider((ref) => null);