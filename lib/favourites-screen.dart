import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Map<String, dynamic>> _favoriteCities = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteCities();
  }

  Future<void> _loadFavoriteCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCitiesJson = prefs.getStringList('favourites') ?? [];

    setState(() {
      _favoriteCities = favoriteCitiesJson.map((cityJson) {
        try {
          return jsonDecode(cityJson) as Map<String, dynamic>;
        } catch (e) {
          print('Error decoding JSON: $e');
          return <String, dynamic>{};
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favourites',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: const Color.fromRGBO(136, 81, 204, 0.68),
        child: _favoriteCities.isEmpty
            ? const Center(
                child: Text(
                  'No favourite cities added',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: _favoriteCities.length,
                itemBuilder: (context, index) {
                  if (_favoriteCities[index].isEmpty) {
                    return Container(); // Skip if there's an error in the data
                  }

                  String cityName =
                      _favoriteCities[index]['cityName'] ?? 'Unknown City';
                  double temperature =
                      _favoriteCities[index]['temperature'] ?? 0.0;
                  String description =
                      _favoriteCities[index]['description'] ?? 'No description';

                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, _favoriteCities[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                cityName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(
                                    Icons.wb_sunny,
                                    color: Color(0xFFFFA500),
                                    size: 50.0,
                                  ),
                                  const SizedBox(width: 16.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${temperature.toStringAsFixed(1)}°C',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        description,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
