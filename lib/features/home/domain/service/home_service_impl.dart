import '../../data/model/calendar_item.dart';
import '../../data/model/user_calendar_data.dart';
import '../../data/repository/home_repo_interface.dart';
import 'home_service.dart';

class HomeServiceImpl implements HomeService {
  final HomeRepo homeRepo;

  HomeServiceImpl({required this.homeRepo});

  @override
  Future<List<CalendarItem>> getCalendarData() async {
    return await homeRepo.getCalendarData();
  }

  @override
  Future<UserCalendarData> getUserCalendarData() async {
    return await homeRepo.getUserCalendarData();
  }

  @override
  Future<Map<String, dynamic>> getBaselineData() async {
    return await homeRepo.getBaselineData();
  }

  @override
  Future<bool> isBaselineExists() async {
    return await homeRepo.isBaselineExists();
  }

  @override
  Future<int> getCurrentDay() async {
    return await homeRepo.getCurrentDay();
  }

  @override
  Future<int> getCurrentLevel() async {
    return await homeRepo.getCurrentLevel();
  }

  @override
  Future<bool> isTrainingEnabled() async {
    return await homeRepo.isTrainingEnabled();
  }

  @override
  Future<bool> isProPlan() async {
    return await homeRepo.isProPlan();
  }

  @override
  Future<Map<String, dynamic>> getUserStats() async {
    return await homeRepo.getUserStats();
  }

  @override
  Future<bool> hasUnfinishedTraining() async {
    return await homeRepo.hasUnfinishedTraining();
  }

  @override
  Future<bool> isTrainingLocked() async {
    return await homeRepo.isTrainingLocked();
  }
}

