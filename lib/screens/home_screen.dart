import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/weather_service.dart';
import '../utils/dress_suggestions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    final weatherService = Provider.of<WeatherService>(context, listen: false);
    try {
      await weatherService.fetchWeather(53.5502, 9.992); // Hamburg
    } catch (error) {
      print("Error fetching weather data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather2Kidswear'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Center(
        child: weatherService.currentWeather == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Temperature: ${weatherService.currentWeather!.temperature}°C',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Humidity: ${weatherService.currentWeather!.humidity}%',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    DressSuggestions.getSuggestions(
                      weatherService.currentWeather!,
                      true, // Assume it's for boys for now, we can add user preference later
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchWeatherData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
