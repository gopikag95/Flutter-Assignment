import 'package:flutter/material.dart';
import 'package:weather_app/recent_search_screen.dart';
import 'package:weather_app/search_screen.dart';

import 'favourites-screen.dart';
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
        '/favourite': (context) => const FavouriteScreen(),
        '/recent': (context) => RecentSearchScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
