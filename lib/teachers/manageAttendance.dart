import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageAttendance extends StatefulWidget {
  const ManageAttendance({super.key});

  @override
  State<ManageAttendance> createState() => _ManageAttendanceState();
}

class _ManageAttendanceState extends State<ManageAttendance> { 

  List<DocumentSnapshot> _teacherClubs = [];
  bool _isLoading = true;

  /*final List<String> _allClubs = [
    'Musical',
    'Art club',
    'Chess club',
    'Dance club',
    'Choir',
    'Debate club',
    'Soccer club',
    'Spanish club',
    'Band club',
    'Key club',
    'Exchange club',
    'STEM club',
    'Cooking club',
    'Anime club',
    'Stuco club',
    'Photographic club',
    'Improv club',
    'Ceramics club',
    'Mathletes club',
    'French club',
    'Yearbook club',
    'Fashion club',
    'Book club',
    'Robotics club',
    'Tutoring club',
    'Foreign languages club',
    'Coding club',
    'Poetry club',
    'Film club',
    'Humane Society Club',
    'Tennis Club',
    'Baseball Club',
  ];*/

  @override
  void initState() {
    super.initState();
    _fetchTeacherClubs();
  }

  Future<void> _fetchTeacherClubs() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('clubs')
            .where('teacherId', isEqualTo: user.uid)
            .get();
        if (mounted) {
          setState(() {
            _teacherClubs = querySnapshot.docs;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching teacher clubs: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance Management',
          style: TextStyle(
            fontStyle: FontStyle.italic,
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
                Navigator.pushNamed(context, '/teacherHome');
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
                Navigator.pushNamed(context, '/teacherCalendar');
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
                    'Manage Attendance',
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
                Navigator.pushNamedAndRemoveUntil(context, '/teacher', (route) => false);
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
                  SizedBox(width: 10), Text(
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _teacherClubs.isEmpty
          ? Center(child: Text('You are not assigned to any clubs.'))
          : ListView.builder(
          itemCount: _teacherClubs.length,
         itemBuilder: (context, index) {
           final club = _teacherClubs[index];
           final clubName = (club.data() as Map<String, dynamic>)['name'] ?? 'Unnamed Club';
           return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
             child: ListTile(
               title: Text(clubName),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
                onTap: () {
               // TODO: Navigate to the attendance page for the selected club
                  print('Selected club: $clubName (ID: ${club.id})');
             },
            ),
          );
        },
      ),
    );
  }
}