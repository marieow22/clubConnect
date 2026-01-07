import 'package:flutter/material.dart';
import '../classes/enums.dart';

class Home extends StatefulWidget {
  final AppRole role;

  const Home({super.key, required this.role});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFDC79),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the menu
            },
            icon: Icon(Icons.menu),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        backgroundColor: Color(0xFFFFDC79),
        // holds the content of the menu
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 65.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.black,
                    size: 25.0, // same height as text for visual alignment
                  ),
                  SizedBox(width: 10), // spacing between icon and text
                  Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/studentcalendar');
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Calendar',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
