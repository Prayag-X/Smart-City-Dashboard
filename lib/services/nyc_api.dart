import 'package:http/http.dart' as http;

import '../models/forecast_weather.dart';
import '../models/realtime_weather.dart';

class NYCApi {
  final String apiKey = '2mru82f2glg78jqm00mknvcgi6gb1evx7jdgukoq8afbzti9pn';
  String url = 'https://data.cityofnewyork.us/';

  Future<http.Response> apiResponse(String params) async =>
      await http.get(Uri.parse('$url$params'), headers: {
        // "Accept": "application/json",
        // "X-App-Token" : apiKey
      });

  Future<RealtimeWeather?> getData(String params, int limit) async {
    final response = await apiResponse('$params?%24limit=$limit');

    if (response.statusCode == 200) {
      print('???');
      print(response.body);
      // return realtimeWeatherFromJson(response.body);
    } else {
      print(response.statusCode);
      return null;
    }
    return null;
  }
}
