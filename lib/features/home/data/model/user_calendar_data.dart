import 'calendar_entry.dart';
import 'calendar_month.dart';
import 'calendar_week.dart';
import 'calendar_day.dart';

class UserCalendarData {
  final List<CalendarEntry> entries;

  UserCalendarData({required this.entries});

  List<CalendarMonth> get months {
    if (entries.isEmpty) return [];
    
    final sortedEntries = List<CalendarEntry>.from(entries)
      ..sort((a, b) => a.dateCompleted.compareTo(b.dateCompleted));
    
    final earliestEntry = sortedEntries.first;
    final nextTraining = this.nextTraining;
    
    final monthsSet = <CalendarMonth>{};
    var currentDate = earliestEntry.dateCompleted;
    final endTimestamp = nextTraining.millisecondsSinceEpoch;
    
    while (currentDate.millisecondsSinceEpoch <= endTimestamp) {
      monthsSet.add(CalendarMonth.fromDate(currentDate));
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }
    
    return monthsSet.toList()..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  List<CalendarWeek> weeksForMonth(CalendarMonth month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final startOfMonthBuffer = firstDay.weekday % 7;
    final adjustedFirstDate = firstDay.subtract(Duration(days: startOfMonthBuffer));
    
    final totalDisplayedWeeks = ((month.durationDays + startOfMonthBuffer) / 7).ceil();
    final totalDays = 7 * totalDisplayedWeeks;
    
    final weeks = <CalendarWeek>[];
    var currentDate = adjustedFirstDate;
    var currentDayNo = 0;
    
    while (currentDayNo < totalDays) {
      if (currentDayNo % 7 == 0) {
        weeks.add(CalendarWeek(days: []));
      }
      
      final day = CalendarDay(
        date: currentDate,
        associatedEntry: associatedEntryForDay(currentDate),
        isBufferDay: currentDayNo < startOfMonthBuffer ||
            currentDayNo >= startOfMonthBuffer + month.durationDays,
      );
      
      weeks.last.days.add(day);
      currentDate = currentDate.add(const Duration(days: 1));
      currentDayNo++;
    }
    
    return weeks;
  }

  CalendarEntry? associatedEntryForDay(DateTime day) {
    final dayComponents = DateTime(day.year, day.month, day.day);
    try {
      return entries.firstWhere(
        (entry) {
          final entryComponents = DateTime(
            entry.dateCompleted.year,
            entry.dateCompleted.month,
            entry.dateCompleted.day,
          );
          return entryComponents == dayComponents;
        },
      );
    } catch (e) {
      return null;
    }
  }

  DateTime get nextTraining {
    final today = DateTime.now();
    final todayComponents = DateTime(today.year, today.month, today.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayComponents = DateTime(yesterday.year, yesterday.month, yesterday.day);
    
    final hasTodayEntry = entries.any((entry) {
      final entryComponents = DateTime(
        entry.dateCompleted.year,
        entry.dateCompleted.month,
        entry.dateCompleted.day,
      );
      return entryComponents == todayComponents;
    });
    
    final hasYesterdayEntry = entries.any((entry) {
      final entryComponents = DateTime(
        entry.dateCompleted.year,
        entry.dateCompleted.month,
        entry.dateCompleted.day,
      );
      return entryComponents == yesterdayComponents;
    });
    
    int daysFromNow = 0;
    if (hasTodayEntry) {
      daysFromNow = 2;
    } else if (hasYesterdayEntry) {
      daysFromNow = 1;
    }
    
    return today.add(Duration(days: daysFromNow));
  }

  int get trainingSessionsThisWeek {
    final days = _daysOfThisWeek;
    return entries.where((entry) {
      final entryComponents = DateTime(
        entry.dateCompleted.year,
        entry.dateCompleted.month,
        entry.dateCompleted.day,
      );
      return days.contains(entryComponents);
    }).length;
  }

  int get trainingSessionsThisMonth {
    final days = _daysOfThisMonth;
    return entries.where((entry) {
      final entryComponents = DateTime(
        entry.dateCompleted.year,
        entry.dateCompleted.month,
        entry.dateCompleted.day,
      );
      return days.contains(entryComponents);
    }).length;
  }

  List<DateTime> get _daysOfThisMonth {
    final result = <DateTime>[];
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    var currentDate = startOfMonth;
    while (currentDate.isBefore(endOfMonth) || currentDate.isAtSameMomentAs(endOfMonth)) {
      result.add(DateTime(currentDate.year, currentDate.month, currentDate.day));
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return result;
  }

  List<DateTime> get _daysOfThisWeek {
    final result = <DateTime>[];
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    var currentDate = startOfWeek;
    while (currentDate.isBefore(endOfWeek) || currentDate.isAtSameMomentAs(endOfWeek)) {
      result.add(DateTime(currentDate.year, currentDate.month, currentDate.day));
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return result;
  }
}

