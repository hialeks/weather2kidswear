import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/weather.dart';

class WeatherService extends ChangeNotifier {
  Weather? currentWeather;
  Position? currentPosition;
  String? currentLocation;
  final String _apiKey =
      'bff12edb41924fcbbea009f9d0d3244d'; // Въведете вашия OpenCage API ключ тук
  var logger = Logger();

  Future<void> fetchWeather(double latitude, double longitude) async {
    final url =
        'https://api.open-meteo.com/v1/dwd-icon?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,is_day,rain,showers,snowfall&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,rain,snowfall,wind_speed_10m,wind_speed_80m,wind_speed_120m,soil_temperature_0cm&daily=temperature_2m_max,temperature_2m_min&timeformat=unixtime&timezone=auto&forecast_days=3';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      logger.i("API Response: $data");
      currentWeather = Weather.fromJson(data['current']);
      notifyListeners();
    } else {
      logger.e(
          "Failed to load weather data with status code: ${response.statusCode}");
      throw Exception('Failed to load weather data');
    }
  }

  Future<void> getCurrentLocationAndFetchWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Проверка дали услугата за местоположение е активирана
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      logger.w('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        logger.w('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      logger.w('Location permissions are permanently denied.');
      return;
    }

    try {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      logger.i("Current Position: $currentPosition");
      if (currentPosition != null) {
        final latitude = currentPosition?.latitude;
        final longitude = currentPosition?.longitude;
        if (latitude != null && longitude != null) {
          await fetchWeather(latitude, longitude);
          await fetchLocationName(latitude, longitude);
        } else {
          logger.w("Latitude or Longitude is null.");
        }
      }
    } catch (e) {
      logger.e("Error getting location: $e");
      throw Exception('Failed to get location');
    }
  }

  Future<void> fetchLocationName(double latitude, double longitude) async {
    final url =
        'https://api.opencagedata.com/geocode/v1/json?q=$latitude+$longitude&key=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      logger.i("Location API Response: $data");
      if (data['results'].isNotEmpty) {
        final components = data['results'][0]['components'];
        currentLocation = components['city'] ??
            components['town'] ??
            components['village'] ??
            components['hamlet'] ??
            "Unbekannter Ort";
        logger.i("Fetched Location: $currentLocation");
        notifyListeners();
      } else {
        logger.w("No results found for location");
      }
    } else {
      logger.e(
          "Failed to load location name with status code: ${response.statusCode}");
      throw Exception('Failed to load location name');
    }
  }
}
