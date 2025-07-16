import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  WeatherCard({super.key, required this.weather});

  String formatTime(int timestamp, int timezoneOffset) {
    final utcDateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
      isUtc: true,
    );
    final localDateTime = utcDateTime.add(Duration(seconds: timezoneOffset));
    return DateFormat('hh:mm a').format(localDateTime);
  }

  @override
  Widget build(BuildContext context) {
    String lottieAsset = getLottieAsset(weather, context);
    return Stack(
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                lottieAsset,

                height: MediaQuery.of(context).size.height * 0.37,
                width: MediaQuery.of(context).size.width * 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "${weather.temperature.toStringAsFixed(0)}°C",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 75,
                      ),
                    ),
                  ),

                  Text(
                    "${weather.description.replaceFirst(" ", "\n").toUpperCase()}",
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Feels like:${weather.feelsLike.toStringAsFixed(0)}°C",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontSize: 18),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Humidity",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontSize: 18),
                      ),
                      Row(
                        children: [
                          Icon(Icons.water_drop, color: Colors.blue),
                          Text(
                            "${weather.humidity}%",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 50),
                  Column(
                    children: [
                      Text(
                        "Pressure",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontSize: 18),
                      ),
                      Row(
                        children: [
                          Icon(Icons.speed, color: Colors.black),
                          Text(
                            "${weather.windSpeed} hPa",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: LayoutBuilder(
                          builder: (context, constraints) => Dash(
                            direction: Axis.horizontal,
                            dashLength: 5,
                            length: constraints.maxWidth,
                            dashColor: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Sunrise",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontSize: 18),
                      ),
                      Row(
                        children: [
                          Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                          Text(
                            " ${formatTime(weather.sunrise, weather.timezoneOffset)}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 50),
                  Column(
                    children: [
                      Text(
                        "Sunset",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontSize: 18),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.nights_stay_outlined,
                            color: Color(0xBD52036E),
                          ),
                          Text(
                            "${formatTime(weather.sunset, weather.timezoneOffset)}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: LayoutBuilder(
                          builder: (context, constraints) => Dash(
                            direction: Axis.horizontal,
                            dashLength: 5,
                            length: constraints.maxWidth,
                            dashColor: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Cloudiness",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontSize: 18),
                      ),
                      Row(
                        children: [
                          Icon(Icons.cloud, color: Color(0xFF0B3688)),
                          Text(
                            "${weather.cloudiness}%",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 50),
                  Column(
                    children: [
                      Text(
                        "Wind",
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontSize: 18),
                      ),
                      Row(
                        children: [
                          Icon(Icons.air_outlined, color: Colors.grey),
                          Text(
                            "${weather.windDirection} - ${weather.windSpeed} m/s",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
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

  String getLottieAsset(Weather weather, BuildContext context) {
    DateTime cityTime = getCityTime(); // your function to get city time
    int hour = cityTime.hour;
    String desc = weather.description.toLowerCase();
    if (desc.contains("overcast clouds")) {
      return "assets/overcast_clouds.json";
    } else if (desc.contains("clouds")) {
      if (hour >= 11 && hour < 17) {
        return "assets/clouds_day.json";
      } else if (hour >= 17 || hour < 5) {
        return "assets/clouds_night.json";
      } else {
        return "assets/clouds_morning.json";
      }
    } else if (desc.contains("thunderstorm")) {
      return "assets/thumderstorm.json";
    } else if (desc.contains("rain")) {
      return "assets/rain.json";
    } else if (desc.contains("clear")) {
      if (hour >= 17 || hour < 5) {
        return "assets/clear_night.json";
      } else
        return "assets/clear_day.json";
    } else if (desc.contains("snow")) {
      return "assets/snowfall.json";
    } else {
      if (hour >= 17 || hour < 5) {
        return "assets/clouds_night.json";
      } else
        return "assets/clouds_day.json"; // Fallback asset
    }
  }

  DateTime getCityTime() {
    // Get current UTC time
    final utcNow = DateTime.now().toUtc();

    // Add timezone offset of city to get its local time
    final cityTime = utcNow.add(Duration(seconds: weather.timezoneOffset));

    return cityTime;
  }
}
