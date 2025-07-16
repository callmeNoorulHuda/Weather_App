class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final int sunrise;
  final int sunset;
  final double feelsLike;
  final String windDirection;
  final int pressure;
  final int cloudiness;
  final int timezoneOffset;

  Weather({
    required this.timezoneOffset,
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.feelsLike,
    required this.windDirection,
    required this.pressure,
    required this.cloudiness,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    int deg = json['wind']['deg'];
    String direction = _degreeToDirection(deg);
    return Weather(
      timezoneOffset: json['timezone'],
      cityName: json['name'],
      temperature: json['main']['temp'] - 273.15, // Convert Kelvin to Celsius
      feelsLike:
          json['main']['feels_like'] - 273.15, // Convert Kelvin to Celsius
      pressure: json["main"]["humidity"],
      windDirection: direction,
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      cloudiness: json['clouds']['all'],
    );
  }
  static String _degreeToDirection(int degree) {
    const directions = [
      "N",
      "NNE",
      "NE",
      "ENE",
      "E",
      "ESE",
      "SE",
      "SSE",
      "S",
      "SSW",
      "SW",
      "WSW",
      "W",
      "WNW",
      "NW",
      "NNW",
    ];
    int index = ((degree + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }
}
