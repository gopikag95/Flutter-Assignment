import 'package:flutter/material.dart';
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
        // Adjust height for padding
        child: Container(
          padding: const EdgeInsets.only(top: 20), // Add desired top padding
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
                    onTap: () {
                      // Handle city selection
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
