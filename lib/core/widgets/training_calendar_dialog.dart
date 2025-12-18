import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainingCalendarDialog extends StatefulWidget {
  const TrainingCalendarDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xFF191919),
      builder: (context) => const TrainingCalendarDialog(),
    );
  }

  @override
  State<TrainingCalendarDialog> createState() => _TrainingCalendarDialogState();
}

class _TrainingCalendarDialogState extends State<TrainingCalendarDialog> {
  DateTime _currentDate = DateTime(2025, 12, 1);
  DateTime _selectedDate = DateTime.now();
  final DateTime _completedDate = DateTime(2025, 12, 16);
  final DateTime _nextDate = DateTime(2025, 12, 19);

  String _getMonthName(int month) {
    const months = [
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
      'December'
    ];
    return months[month - 1];
  }

  List<String> _getWeekDays() {
    return ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  }

  List<DateTime> _getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday == 7 ? 0 : firstDay.weekday;

    final List<DateTime> days = [];
    for (int i = 0; i < firstWeekday; i++) {
      days.add(DateTime(date.year, date.month, 0));
    }
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(date.year, date.month, i));
    }
    final remainingDays = 42 - days.length;
    for (int i = 1; i <= remainingDays; i++) {
      days.add(DateTime(date.year, date.month + 1, i));
    }
    return days;
  }

  bool _isCompletedDate(DateTime date) {
    return date.year == _completedDate.year &&
        date.month == _completedDate.month &&
        date.day == _completedDate.day;
  }

  bool _isNextDate(DateTime date) {
    return date.year == _nextDate.year && date.month == _nextDate.month && date.day == _nextDate.day;
  }

  bool _isSelectedDate(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(_currentDate);
    final weekDays = _getWeekDays();

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'Calendar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF237537),
                          Color(0xFF36C557),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${_getMonthName(_currentDate.month)} ${_currentDate.year}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              final isCurrentMonth = date.month == _currentDate.month && date.year == _currentDate.year;
              final isCompleted = _isCompletedDate(date);
              final isNext = _isNextDate(date);
              final isSelected = _isSelectedDate(date);

              return GestureDetector(
                onTap: isCurrentMonth
                    ? () {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    : null,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCurrentMonth
                        ? (isSelected
                            ? Colors.black
                            : isCompleted
                                ? const Color(0xFF2A7A3D)
                                : isNext
                                    ? const Color(0xFF36C557)
                                    : Colors.transparent)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: isCurrentMonth
                      ? Text(
                          '${date.day}',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isCompleted || isNext ? Colors.white : Colors.white),
                            fontSize: 14.sp,
                            fontWeight:
                                (isSelected || isCompleted || isNext) ? FontWeight.bold : FontWeight.normal,
                          ),
                        )
                      : const SizedBox(),
                ),
              );
            },
          ),
          SizedBox(height: 0.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(
                  color: const Color(0xFF2A7A3D),
                  label: 'Completed training session',
                ),
                SizedBox(height: 15.h),
                _buildLegendItem(
                  color: const Color(0xFF36C557),
                  label: 'Next training session',
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
