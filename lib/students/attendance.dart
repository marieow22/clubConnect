import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFDC79),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the menu
            },
            icon: const Icon(Icons.menu),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        backgroundColor: const Color(0xFFFFDC79),
        // holds the content of the menu
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 65.0),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              ),
              child: const Row(
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
                Navigator.pushReplacementNamed(context, '/studentcalendar');
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: const Row(
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
                // CHANGE: Closes the drawer instead of reloading the page.
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: const Row(
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
                Navigator.pushReplacementNamed(context, '/allClubs');
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: const Row(
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
            const SizedBox(height: 1.0),
            TextButton(
              onPressed: () async {
                // CHANGE: Signs the user out of Firebase.
                await FirebaseAuth.instance.signOut();
                // CHANGE: Navigates to the login screen and clears all previous routes.
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: const Row(
                children: [
                  // CHANGE: Corrected the icon for signing out.
                  Icon(
                    Icons.logout,
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