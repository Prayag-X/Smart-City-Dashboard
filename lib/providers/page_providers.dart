import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<bool> isHomePageProvider = StateProvider((ref) => true);
StateProvider<int> homePageTabProvider = StateProvider((ref) => 0);