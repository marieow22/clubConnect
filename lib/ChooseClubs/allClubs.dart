import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:club_connect2/classes/Club.dart';

class Clubs extends StatefulWidget {
  const Clubs({super.key});

  @override
  State<Clubs> createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  // The complete list of all available clubs
  final List<Club> _allClubs = [
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

  // A set to keep track of the clubs the user has joined.
  final Set<Club> _joinedClubs = {};

  @override
  void initState() {
    super.initState();
    // When the screen loads, fetch the student's currently joined clubs from the database.
    _loadJoinedClubs();
  }

  // Fetches the list of joined club names from Firestore and updates the UI.
  Future<void> _loadJoinedClubs() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('students').doc(uid).get();

    if (doc.exists) {
      final data = doc.data();
      final List<String> clubNames = List<String>.from(data?['joinedClubs'] ?? []);

      setState(() {
        _joinedClubs.clear();
        for (var clubName in clubNames) {
          // For each club name from the database, find the corresponding Club object.
          final club = _allClubs.firstWhere((c) => c.name == clubName, orElse:
              () => Club(name: 'Unknown', color: Colors.grey));
          if (club.name != 'Unknown') {
            _joinedClubs.add(club);
          }
        }
      });
    }
  }

  // This function is called when a user taps a club circle.
  void _toggleClubSelection(Club club) {
    setState(() {
      if (_joinedClubs.contains(club)) {
        _joinedClubs.remove(club);
      } else {
        _joinedClubs.add(club);
      }
    });
  }

  // Saves the selected clubs to Firestore and navigates back.
  Future<void> _saveAndShowJoinedClubs() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    // Convert the set of Club objects to a list of strings (club names).
    final clubNames = _joinedClubs.map((c) => c.name).toList();

    try {
      // Update the 'joinedClubs' field for the current student in the database.
      await FirebaseFirestore.instance
          .collection('students')
          .doc(uid)
          .update({'joinedClubs': clubNames});

      // Show a confirmation message to the user.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully saved your clubs!'),
          duration: Duration(seconds: 2),
        ),
      );

      // After saving, go back to the previous screen (the home screen).
      Navigator.pop(context);

    } catch (e) {
      // If there's an error, show it in a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving clubs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Clubs you can join',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
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
                Navigator.pushNamed(context, '/manageAttendance');
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
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16.0, 120.0, 16.0, 16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.5, // Aspect ratio for a rectangular shape
        ),
        itemCount: _allClubs.length,
        itemBuilder: (context, index) {
          final club = _allClubs[index];
          final isJoined = _joinedClubs.contains(club);
          return GestureDetector(
            onTap: () => _toggleClubSelection(club),
            child: Card(
              elevation: 4.0,
              color: club.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      club.name,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (isJoined)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAndShowJoinedClubs,
        backgroundColor: const Color(0xFFFFDC79),
        child: const Icon(Icons.check),
      ),
    );
  }
}
