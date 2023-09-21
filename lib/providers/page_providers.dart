import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:features_tour/features_tour.dart';

import '../kml_makers/balloon_makers.dart';
import '../models/tab_button.dart';

StateProvider<bool> isHomePageProvider = StateProvider((ref) => true);
StateProvider<int> tabProvider = StateProvider((ref) => 0);
StateProvider<int> subTabProvider = StateProvider((ref) => -1);
StateProvider<TabButtonModel?> tabPageProvider = StateProvider((ref) => null);
StateProvider<String> lastBalloonProvider =
    StateProvider((ref) => BalloonMakers.blankBalloon());

StateProvider<List<GlobalKey>> helpPageKeysProvider = StateProvider((ref) => [
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
    ]);

StateProvider<List<GlobalKey>> visualizerPageKeysProvider =
    StateProvider((ref) => [
          GlobalKey(),
          GlobalKey(),
        ]);

StateProvider<FeaturesTourController> featureTourControllerHomepageProvider =
    StateProvider((ref) => FeaturesTourController('Homepage'));
StateProvider<FeaturesTourController> featureTourControllerDashboardProvider =
    StateProvider((ref) => FeaturesTourController('Dashboard'));
StateProvider<FeaturesTourController> featureTourControllerVisualizerProvider =
    StateProvider((ref) => FeaturesTourController('Visualizer'));
