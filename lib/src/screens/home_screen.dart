import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../services/weather_service.dart';
import '../utils/dress_suggestions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    final weatherService = Provider.of<WeatherService>(context, listen: false);
    try {
      await weatherService.getCurrentLocationAndFetchWeather();
    } catch (error) {
      Logger().e("Error fetching weather data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Weather to Kidswear',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Center(
        child: weatherService.currentWeather == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (weatherService.currentLocation != null)
                    const SizedBox(height: 45),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(17, 193, 120, 75),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(23.0),
                      child: Text(
                        'Ort: ${weatherService.currentLocation!}',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  if (weatherService.currentLocation == null)
                    const Text(
                      'Lade Ort...',
                      style: TextStyle(fontSize: 24),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'Temperatur: ${weatherService.currentWeather!.temperature}°C',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Luftfeuchtigkeit: ${weatherService.currentWeather!.humidity}%',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 45),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(64, 75, 193, 160),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(23.0),
                      child: Text(
                        DressSuggestions.getSuggestions(
                          weatherService.currentWeather!,
                          true,
                        ),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
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
