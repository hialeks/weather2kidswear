import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/weather.dart';

class WeatherService extends ChangeNotifier {
  Weather? currentWeather;

  Future<void> fetchWeather(double latitude, double longitude) async {
    final url =
        'https://api.open-meteo.com/v1/dwd-icon?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,is_day,rain,showers,snowfall&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,rain,snowfall,wind_speed_10m,wind_speed_80m,wind_speed_120m,soil_temperature_0cm&daily=temperature_2m_max,temperature_2m_min&timeformat=unixtime&timezone=auto&forecast_days=3';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("API Response: $data"); // Add this line
      currentWeather = Weather.fromJson(data['current']);
      notifyListeners();
    } else {
      print(
          "Failed to load weather data with status code: ${response.statusCode}");
      throw Exception('Failed to load weather data');
    }
  }
}
