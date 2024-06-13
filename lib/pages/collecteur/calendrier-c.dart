import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_clean/pages/collecteur/menu-c.dart';
import 'package:eco_clean/pages/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendrier extends StatefulWidget {
  final String userRole;

  const Calendrier({Key? key, required this.userRole}) : super(key: key);

  @override
  State<Calendrier> createState() => _CalendrierState();
}

class _CalendrierState extends State<Calendrier> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  Stream<List<Event>> _eventsStream() {
    return FirebaseFirestore.instance
        .collection('events')
        .snapshots()
        .map((snapshot) {
      List<Event> allEvents = [];
      for (var doc in snapshot.docs) {
        var data = doc.data();
        var eventsData = data['events'] as List;
        allEvents.addAll(eventsData.map((e) => Event.fromMap(e)));
      }
      return allEvents;
    });
  }

  Future<void> _addEventToFirestore(Event event) async {
    final docRef = FirebaseFirestore.instance
        .collection('events')
        .doc(event.date.toIso8601String());
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      await docRef.update({
        'events': FieldValue.arrayUnion([event.toMap()])
      });
    } else {
      await docRef.set({
        'date': Timestamp.fromDate(event.date),
        'events': [event.toMap()]
      });
    }
  }

  Future<void> _updateEventInFirestore(Event oldEvent, Event newEvent) async {
    final docRef = FirebaseFirestore.instance
        .collection('events')
        .doc(oldEvent.date.toIso8601String());

    print('Updating event: ${oldEvent.title} to ${newEvent.title}');

    await docRef.update({
      'events': FieldValue.arrayRemove([oldEvent.toMap()])
    }).then((_) {
      print('Removed old event: ${oldEvent.title}');
    }).catchError((error) {
      print('Error removing old event: $error');
    });

    await docRef.update({
      'events': FieldValue.arrayUnion([newEvent.toMap()])
    }).then((_) {
      print('Added new event: ${newEvent.title}');
    }).catchError((error) {
      print('Error adding new event: $error');
    });
  }

  Future<void> _deleteEventFromFirestore(Event event) async {
    final docRef = FirebaseFirestore.instance
        .collection('events')
        .doc(event.date.toIso8601String());

    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      print('Error: Document does not exist');
      return;
    }

    print('Deleting event: ${event.title}');

    await docRef.update({
      'events': FieldValue.arrayRemove([event.toMap()])
    }).then((_) {
      print('Deleted event: ${event.title}');
      setState(() {}); // Mettre à jour l'interface utilisateur
    }).catchError((error) {
      print('Error deleting event: $error');
    });
  }

  void _addEvent() {
    if (_eventController.text.isEmpty) return;
    final newEvent = Event(_eventController.text, _selectedDay!);
    _addEventToFirestore(newEvent);
    _eventController.clear();
    setState(() {}); // Mettre à jour l'interface utilisateur
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userRole);
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuC(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 172, 145),
        title: const Center(
          child: Text(
            'Calendrier',
            style: TextStyle(fontSize: 39.0),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            size: 36,
            color: Colors.black,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      floatingActionButton: widget.userRole == 'collecteur'
          ? FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 147, 172, 145),
              foregroundColor: const Color.fromARGB(255, 46, 66, 48),
              onPressed: () {
                _eventController.clear();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Ajouter un événement"),
                      content: TextField(controller: _eventController),
                      actions: [
                        ElevatedButton(
                          onPressed: _addEvent,
                          child: Text(
                            'Fermer',
                            style: TextStyle(
                              color: Color.fromARGB(255, 101, 129, 102),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.now(),
            lastDay: DateTime.utc(2030, 3, 14),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 147, 172, 145),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: StreamBuilder<List<Event>>(
              stream: _eventsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun événement trouvé'));
                }
                final events = snapshot.data!
                    .where((event) => isSameDay(event.date, _selectedDay))
                    .toList();
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(events[index].title),
                      trailing: widget.userRole == 'collecteur'
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _eventController.text = events[index].title;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Modifier l'événement"),
                                          content: TextField(
                                              controller: _eventController),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                if (_eventController
                                                    .text.isEmpty) return;
                                                Event updatedEvent = Event(
                                                    _eventController.text,
                                                    events[index].date);
                                                _updateEventInFirestore(
                                                        events[index],
                                                        updatedEvent)
                                                    .then((_) {
                                                  setState(() {});
                                                  _eventController.clear();
                                                  Navigator.of(context).pop();
                                                }).catchError((error) {
                                                  print(
                                                      'Erreur lors de la mise à jour de l\'événement : $error');
                                                });
                                              },
                                              child: Text(
                                                'Modifier',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 101, 129, 102),
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteEventFromFirestore(events[index])
                                        .then((_) {
                                      setState(() {});
                                    }).catchError((error) {
                                      print(
                                          'Erreur lors de la suppression de l\'événement : $error');
                                    });
                                  },
                                ),
                              ],
                            )
                          : null,
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
