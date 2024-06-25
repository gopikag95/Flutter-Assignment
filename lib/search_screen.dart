import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> _cities = [];
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

    // Replace with your actual API call
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/find?q=$query&type=like&sort=population&cnt=30&appid=40971316b92f3b5242754e0f651139ec'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _cities = List<String>.from(data['list'].map((city) => city['name']));
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load cities');
    }
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
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        // Adjust height for padding
        child: Container(
          padding: EdgeInsets.only(top: 20), // Add desired top padding
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: TextField(
              controller: _controller,
              decoration: InputDecoration(
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
              child: _cities.isEmpty
                  ? Center(child: Text('No cities found'))
                  : ListView.builder(
                      itemCount: _cities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_cities[index]),
                          onTap: () {
                            // Handle city selection
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
