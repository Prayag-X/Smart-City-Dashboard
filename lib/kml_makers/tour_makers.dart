import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/connections/ssh.dart';
import 'package:smart_city_dashboard/providers/data_providers.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

class TourMakers {
  static buildOrbit(BuildContext context, WidgetRef ref, mounted, enableTour, LatLng location) async {
    for (int i = 0; i <= 360; i += 10) {
      if(!enableTour || !mounted) {
        return;
      }
      SSH(ref: ref).flyToOrbitSaving(context, location.latitude, location.longitude, 13.zoomLG, 60, i.toDouble());
      await Future.delayed(const Duration(milliseconds: 1000));
      print("Roating $i");
    }
    // SSH(ref: ref).flyToWithoutSaving(context, location.latitude, location.longitude, 13.zoomLG, 60, i.toDouble());
  }
}