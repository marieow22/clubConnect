import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final Map<String, String> schoolIds = {
    'PC west': 'PC_west',
    'Western heights': 'Western_heights',
    'Francis Tuttle': 'Francis_Tuttle',
  };

  String? selectSchool;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController schoolEmail = TextEditingController();
  final TextEditingController messageCtrl = TextEditingController();

  @override
  void dispose() {
    schoolEmail.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectSchool == null) return;

    final schoolKey = selectSchool!;
    final schoolId = schoolIds[schoolKey]!;
    final user = FirebaseAuth.instance.currentUser;
    final requesterEmail = user?.email ?? schoolEmail.text.trim();
    final requesterName = user?.displayName ?? '';

    try {
      final docRef = await FirebaseFirestore.instance.collection('admin_contact_requests').add({
        'schoolId': schoolId,
        'schoolName': schoolKey,
        'requesterEmail': requesterEmail,
        'requesterName': requesterName,
        'message': messageCtrl.text.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request sent. The school admin will be notified.')),
      );

      // Optionally clear fields
      messageCtrl.clear();
      schoolEmail.clear();
      setState(() => selectSchool = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send request: $e')),
      );
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
              padding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // "Forgot" with stroke + fill
                      Stack(
                        children: <Widget>[
                          Text(
                            'Forgot',
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
                            'Forgot',
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
                      const SizedBox(height: 1.0),
                      // "Password" with stroke + fill
                      Stack(
                        children: <Widget>[
                          Text(
                            'Password',
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
                            'Password',
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
                      const SizedBox(height: 40.0),
                      const Text(
                        'Please enter the email your admin is associated with so they will be notified that you need your password',
                        style: TextStyle(
                          backgroundColor: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60.0),
                      // Email Field
                      TextFormField(
                        controller: schoolEmail,
                        decoration: const InputDecoration(
                          labelText: 'Admin Email',
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
                        },
                      ),
                      const SizedBox(height: 20.0),
                      // School Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
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
                          onPressed: _submitRequest,
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