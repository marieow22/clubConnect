import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Clubs extends StatefulWidget {
  const Clubs({super.key});

  @override
  State<Clubs> createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  final List<String> ClubNames = [
   Club(name: 'Musical', color: const Color(0xFFB35E2E)),
    Club(name: 'Art club', color: Colors.green),
    Club(name: 'Chess club', color: Colors.brown[300]!),
    Club(name: 'Dance club', color: Colors.deepPurple),
    Club(name: 'Choir', color: Colors.blue[200]!),
    Club(name: 'Debate club', color: Colors.blue[600]!),
    Club(name: 'Soccer club', color: Colors.grey),
    Club(name: 'Spanish club', color: Colors.red[600]!),
    Club(name: 'Band club', color: Colors.yellow[900]!),
    Club(name: 'Key club', color: Colors.blue[900]!),
    Club(name: 'Exchange club', color: Colors.yellow[600]!),
    Club(name: 'STEM club', color: Colors.teal[400]!),
    Club(name: 'Cooking club', color: Colors.grey[700]!),
    Club(name: 'Anime club', color: Colors.purple[400]!),
    Club(name: 'Stuco club', color: Colors.blueGrey),
    Club(name: 'Photographic club', color: Colors.grey),
    Club(name: 'Improv club', color: Colors.redAccent[700]!),
    Club(name: 'Ceramics club', color: Colors.brown[200]!),
    Club(name: 'Mathletes club', color: Colors.blue[300]!),
    Club(name: 'French club', color: Colors.indigo[900]!),
    Club(name: 'Yearbook club', color: Colors.yellowAccent[700]!),
    Club(name: 'Fashion club', color: Colors.indigoAccent[200]!),
    Club(name: 'Book club', color: Colors.brown[400]!),
    Club(name: 'Robotics club', color: Colors.lightBlue[200]!),
    Club(name: 'Tutoring club', color: Colors.brown[200]!),
    Club(name: 'Foreign languages club', color: Colors.indigo[100]!),
    Club(name: 'Coding club', color: Colors.green[900]!),
    Club(name: 'Poetry club', color: Colors.brown[400]!),
    Club(name: 'Film club', color: Colors.green[200]!),
    Club(name: 'Humane Society Club', color: Colors.teal[100]!),
    Club(name: 'Tennis Club', color: Colors.green[700]!),
    Club(name: 'Baseball Club', color: Colors.blueAccent[100]!),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Clubs that are Available',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
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
                Navigator.pushNamed(context, '/Home');
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
                Navigator.pushNamed(context, '/Calendar');
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
                Navigator.pushNamed(context, '/attendance');
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.how_to_reg,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Attendance',
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
                Navigator.pushNamed(context, '/allClubs');
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.groups,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Clubs',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 150.0),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.groups,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Sign out',
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

