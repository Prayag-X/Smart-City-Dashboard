import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/models/city_card_model.dart';

StateProvider<bool> isHomePageProvider = StateProvider((ref) => true);
StateProvider<int> homePageTabProvider = StateProvider((ref) => 0);
StateProvider<CityCardModel?> cityDataProvider = StateProvider((ref) => null);