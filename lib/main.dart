import 'package:club_connect/Calendars/adminCalendar.dart';
import 'package:club_connect/admins/adminHome.dart';
import 'package:club_connect/students/Register.dart';
import 'package:club_connect/admins/admin.dart';
import 'package:club_connect/Calendars/studentcalendar.dart';
import 'package:club_connect/students/attendance.dart';
import 'package:club_connect/ChooseClubs/allClubs.dart';
import 'package:club_connect/students/clubs.dart';
import 'package:club_connect/students/forgot_password.dart';
import 'package:club_connect/students/home.dart';
import 'package:club_connect/students/student.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'classes/enums.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Make sure Flutter is initialized
  FirebaseMessaging.onMessage.listen((message) {
    print('Notification received: ${message.notification?.title}');
  });

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        //student
        '/': (context) => Login(role: AppRole.student),
        '/forgot_password': (context) => forgotPassword(),
        '/register': (context) => Register(role: AppRole.student),
        '/home': (context) => Home(role: AppRole.student),
        '/studentcalendar': (context) => Calendar(),
        '/attendance': (context) => Attendance(),
        '/allClubs': (context) => Clubs(),

        // admin
        '/admin': (context) => Admin(role: AppRole.admin),
        '/adminHome': (context) => adminhome(),
        '/adminCalendar': (context) => admincalendar(),
      },
    );
  }
}
