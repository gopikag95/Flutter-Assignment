import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/weather_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> _cities = [];
  final WeatherService _weatherService = WeatherService();
  bool _isLoading = false;

  Future<void> _searchCity(String query) async {
    if (query.isEmpty) {
      setState(() {
        _cities = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final data = await _weatherService.searchCity(query);
    setState(() {
      _cities = List<String>.from(data['list'].map((city) => city['name']));
      _isLoading = false;
    });
  }

  Future<void> _saveRecentSearch(
      String cityName, double temperature, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = prefs.getStringList('recent_searches') ?? [];

    Map<String, dynamic> cityData = {
      'cityName': cityName,
      'temperature': temperature,
      'description': description,
    };

    String cityDataJson = jsonEncode(cityData);

    // Avoid duplicates
    recentSearches.removeWhere((item) {
      Map<String, dynamic> data = jsonDecode(item);
      return data['cityName'] == cityName;
    });

    recentSearches.add(cityDataJson);
    await prefs.setStringList('recent_searches', recentSearches);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _searchCity(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search for city',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_cities[index]),
                    onTap: () async {
                      // Fetch the weather data for the selected city
                      final weatherData =
                          await _weatherService.fetchWeather(_cities[index]);
                      double temperature = weatherData['main']['temp'];
                      String description = weatherData['weather'][0]['main'];

                      // Save the city name, temperature, and description
                      _saveRecentSearch(
                          _cities[index], temperature, description);

                      Navigator.pop(context, _cities[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
