import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/search_screen.dart';
import 'package:weather_app/weather_service.dart';

import 'favourites-screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<HomeScreen> {
  double _temperature = 0.00;
  String _description = '';
  String _cityName = 'Udupi';
  String _dateTime = "";
  bool _isLoading = false;
  bool _isFavorite = false;
  Map<String, dynamic>? _weatherData;
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _checkIfFavorite();
  }

  void _updateWeatherData(Map<String, dynamic> data) {
    setState(() {
      _cityName = data['cityName'];
      _temperature = data['temperature'];
      _description = data['description'];
      _dateTime = ""; // Add a method to update the date if needed
      _isLoading = false;
    });
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await _weatherService.fetchWeather(_cityName);
      print("Weather Data :::: $data");
      setState(() {
        _weatherData = data;
        _temperature = _weatherData?['main']['temp'];
        _description = _weatherData?['weather'][0]['main'];
        int dt = _weatherData?['dt'];
        _dateTime = formatDateTime(dt);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _navigateToFavotiteScreen(BuildContext context) async {
    // Navigate to the search screen and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavouriteScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      _updateWeatherData(result);
    }
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigate to the search screen and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );

    if (result != null && result is String) {
      setState(() {
        _cityName = result;
      });
      _fetchWeather();
      _checkIfFavorite();
    }
  }

  Future<void> _checkIfFavorite() async {
    _isFavorite = await _isCityInFavourites();
    setState(() {});
  }

  Future<bool> _isCityInFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favourites = prefs.getStringList('favourites') ?? [];

    // Check if the city is already in the favourites
    for (String favourite in favourites) {
      Map<String, dynamic> cityData = jsonDecode(favourite);
      if (cityData['cityName'] == _cityName) {
        return true;
      }
    }
    return false;
  }

  Future<void> _addToFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favourites = prefs.getStringList('favourites') ?? [];

    // Create a map with the city name and temperature
    Map<String, dynamic> cityData = {
      'cityName': _cityName,
      'temperature': _temperature,
      'description': _description
    };

    // Serialize the map to a JSON string
    String cityDataJson = jsonEncode(cityData);

    if (!favourites.contains(cityDataJson)) {
      favourites.add(cityDataJson);
      await prefs.setStringList('favourites', favourites);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_cityName added to favourites')),
      );
      setState(() {
        _isFavorite = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_cityName is already in favourites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png"),
        centerTitle: false,
        backgroundColor: const Color.fromRGBO(136, 81, 204, 0.68),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              _navigateAndDisplaySelection(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(left: 15.0),
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                },
              ),
            ),
            ListTile(
              title: const Text('Favourite'),
              onTap: () {
                // Close the drawer and navigate to Favourite
                Navigator.pop(context);
                _navigateToFavotiteScreen(context);
                //Navigator.pushNamed(context, '/favourite');
              },
            ),
            ListTile(
              title: const Text('Recent Search'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/recent');
              },
            ),
          ],
        ),
      ),
      body: Container(
          color: const Color.fromRGBO(136, 81, 204, 0.68),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  'assets/splash_bg.png',
                  fit: BoxFit.fill,
                ),
              ),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 35.0),
                          child: Text(
                            _dateTime,
                            style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFFFFFFFF)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _cityName,
                          style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF)),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: _addToFavourites,
                                child: const Text(
                                  'Add to favourite',
                                  style: TextStyle(
                                      fontSize: 13.0, color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        Column(
                          children: <Widget>[
                            const Icon(
                              Icons.sunny,
                              color: Color(0xFFFFFFFF),
                              size: 50.0,
                            ), // Add sun image asset
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    // Handle temperature text click
                                  },
                                  child: Text(
                                    _temperature.toString(),
                                    style: const TextStyle(
                                        fontSize: 52.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF)),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _description,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          )),
    );
  }
}

String formatDateTime(int dt) {
  DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(dt * 1000000);
  DateFormat formatter = DateFormat('E, d MMM yyyy HH:mm a');
  return formatter.format(dateTime);
}
