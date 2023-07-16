import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city_dashboard/constants/images.dart';
import 'package:smart_city_dashboard/utils/extensions.dart';

class BalloonMakers {
  static weatherBalloon(
      CameraPosition camera,
      String cityName,
      String cityImage,
      String condition,
      String conditionIcon,
      String temperature,
      String wind,
      String windDirection,
      String humidity,
      String cloud,
      String uv,
      String pressure,
      ) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>Weather Data</name>
 <Style id="weather_style">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text>
        <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/$cityImage" alt="picture" width="300" height="200" />
        <h1>Weather of $cityName</h1>
        <img src="$conditionIcon" alt="picture" width="70" height="70" />
        <h2>$condition</h2>
        <h3>Temperature: $temperature</h3>
        <h3>Wind: $wind</h3>
        <h3>Wind Direction: $windDirection</h3>
        <h3>Humidity: $humidity</h3>
        <h3>Cloud: $cloud</h3>
        <h3>UV: $uv</h3>
        <h3>Pressure: $pressure</h3>
     </text>
     <bgColor>ff15151a</bgColor>
   </BalloonStyle>
 </Style>
 <Placemark id="ww">
   <description>
   </description>
   <LookAt>
     <longitude>${camera.target.longitude}</longitude>
     <latitude>${camera.target.latitude}</latitude>
     <heading>${camera.bearing}</heading>
     <tilt>${camera.tilt}</tilt>
     <range>${camera.zoom.zoomLG}</range>
   </LookAt>
   <styleUrl>#weather_style</styleUrl>
   <gx:balloonVisibility>1</gx:balloonVisibility>
   <Point>
     <coordinates>${camera.target.longitude},${camera.target.latitude},0</coordinates>
   </Point>
 </Placemark>
</Document>
</kml>''';

  static aboutBalloon(
      CameraPosition camera,
      String cityName,
      String countryName,
      String cityImage,
      String description
      ) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>About Data</name>
 <Style id="about_style">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text>
        <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/$cityImage" alt="picture" width="300" height="200" />
        <h1>$cityName</h1>
        <h1>$countryName</h1>
        <h3>Latitude: ${camera.target.latitude}</h3>
        <h3>Longitude: ${camera.target.longitude}</h3>
     </text>
     <bgColor>ff15151a</bgColor>
   </BalloonStyle>
 </Style>
 <Placemark id="ab">
   <description>
   </description>
   <LookAt>
     <longitude>${camera.target.longitude}</longitude>
     <latitude>${camera.target.latitude}</latitude>
     <heading>${camera.bearing}</heading>
     <tilt>${camera.tilt}</tilt>
     <range>${camera.zoom.zoomLG}</range>
   </LookAt>
   <styleUrl>#about_style</styleUrl>
   <gx:balloonVisibility>1</gx:balloonVisibility>
   <Point>
     <coordinates>${camera.target.longitude},${camera.target.latitude},0</coordinates>
   </Point>
 </Placemark>
</Document>
</kml>''';

  static kmlBalloon(
      CameraPosition camera,
      String cityImage,
      String kmlName,
      String size,
      ) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>About Data</name>
 <Style id="about_style">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text>
        <img src="https://raw.githubusercontent.com/Prayag-X/Smart-City-Dashboard/main/$cityImage" alt="picture" width="300" height="200" />
        <h1>$kmlName</h1>
        <h1>$size</h1>
     </text>
     <bgColor>ff15151a</bgColor>
   </BalloonStyle>
 </Style>
 <Placemark id="ab">
   <description>
   </description>
   <LookAt>
     <longitude>${camera.target.longitude}</longitude>
     <latitude>${camera.target.latitude}</latitude>
     <heading>${camera.bearing}</heading>
     <tilt>${camera.tilt}</tilt>
     <range>${camera.zoom.zoomLG}</range>
   </LookAt>
   <styleUrl>#about_style</styleUrl>
   <gx:balloonVisibility>1</gx:balloonVisibility>
   <Point>
     <coordinates>${camera.target.longitude},${camera.target.latitude},0</coordinates>
   </Point>
 </Placemark>
</Document>
</kml>''';


  static blankBalloon() => '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>None</name>
 <Style id="blank">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text></text>
     <bgColor>ff15151a</bgColor>
   </BalloonStyle>
 </Style>
 <Placemark id="bb">
   <description></description>
   <styleUrl>#blank</styleUrl>
   <gx:balloonVisibility>0</gx:balloonVisibility>
   <Point>
     <coordinates>0,0,0</coordinates>
   </Point>
 </Placemark>
</Document>
</kml>''';
}