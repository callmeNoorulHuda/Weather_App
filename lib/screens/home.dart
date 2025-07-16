import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

import '../widgets/widget_card.dart';
import 'location.dart';

class Home extends StatefulWidget {
  final String? cityName;
  final String? countryName;
  const Home({super.key, required this.cityName, this.countryName});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherServices _weatherServices = WeatherServices();

  bool _isLoading = false;

  Weather? _weather;

  void _getWeather() async {
    if (widget.cityName == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No city entered")));
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final weather = await _weatherServices.fetchWeather(widget.cityName!);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching data")));
    }
  }

  @override
  void initState() {
    super.initState();

    _getWeather();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

    if (_weather == null) {
      return Scaffold(
        body: Center(child: Text("City not found or error fetching data.")),
      );
    }
    bool set = false;
    DateTime utcNow = DateTime.now().toUtc();
    DateTime cityTime = utcNow.add(Duration(seconds: _weather!.timezoneOffset));

    String day = DateFormat('EEEE').format(cityTime);
    String date = DateFormat('d').format(cityTime);
    String time = DateFormat('hh:mm a').format(cityTime);
    if (widget.cityName == null) {
      return Scaffold(
        body: Center(child: Text("City not found. Please enter a city.")),
      );
    } else {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: _weather != null
                ? getGradientBasedOnTime(_weather!)
                : LinearGradient(
                    colors: [Colors.blue, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${widget.cityName?.replaceFirst(" ", "\n")}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    set = true;
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Location(set: set),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.north_east_outlined,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            if (widget.countryName != null)
                              Text(
                                "${widget.countryName}",
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "$day",
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "$date",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "$time",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),

                  if (_isLoading)
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  if (_weather != null) WeatherCard(weather: _weather!),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  LinearGradient getGradientBasedOnTime(Weather weather) {
    DateTime cityTime = getCityTime();

    int hour = cityTime.hour;

    if (hour >= 5 && hour < 11) {
      // Morning
      if (weather.description.toLowerCase().contains("overcast clouds")) {
        return LinearGradient(
          colors: [Colors.grey, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("rain")) {
        return LinearGradient(
          colors: [Colors.blueGrey, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("thunderstorm")) {
        return LinearGradient(
          colors: [Color(0x185E5B5B), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("snow")) {
        return LinearGradient(
          colors: [Color(0x7EDDD8D8), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("fog")) {
        return LinearGradient(
          colors: [Color(0xBD918F8F), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else {
        return LinearGradient(
          colors: [Colors.lightBlueAccent, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      }
    } else if (hour >= 11 && hour < 17) {
      // Morning
      if (weather.description.toLowerCase().contains("overcast clouds")) {
        return LinearGradient(
          colors: [Colors.grey, Color(0xCDE8EDEF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("rain")) {
        return LinearGradient(
          colors: [Colors.blueGrey, Color(0xCDE8EDEF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("thunderstorm")) {
        return LinearGradient(
          colors: [Color(0x185E5B5B), Color(0xCDE8EDEF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("snow")) {
        return LinearGradient(
          colors: [Color(0x7EDDD8D8), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("fog")) {
        return LinearGradient(
          colors: [Color(0xBD918F8F), Color(0xE0F4F5F6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else {
        return LinearGradient(
          colors: [Colors.orangeAccent, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      }
    }
    // Day
    else {
      // Morning
      if (weather.description.toLowerCase().contains("overcast clouds")) {
        return LinearGradient(
          colors: [Color(0xBD012040), Color(0x98DDE6E6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("rain")) {
        return LinearGradient(
          colors: [Color(0xFF021437), Color(0x98DDE6E6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("thunderstorm")) {
        return LinearGradient(
          colors: [Color(0x185E5B5B), Color(0x98DDE6E6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("snow")) {
        return LinearGradient(
          colors: [Color(0x7EDDD8D8), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else if (weather.description.toLowerCase().contains("fog")) {
        return LinearGradient(
          colors: [Color(0xBD918F8F), Color(0xC7DDE6E6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else {
        return LinearGradient(
          colors: [Colors.black, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      }
    }
  }

  DateTime getCityTime() {
    // Get current UTC time
    final utcNow = DateTime.now().toUtc();

    // Add timezone offset of city to get its local time
    final cityTime = utcNow.add(Duration(seconds: _weather!.timezoneOffset));

    return cityTime;
  }
}
