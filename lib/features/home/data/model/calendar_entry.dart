import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarEntry {
  final String id;
  final DateTime dateCompleted;

  CalendarEntry({
    required this.id,
    required this.dateCompleted,
  });

  factory CalendarEntry.fromJson(Map<String, dynamic> json, String id) {
    return CalendarEntry(
      id: id,
      dateCompleted: (json['dateCompleted'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateCompleted': Timestamp.fromDate(dateCompleted),
    };
  }

  DateTime get dateOnly {
    return DateTime(dateCompleted.year, dateCompleted.month, dateCompleted.day);
  }
}

