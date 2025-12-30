import 'calendar_day.dart';

class CalendarWeek {
  final String id;
  final List<CalendarDay> days;

  CalendarWeek({
    String? id,
    required this.days,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}





