import 'calendar_entry.dart';

class CalendarDay {
  final DateTime date;
  CalendarEntry? associatedEntry;
  final bool isBufferDay;

  CalendarDay({
    required this.date,
    this.associatedEntry,
    this.isBufferDay = false,
  });

  String get id => date.toString();

  int get dayNo => date.day;

  DateTime get dateOnly {
    return DateTime(date.year, date.month, date.day);
  }

  bool isSameDay(DateTime other) {
    return date.year == other.year &&
        date.month == other.month &&
        date.day == other.day;
  }
}

