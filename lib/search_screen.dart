import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search for city',
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text('Search for city'),
      ),
    );
  }
}
