import 'package:google_maps_flutter/google_maps_flutter.dart';

class Const {
  static double appBarHeight = 80;
  static double tabBarWidthDivider = 5;
  static List<double> splashAspectRatio = [0.6, 0.3];
  static double lgZoomScale = 130000000.0;
  static double appZoomScale = 11;
  static double tourZoomScale = 16;
  static double orbitZoomScale = 13;
  static double defaultZoomScale = 2;
  static double dashboardUIRoundness = 20;
  static double dashboardUISpacing = 10;
  static double dashboardUIHeightFactor = 0.65;
  static Duration animationDuration = const Duration(milliseconds: 375);
  static double animationDistance = 50;
  static double orbitRange = 40000;
  static double tabBarTextSize = 17;
  static double appBarTextSize = 18;
  static double homePageTextSize = 17;
  static double dashboardTextSize = 16;
  static double dashboardChartTextSize = 17;
  static String kmlOrbitFileName = 'Orbit';
  static String kmlCustomFileName = 'custom_kml';
  static CameraPosition initialMapPosition = const CameraPosition(
    target: LatLng(51.4769, 0.0),
    zoom: 2,
  );
}