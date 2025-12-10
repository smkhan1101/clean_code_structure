import '../model/calendar_item.dart';

abstract class HomeRepo {
  Future<List<CalendarItem>> getCalendarData();
  Future<Map<String, dynamic>> getBaselineData();
  Future<bool> isBaselineExists();
  Future<int> getCurrentDay();
  Future<int> getCurrentLevel();
  Future<bool> isTrainingEnabled();
  Future<bool> isProPlan();
}

