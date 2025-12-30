import '../../data/model/calendar_item.dart';
import '../../data/model/user_calendar_data.dart';

abstract class HomeService {
  Future<List<CalendarItem>> getCalendarData();
  Future<UserCalendarData> getUserCalendarData();
  Future<Map<String, dynamic>> getBaselineData();
  Future<bool> isBaselineExists();
  Future<int> getCurrentDay();
  Future<int> getCurrentLevel();
  Future<bool> isTrainingEnabled();
  Future<bool> isProPlan();
  Future<Map<String, dynamic>> getUserStats();
  Future<bool> hasUnfinishedTraining();
  Future<bool> isTrainingLocked();
}

