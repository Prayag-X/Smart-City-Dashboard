import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_city_dashboard/kml_makers/balloon_makers.dart';
import 'package:smart_city_dashboard/models/tab_button.dart';

StateProvider<bool> isHomePageProvider = StateProvider((ref) => true);
StateProvider<int> tabProvider = StateProvider((ref) => 0);
StateProvider<TabButtonModel?> tabPageProvider = StateProvider((ref) => null);
StateProvider<String> lastBalloonProvider = StateProvider((ref) => BalloonMakers.blankBalloon());
