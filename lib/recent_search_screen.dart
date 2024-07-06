import 'package:flutter/material.dart';

class RecentSearchScreen extends StatelessWidget {
  const RecentSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Search'),
      ),
      body: const Center(
        child: Text('This is the recent search screen'),
      ),
    );
  }
}
