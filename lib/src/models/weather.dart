class Weather {
  final double temperature;
  final double humidity;
  final bool isDay;
  final double rain;
  final double snow;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.isDay,
    required this.rain,
    required this.snow,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['temperature_2m'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).toDouble(),
      isDay: json['is_day'] == 1,
      rain: (json['rain'] as num).toDouble(),
      snow: (json['snowfall'] as num).toDouble(),
    );
  }
}
