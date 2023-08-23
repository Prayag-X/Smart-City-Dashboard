import 'package:http/http.dart' as http;

import '../models/forecast_weather.dart';

class WeatherApi {
  final String apiKey = '307ce97f16mshe30c4bfb951b2bdp1f8b25jsn7cecd9ed2a99';
  String url = 'https://weatherapi-com.p.rapidapi.com/';

  Future<http.Response> apiResponse(String params) async =>
      await http.get(Uri.parse('$url$params'), headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com'
      });

  Future<ForecastWeather?> getForecastWeather(String cityName) async {
    String params = 'forecast.json?q=$cityName&days=3'.replaceAll(' ', '%20');
    final response = await apiResponse(params);

    if (response.statusCode == 200) {
      return forecastWeatherFromJson(response.body);
    } else {
      return null;
    }
  }
}
