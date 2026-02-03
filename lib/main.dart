import 'package:club_connect2/Calendars/teacherCalendar.dart';
import 'package:club_connect2/Admin/Inbox.dart';
import 'package:club_connect2/teachers/manageAttendance.dart';
import 'package:club_connect2/teachers/TeacherHome.dart';
import 'package:club_connect2/students/Register.dart';
import 'package:club_connect2/teachers/specialtyClub.dart';
import 'package:club_connect2/teachers/teacher.dart';
import 'package:club_connect2/Calendars/studentcalendar.dart';
import 'package:club_connect2/students/attendance.dart';
import 'package:club_connect2/ChooseClubs/allClubs.dart';
import 'package:club_connect2/students/forgot_password.dart';
import 'package:club_connect2/students/home.dart';
import 'package:club_connect2/students/student.dart';
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
        '/forgot_password': (context) => Forgotpassword(),
        '/register': (context) => Register(role: AppRole.student),
        '/home': (context) => Home(role: AppRole.student),
        '/studentcalendar': (context) => Calendar(),
        '/attendance': (context) => Attendance(),
        '/allClubs': (context) => Clubs(),

        // teacher
        '/teacher': (context) => Teacher(role: AppRole.teacher),
        '/teacherHome': (context) => TeacherHome(),
        '/teacherCalendar': (context) => TeacherCalendar(),
        '/manageAttendance': (context) => ManageAttendance(),
        '/Inbox': (context) => teacherInbox(),
        '/specialtyClub': (context) => SpecialtyClub(),
      },
    );
  }
}
