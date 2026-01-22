import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import '../classes/events.dart';

class admincalendar extends StatefulWidget {
  const admincalendar({super.key});

  @override
  State<admincalendar> createState() => _admincalendarState();
}

class _admincalendarState extends State<admincalendar> {
  DateTime _today = DateTime.now();
  DateTime? _selectedDay;

  String? adminSchoolId;
  Map<DateTime, List<Events>> eventsMap = {};

  TextEditingController _eventController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  late final ValueNotifier<List<Events>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _loadAdminSchool();
    _selectedDay = _today;
    _selectedEvents = ValueNotifier([]);
  }

  @override
  void dispose() {
    _eventController.dispose();
    _descriptionController.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _today = focusedDay;
    });
    _selectedEvents.value = eventsMap[_normalizeDate(selectedDay)] ?? [];
  }

  Future<void> _loadAdminSchool() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final adminDoc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(uid)
        .get();

    if (!adminDoc.exists) {
      debugPrint('Admin document does not exist');
      return;
    }

    setState(() {
      // 🔧 FIX: handle both schoolId and old schoolIds
      adminSchoolId =
      adminDoc.data()!.containsKey('schoolId')
          ? adminDoc['schoolId']
          : adminDoc['schoolIds']; // fallback for old data
    });

    if (adminSchoolId != null && adminSchoolId!.isNotEmpty) {
      _listenToEvents();
    }
  }

  void _listenToEvents() {
    if (adminSchoolId == null || adminSchoolId!.isEmpty) return;

    FirebaseFirestore.instance
        .collection('schools')
        .doc(adminSchoolId)
        .collection('events')
        .snapshots()
        .listen((snapshot) {
      Map<DateTime, List<Events>> newEvents = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();

        if (data['date'] == null) continue; // 🔧 safety

        final date =
        _normalizeDate((data['date'] as Timestamp).toDate());

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
        _selectedEvents.value =
            eventsMap[_normalizeDate(_selectedDay!)] ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
            '~~~ Club Calendar ~~~',
            style: TextStyle(
                fontSize: 25)
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFFFDC79),
          child: Icon(Icons.add,
              color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              scrollable: true,
              title: const Text('Add Event'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: _eventController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Club Name'
                      )
                  ),
                  const SizedBox(height: 10),
                  TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Club Description'
                      )
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    if (_eventController.text.isEmpty || adminSchoolId == null)
                      return;

                    final normalizedDay = _normalizeDate(_selectedDay!);

                    await FirebaseFirestore.instance
                        .collection('schools')
                        .doc(adminSchoolId)
                        .collection('events')
                        .add({
                      'title': _eventController.text,
                      'description': _descriptionController.text,
                      'date': Timestamp.fromDate(normalizedDay),
                      'createdBy': FirebaseAuth.instance.currentUser!.email,
                      'schoolId': adminSchoolId,
                    });

                    _eventController.clear();
                    _descriptionController.clear();

                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit'),
                )
              ],
            ),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: TableCalendar(
                rowHeight: 60,
                availableGestures: AvailableGestures.all,
                calendarFormat: CalendarFormat.month,
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true
                ),
                calendarStyle: CalendarStyle(
                  todayTextStyle: TextStyle(color: Colors.black),
                  selectedTextStyle: TextStyle(color: Colors.black),
                  defaultTextStyle: TextStyle(color: Colors.black),
                  weekendTextStyle: TextStyle(color: Colors.black),
                  selectedDecoration:
                  BoxDecoration(
                      color: Colors.yellow[200],
                      shape: BoxShape.circle
                  ),
                  todayDecoration: const BoxDecoration(
                      color: Color(0xFFFFDC79),
                      shape: BoxShape.circle
                  ),
                ),
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                focusedDay: _today,
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2030, 1, 1),
                eventLoader: (day) {
                  final normalizedDay = _normalizeDate(day);
                  if ((eventsMap[normalizedDay] ?? []).isNotEmpty) {
                    return [eventsMap[normalizedDay]!.first]; // single dot
                  }
                  return [];
                },
              ),
            ),
            const Divider(color: Colors.grey, thickness: 1),
            Expanded(
              child: ValueListenableBuilder<List<Events>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  if (value.isEmpty)
                    return
                      const Center(
                        child: Text(
                            'No events for this day'
                        )
                    );
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final event = value[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          title: Text(event.title),
                          subtitle: Text(event.description),
                          trailing: IconButton(
                            icon: const Icon
                              (
                                Icons.delete,
                                color: Color(0xFFFFDC79)
                            ),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('schools')
                                  .doc(adminSchoolId)
                                  .collection('events')
                                  .doc(event.id)
                                  .delete();
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
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
                Navigator.pushNamed(context, '/adminHome');
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
                Navigator.pushNamed(context, '/adminCalendar');
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
                    Icons.how_to_reg, color: Colors.black,
                      size: 25.0
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
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/admin');
                },
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.black,
                    size: 25.0,
                  ),
                  SizedBox(width: 10),
                  Text(
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
    );
  }
}
