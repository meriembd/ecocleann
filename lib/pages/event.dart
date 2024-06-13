import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final DateTime date;

  Event(this.title, this.date);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': Timestamp.fromDate(
          date), // Assurez-vous de convertir en Timestamp ici
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      map['title'],
      (map['date'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() => title;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          date == other.date;

  @override
  int get hashCode => title.hashCode ^ date.hashCode;
}
