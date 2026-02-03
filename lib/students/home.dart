import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../classes/enums.dart';

class Home extends StatefulWidget {
  final AppRole role;

  const Home({super.key, required this.role});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String? userName;
  String? photoUrl;
  String? school;

  Future<void> _loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .get();

    if (doc.exists) {
      setState(() {
        userName = doc.data()?['name'];
        photoUrl = doc.data()?['photoUrl'];
        school = doc.data()?['schoolId'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          (school ?? 'Loading. . .').replaceAll('_', ' '),
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: SafeArea(
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: (photoUrl != null && photoUrl!.isNotEmpty)
                      ? Image.network(
                    photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 40);
                    },
                  )
                      : const Icon(Icons.person, size: 40),
                ),
                SizedBox(height: 16),
                Text(
                  userName ?? 'Loading...',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  height: 60.0,
                  color: Colors.black,
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ],
                )
              ],
            )
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
            const SizedBox(height: 100.0),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);;
              },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Sign Out',
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