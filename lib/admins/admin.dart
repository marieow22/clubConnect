// (full file — updated to write 'schoolId' instead of 'schoolIds')
import 'package:flutter/material.dart';
import '../classes/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Admin extends StatefulWidget {

  final AppRole role;

  const Admin({super.key, required this.role});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  final Map<String, String> schoolIds = {
    'PC west': 'PC_west',
    'Western heights': 'Western_heights',
    'Francis Tuttle': 'Francis_Tuttle',
  };


  String? selectSchool;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController schoolEmail = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<bool> signInAdmin(String email, String password) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(uid)
          .get();

      if (!adminDoc.exists) return false;
      if (adminDoc['role'] != 'admin') return false;

      return true;
    } catch (e) {
      print("Admin login error: $e");
      return false;
    }
  }

  /*Tells the code (app) that these student emails and makes sure its the
  correct one*/
  AppRole getRoleForEmail(String email) {
    const adminEmails = [
      'barbie.roscoe@westernheights.k12.ok.us',
      'aquinten@putnamcityschools.org',
      'mason.rick@francistuttle.edu',
    ];

    if (adminEmails.contains(email.toLowerCase())) {
      return AppRole.admin;
    }
    return AppRole.student;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/pictures/Catbckgrnd.webp',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Stack(
                          children: <Widget> [
                            Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'YoungSerif',
                                letterSpacing: 3.0,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 10.0
                                  ..color = Colors.black,
                              ),
                            ),
                            Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'YoungSerif',
                                letterSpacing: 3.0,
                                color: Color(0xFFFFDC79),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 200.0),
                      TextFormField(
                          controller: schoolEmail,
                          decoration: InputDecoration(
                            labelText: 'School Email',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your school email';
                            }
                            return null;
                          }
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          }
                      ),
                      SizedBox(height: 20.0),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select School',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        value: selectSchool,
                        items: schoolIds.keys.map((String school) {
                          return DropdownMenuItem<String>(
                            value: school,
                            child: Text(school),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectSchool = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a school';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 100.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                // 1. Create the user in Firebase Auth
                                final userCredential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: schoolEmail.text.trim(),
                                  password: password.text.trim(),
                                );

                                final user = userCredential.user;

                                final schoolId = schoolIds[selectSchool]!;

                                // 2. Determine role based on email
                                final role = getRoleForEmail(schoolEmail.text.trim());

                                // 2. Save extra info in Firestore
                                await FirebaseFirestore.instance
                                    .collection('admins')
                                    .doc(user!.uid)
                                    .set({
                                  'email': user.email,
                                  'school': selectSchool,
                                  'schoolId': schoolId, // singular canonical schoolId
                                  'role': 'admin',
                                }, SetOptions(merge: true));

                                /*This is here so there is no back arrow when
                                  the user signs in*/
                                Navigator.pushReplacementNamed(context, '/adminHome');

                                // 3. Navigate to home
                              } catch (e) {
                                // Show error to user
                                print('Admin login error: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFDC79),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}