class CalendarMonth {
  final int year;
  final int month;

  CalendarMonth({
    required this.year,
    required this.month,
  });

  factory CalendarMonth.fromDate(DateTime date) {
    return CalendarMonth(
      year: date.year,
      month: date.month,
    );
  }

  factory CalendarMonth.now() {
    return CalendarMonth.fromDate(DateTime.now());
  }

  String get id => '$year-$month';

  DateTime get startDate => DateTime(year, month);

  int get durationDays {
    return DateTime(year, month + 1, 0).day;
  }

  String name({bool shortened = false}) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final name = monthNames[month - 1];
    return shortened ? name.substring(0, 3) : name;
  }

  @override
  String toString() => '${name()} $year';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarMonth &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month;

  @override
  int get hashCode => year.hashCode ^ month.hashCode;
}





