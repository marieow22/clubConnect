import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../classes/enums.dart';

class Register extends StatefulWidget {

  final AppRole role;

  const Register({super.key, required this.role});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController schoolEmail = TextEditingController();
  final TextEditingController password = TextEditingController();

  // 1. Create the GoogleSignIn instance
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
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Stack(
                          children: <Widget> [
                            Text(
                              'Register',
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
                              'Register',
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
                      SizedBox(height: 40.0),
                      TextFormField(
                          controller: firstName,
                          decoration: InputDecoration(
                            labelText: 'First Name',
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
                              return 'Please enter your first name';
                            }
                            return null;
                          }
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                          controller: lastName,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
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
                              return 'Please enter your last name';
                            }
                            return null;
                          }
                      ),
                      SizedBox(height: 20.0),
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
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                                color: Colors.black,
                                thickness: 1.0
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                                color: Colors.black,
                                thickness: 1.0
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _signInWithGoogle, // 3. Link the function here
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30.0,
                                child: Image.asset('assets/pictures/googleIcon.png'),
                              ),
                              SizedBox(width: 15.0),
                              Text(
                                'Sign In With Google',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 100.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushNamed(context, '/home');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFDC79),
                            minimumSize: Size(130, 50),
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