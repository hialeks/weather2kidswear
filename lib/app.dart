import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather2kidswear/screens/home_screen.dart';
import 'package:weather2kidswear/screens/settings_screen.dart';
import 'package:weather2kidswear/services/weather_service.dart';

class WeatherWearApp extends StatelessWidget {
  const WeatherWearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherService(),
      child: MaterialApp(
        title: 'Weather2Kidswear',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
        routes: {
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
