import '../models/weather.dart';

class DressSuggestions {
  static String getSuggestions(Weather weather, bool isBoy) {
    String suggestions = "Heute solltest du tragen: \n";

    if (weather.temperature < 10) {
      suggestions += "Warme Jacke, ";
      if (weather.snow > 0) suggestions += "Stiefel, ";
      suggestions += "Mütze, Handschuhe, ";
    } else if (weather.temperature < 20) {
      suggestions += "Pullover oder leichte Jacke, ";
    } else {
      suggestions += "T-Shirt und Shorts, ";
    }

    if (weather.rain > 0) {
      suggestions += "Regenmantel, Regenschirm, ";
    }

    if (weather.humidity > 80) {
      suggestions += "atmungsaktive Kleidung, ";
    }

    return suggestions;
  }
}
