import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../imports.dart';
import '../controller/home_controller.dart';
import '../../data/model/calendar_month.dart';
import '../../data/model/calendar_day.dart';

class CalendarViewScreen extends StatelessWidget {
  const CalendarViewScreen({super.key});

  static void show() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xFF1E1E1E),
      builder: (context) => const CalendarViewScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        final calendarData = controller.userCalendarData;
        
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              if (calendarData != null && calendarData.entries.isNotEmpty)
                Expanded(
                  child: _buildCalendar(controller, calendarData),
                )
              else
                Expanded(
                  child: Center(
                    child: Text(
                      'Your training calendar will appear here',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              if (calendarData != null && calendarData.entries.isNotEmpty)
                _buildFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Calendar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF237537),
                    Color(0xFF33C258),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(HomeController controller, calendarData) {
    final months = calendarData.months;
    if (months.isEmpty) {
      return Center(
        child: Text(
          'Calendar will be shown here.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.sp,
          ),
        ),
      );
    }

    return PageView.builder(
      itemCount: months.length,
      itemBuilder: (context, index) {
        final month = months[index];
        final weeks = calendarData.weeksForMonth(month);
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              _buildMonthHeader(month),
              SizedBox(height: 15.h),
              _buildWeekdaysHeader(),
              SizedBox(height: 15.h),
              Expanded(
                child: ListView.builder(
                  itemCount: weeks.length,
                  itemBuilder: (context, weekIndex) {
                    final week = weeks[weekIndex];
                    return _buildWeekRow(week, calendarData);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthHeader(CalendarMonth month) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        month.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWeekdaysHeader() {
    const weekdays = ['Su', 'M', 'Tu', 'W', 'Th', 'F', 'Sa'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekdays.map((day) {
        return SizedBox(
          width: 40.w,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.sp,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeekRow(week, calendarData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: week.days.map((day) {
        return _buildDayView(day, calendarData);
      }).toList(),
    );
  }

  Widget _buildDayView(CalendarDay day, calendarData) {
    final dayViewWidth = 40.w;
    final nextTraining = calendarData.nextTraining;
    final isNextTraining = day.dateOnly.year == nextTraining.year &&
        day.dateOnly.month == nextTraining.month &&
        day.dateOnly.day == nextTraining.day;
    
    final hasEntry = day.associatedEntry != null;
    
    return Container(
      width: dayViewWidth,
      height: dayViewWidth,
      margin: EdgeInsets.symmetric(vertical: 3.h),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hasEntry
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF191919),
                  const Color(0xFF252525),
                ],
              )
            : isNextTraining
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF237537),
                      Color(0xFF33C258),
                    ],
                  )
                : null,
        color: hasEntry || isNextTraining ? null : Colors.transparent,
      ),
      child: Center(
        child: Text(
          '${day.dayNo}',
          style: TextStyle(
            color: day.isBufferDay
                ? Colors.grey
                : (hasEntry || isNextTraining)
                    ? Colors.white
                    : Colors.grey[600],
            fontSize: 14.sp,
            fontWeight: (hasEntry || isNextTraining) ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColorDescription(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF191919),
                Color(0xFF252525),
              ],
            ),
            text: 'Completed training sessions',
          ),
          SizedBox(height: 8.h),
          _buildColorDescription(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF237537),
                Color(0xFF33C258),
              ],
            ),
            text: 'Next training session',
          ),
          SizedBox(height: 15.h),
          Text(
            'Above is your Rypstick training calendar, starting from the month you joined. Have any questions? Contact us at rypstickstaff@gmail.com.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorDescription({
    required Gradient gradient,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            gradient: gradient,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}





