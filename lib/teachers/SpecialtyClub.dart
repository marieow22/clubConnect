import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialtyClub extends StatefulWidget {
  const SpecialtyClub({super.key});

  @override
  State<SpecialtyClub> createState() => _SpecialtyClubState();
}

class _SpecialtyClubState extends State<SpecialtyClub> {
  String? teacherSpecialty;

  @override
  void initState() {
    super.initState();
    _getTeacherSpecialty();
  }

  Future<void> _getTeacherSpecialty() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final teacherDoc = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(user.uid)
          .get();
      if (mounted &&
          teacherDoc.exists &&
          teacherDoc.data()!.containsKey('specialty')) {
        setState(() {
          teacherSpecialty = teacherDoc['specialty'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teacherSpecialty != null
            ? '$teacherSpecialty Clubs'
            : 'Manage Clubs'),
        backgroundColor: Color(0xFFFFDC79),
      ),
      body: Column(
        children: [
          if (teacherSpecialty != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your current specialty: $teacherSpecialty',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('clubs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final clubs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: clubs.length,
                  itemBuilder: (context, index) {
                    final club = clubs[index];
                    return ListTile(
                      title: Text(club['clubName']),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            await FirebaseFirestore.instance
                                .collection('teachers')
                                .doc(user.uid)
                                .update({'specialty': club['clubName']});
                            _getTeacherSpecialty();
                          }
                        },
                        child: Text('Set as Specialty'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
