import 'package:flutter/material.dart';
import 'package:weather_app/recentsearch.dart';
import 'package:weather_app/search.dart';

import 'favourites.dart';
import 'home.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      routes: {
        '/search': (context) => SearchScreen(),
        '/favourite': (context) => FavouriteScreen(),
        '/recent': (context) => RecentSearchScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
