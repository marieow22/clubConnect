// (full file — updated to handle legacy domain-style schoolId values)
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../classes/events.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String? studentSchoolId;

  // Keep all events for this student’s school
  Map<DateTime, List<Events>> eventsMap = {};

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<Events> _getEventsForDay(DateTime day) {
    final normalizedDay = _normalizeDate(day);
    return eventsMap[normalizedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  // Load the student's schoolId and listen to all events from that school
  Future<void> _loadStudentSchoolAndListenEvents() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Get student document
    final studentDoc = await FirebaseFirestore.instance
        .collection('students')
        .doc(uid)
        .get();

    //  Read stored schoolId (may be canonical id or legacy email domain)
    final rawSchoolId = studentDoc.data()?['schoolId'];
    if (rawSchoolId == null) return;

    // If older code stored domains like "@student.putnamcityschools.edu", map them
    if (rawSchoolId is String && rawSchoolId.contains('@')) {
      final domainToId = {
        '@student.putnamcityschools.edu': 'PC_west',
        '@student.whisd.org': 'Western_heights',
        '@student.francistuttle.edu': 'Francis_Tuttle',
      };
      studentSchoolId = domainToId[rawSchoolId] ?? rawSchoolId;
    } else {
      studentSchoolId = rawSchoolId;
    }

    if (studentSchoolId != null) {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(studentSchoolId)
          .collection('events')
          .snapshots()
          .listen((snapshot) {
        Map<DateTime, List<Events>> newEvents = {};

        for (var doc in snapshot.docs) {
          final data = doc.data();
          final rawDate = data['date'];

          DateTime? parsedDate;
          if (rawDate is Timestamp) {
            parsedDate = rawDate.toDate();
          } else if (rawDate is DateTime) {
            parsedDate = rawDate;
          } else {
            continue;
          }
          final date = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

          newEvents.putIfAbsent(date, () => []);
          newEvents[date]!.add(
            Events(
              id: doc.id,
              title: data['title'] ?? '',
              description: data['description'] ?? '',
            ),
          );
        }
        setState(() {
          eventsMap = newEvents;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStudentSchoolAndListenEvents();
    _selectedDay = _normalizeDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _selectedDay != null
        ? _getEventsForDay(_selectedDay!)
        : _getEventsForDay(today);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Club Calendar',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFDC79),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the menu
            },
            icon: Icon(Icons.menu),
          ),
        ),
      ),
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
                Navigator.pushNamed(context, '/clubs');
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
      body: Column(
        children: [
          const SizedBox(height: 20),
          TableCalendar(
            rowHeight: 60,
            availableGestures: AvailableGestures.all,
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              todayTextStyle: TextStyle(color: Colors.black),       // today
              selectedTextStyle: TextStyle(color: Colors.black),    // selected day
              defaultTextStyle: TextStyle(color: Colors.black),     // normal days
              weekendTextStyle: TextStyle(color: Colors.black),     // weekends
              selectedDecoration: BoxDecoration(
                color: Colors.yellow[200],
                shape: BoxShape.circle,
              ),
              todayDecoration: const BoxDecoration(
                color: Color(0xFFFFDC79),
                shape: BoxShape.circle,
              ),
            ),
            selectedDayPredicate: (day) =>
                isSameDay(day, _selectedDay ?? today),
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2030, 1, 1),
            onDaySelected: _onDaySelected,
            // Show only one dot per day even if multiple events
            eventLoader: (day) {
              final normalizedDay = _normalizeDate(day);
              if ((eventsMap[normalizedDay] ?? []).isNotEmpty) {
                return [eventsMap[normalizedDay]!.first];
              }
              return [];
            },
          ),
          const Divider(color: Colors.grey, thickness: 1),
          Expanded(
            child: selectedEvents.isEmpty
                ? const Center(
              child: Text(
                'No events on this day',
                style: TextStyle(fontSize: 16.0),
              ),
            )
                : ListView.builder(
              itemCount: selectedEvents.length,
              itemBuilder: (context, index) {
                final event = selectedEvents[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Text(event.description),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}