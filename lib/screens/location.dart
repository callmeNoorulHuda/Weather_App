import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:searchfield/searchfield.dart';
import 'package:weather_app/services/getlocation.dart';

import '../models/City.dart';
import 'home.dart';

class Location extends StatefulWidget {
  final bool set;
  const Location({super.key, this.set = false});

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String? city;
  String? country;

  bool selected = false;
  final TextEditingController _controller = TextEditingController();
  final GetLocation _locationService = GetLocation();

  bool _isLoading = false;

  Future<void> _getLocation() async {
    // This function should implement the logic to get the user's current location.
    setState(() {
      _isLoading = true;
    });
    try {
      Position position = await _locationService.getCurrentPosition();
      String cityName = await _locationService.getCityFromPosition(position);
      String countryName = await _locationService.getCountryFromPosition(
        position,
      );
      setState(() {
        city = "$cityName";
        country = "$countryName";
        _isLoading = false;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Home(cityName: city!, countryName: country),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching location: $e")));
    }
  }

  List<SearchFieldListItem<City>> cities = [];
  @override
  void initState() {
    cities =
        [
          City('New York'),
          City('Los Angeles'),
          City('Chicago'),
          City('Houston'),
          City('Phoenix'),
          City('London'),
          City('Paris'),
          City('Berlin'),
          City('Madrid'),
          City('Rome'),
          City('Tokyo'),
          City('Osaka'),
          City('Seoul'),
          City('Beijing'),
          City('Shanghai'),
          City('Bangkok'),
          City('Singapore'),
          City('Delhi'),
          City('Mumbai'),
          City('Karachi'),
          City('Lahore'),
          City('Dubai'),
          City('Abu Dhabi'),
          City('Istanbul'),
          City('Moscow'),
          City('Sydney'),
          City('Melbourne'),
          City('Toronto'),
          City('Vancouver'),
          City('Mexico City'),
          City('Sao Paulo'),
          City('Buenos Aires'),
          City('Cairo'),
          City('Cape Town'),
          City('Johannesburg'),
          City('Nairobi'),
          City('Lagos'),
          City('Riyadh'),
          City('Doha'),
          City('Kuwait City'),
          City('Tehran'),
          City('Baghdad'),
          City('Manila'),
          City('Jakarta'),
          City('Hanoi'),
          City('Kuala Lumpur'),
        ].map((City ct) {
          return SearchFieldListItem<City>(ct.name, value: ct.name, item: ct);
        }).toList();
    super.initState();
    if (!widget.set) _getLocation();

    // You can initialize any variables or services here if needed.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Lottie.asset("assets/background.json", fit: BoxFit.cover),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
              child: Column(
                children: [
                  Text(
                    "Enter City",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 20)),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: SearchField<City>(
                      controller: _controller,
                      suggestions: cities,
                      suggestionState: Suggestion.expand,

                      validator: (x) {
                        if (x == null || x.isEmpty) {
                          return 'Please enter a city';
                        }
                        return null;
                      },
                      searchInputDecoration: SearchInputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter city name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onSuggestionTap: (SearchFieldListItem<City> item) {
                        _controller.text = item.value ?? '';
                        city = item.value ?? '';
                        setState(() {
                          selected = true;
                        });
                      },
                      onSubmit: (String value) {
                        _controller.text = value;
                        city = value;
                        setState(() {
                          selected = true;
                        });

                        // Call your weather API here
                      },
                    ),
                  ),

                  SizedBox(height: 20),
                  if (_isLoading) CircularProgressIndicator(),
                  if (selected)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                Home(cityName: city, countryName: country),
                          ),
                        );
                      },
                      child: Text("Get Weather"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
