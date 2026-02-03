import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../classes/enums.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class Login extends StatefulWidget {

  final AppRole role;

  const Login({super.key, required this.role});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // Map each school name to canonical id and student email domain
  final Map<String, Map<String, String>> schoolInfo = {
    'PC west': {
      'id': 'PC_west',
      'domain': '@student.putnamcityschools.edu'
    },
    'Western heights': {
      'id': 'Western_heights',
      'domain': '@student.whisd.org'
    },
    'Francis Tuttle': {
      'id': 'Francis_Tuttle',
      'domain': '@student.francistuttle.edu'
    },
  };

  String? selectSchool;

  /*Tells the code (app) that these student emails and makes sure its the
  correct one*/
  AppRole getRoleForEmail(String email) {
    const studentEmails = [
      'aw1234568@student.francistuttle.edu',
      'emily.i.liam@student.whisd.org',
    ];

    return AppRole.student;
  }

  Future<void> _setupNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Ask permission
    await messaging.requestPermission();

    // Get device token
    String? token = await messaging.getToken();

    print('Student FCM Token: $token');

    // Save token to Firestore
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .set(
      {'fcmToken': token},
      SetOptions(merge: true),
    );
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController schoolEmail = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController adminEmail = TextEditingController();


  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 2. Define the Sign-In function
  Future<void> _signInWithGoogle() async {
    try {
      // Triggers the popup where the user selects their account
      final googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // Sign-in was successful!
        print('Signed in as: ${googleUser.displayName}');
        print('Email: ${googleUser.email}');

        // Navigate to the home screen
        if (mounted) {
          Navigator.pushNamed(context, '/home');
        }
      }
    } catch (error) {
      print('Google Sign-In failed: $error');
    }
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
                      Stack(
                        children: <Widget>[
                          // Stroked text as border.
                          Text(
                            'Club Connect',
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
                          // Solid text as fill.
                          Text(
                            'Club Connect',
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
                      SizedBox(height: 50.0),
                      Stack(
                        children: <Widget> [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 30.0,
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
                            'Login',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'YoungSerif',
                              letterSpacing: 3.0,
                              color: Color(0xFFFFDC79),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 90.0),
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
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email address';
                            }
                            // Validate email domain against selected school
                            if (selectSchool != null) {
                              String? domain = schoolInfo[selectSchool]?['domain'];
                              if (domain != null &&
                                  !value.toLowerCase().endsWith(domain.toLowerCase())) {
                                return 'Email must end with $domain for $selectSchool';
                              }
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
                        items: schoolInfo.keys.map((String school) {
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
                      SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgot_password');
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text.rich(
                            TextSpan(
                              text: 'Forgot Password?',
                              style: TextStyle(
                                color: Color(0xFF7A4C10),
                                fontSize: 21.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 100.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                // 1. Sign the user in with Firebase Auth
                                final userCredential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: schoolEmail.text.trim(),
                                  password: password.text.trim(),
                                );

                                final user = userCredential.user;

                                // 2. Determine role based on email (kept for compatibility)
                                final role = getRoleForEmail(schoolEmail.text.trim());

                                // 2. Save extra info in Firestore
                                final canonicalSchoolId = schoolInfo[selectSchool]?['id'];
                                await FirebaseFirestore.instance
                                    .collection('students')
                                    .doc(user!.uid)
                                    .set({
                                  'email': user.email,
                                  'schoolId': canonicalSchoolId, // canonical id
                                  'role': 'student',
                                }, SetOptions(merge: true));

                                await _setupNotifications();

                                /*This is here so there is no back arrow when
                                                        the user signs in*/
                                Navigator.pushReplacementNamed(context, '/home');

                                // 3. Navigate to home
                              } catch (e) {
                                // Show error to user
                                print('Error signing up: $e');
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
                      SizedBox(height: 9.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/teacher');
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Are you an teacher?',
                            style: TextStyle(
                              color: Color(0xFF7A4C10),
                              fontSize: 21.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Not logged in?',
                            style: TextStyle(
                              color: Color(0xFF7A4C10),
                              fontSize: 21.0,
                              decoration: TextDecoration.underline,
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
