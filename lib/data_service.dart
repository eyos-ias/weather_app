import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/response_example.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DataService {
  //https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
  Future<WeatherResponse> getWeather(String city) async {
    final queryParameter = {
      'q': city,
      'appid': 'c60704567ca7e06c9044295363aae45f',
      'units': 'metric'
    };
    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameter);

    final response = await http.get(uri);
    //print(response.body);
    final json = jsonDecode(response.body);
    final int statuscodes = response.statusCode;
    return WeatherResponse.fromJson(json);
  }

  Future statuscodes(String city) async {
    final queryParameter = {
      'q': city,
      'appid': dotenv.env['API_KEY'],
      'units': 'metric'
    };
    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameter);

    final response = await http.get(uri);
    //print(response.body);

    final int statuscodes = response.statusCode;
    return statuscodes;
  }
}
