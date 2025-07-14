import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  const WeatherCard({super.key, required this.weather});

  String formatTime(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xB5FFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                weather.description.contains("rain")
                    ? "assets/rain.json"
                    : weather.description.contains("clear")
                    ? "assets/sunny.json"
                    : weather.description.contains("cloud")
                    ? "assets/cloudy.json"
                    : "assets/snowfall.json",
                width: 150,
                height: 150,
              ),
              Text(
                weather.cityName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              Text(
                "${weather.temperature.toStringAsFixed(1)}°C",
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "${weather.description}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "${weather.humidity}%",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "${weather.windSpeed}%",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.wb_sunny_outlined, color: Colors.yellow),
                      Text(
                        "${formatTime(weather.sunrise)}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.nights_stay_outlined,
                        color: Color(0xFF0B3688),
                      ),
                      Text(
                        "${formatTime(weather.sunset)}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
