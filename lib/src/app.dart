import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather2kidswear/src/screens/home_screen.dart';
import 'package:weather2kidswear/src/screens/settings_screen.dart';
import 'package:weather2kidswear/src/services/weather_service.dart';

class W2K extends StatelessWidget {
  const W2K({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather2Kidswear',
        theme: ThemeData(
          primarySwatch: Colors.red,
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
