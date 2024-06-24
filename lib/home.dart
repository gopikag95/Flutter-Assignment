import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(left: 15.0),
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40.0),
              child: ListTile(
                title: Text('Home'),
                onTap: () {
                  // Close the drawer and navigate to Home
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                },
              ),
            ),
            ListTile(
              title: Text('Favourite'),
              onTap: () {
                // Close the drawer and navigate to Favourite
                Navigator.pop(context);
                Navigator.pushNamed(context, '/favourite');
              },
            ),
            ListTile(
              title: Text('Recent Search'),
              onTap: () {
                // Close the drawer and navigate to Recent Search
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 35.0),
                    child: Text(
                      'Wed, 28 Nov 2018    11:35 AM',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFFFFFFFF)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Udupi, Karnataka',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF)),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.favorite_border, color: Color(0xFFFFFFFF)),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            // Handle add to favorites action
                          },
                          child: Text(
                            'Add to favourite',
                            style: TextStyle(
                                fontSize: 13.0, color: Color(0xFFFFFFFF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Column(
                    children: <Widget>[
                      Icon(
                        Icons.sunny,
                        color: Color(0xFFFFFFFF),
                        size: 50.0,
                      ), // Add sun image asset
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              // Handle temperature text click
                            },
                            child: Text(
                              "31",
                              style: TextStyle(
                                  fontSize: 52.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF)),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Mostly sunny',
                            style: TextStyle(fontSize: 16.0),
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
