import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../imports.dart';
import '../../../training/domain/binding/training_binding.dart';
import '../../data/model/calendar_item.dart';
import '../../data/model/home_menu.dart';
import '../../data/model/user_calendar_data.dart';
import '../../domain/service/home_service.dart';
import '../../../tutorials/presentation/view/tutorials_screen.dart';
import '../../../training/presentation/view/training_screen.dart';
import '../../../training/presentation/view/measure_baseline_screen.dart';
import '../../../training/presentation/view/training_active_screen.dart';
import '../../../training/domain/service/training_service.dart';
import '../view/contact_us_screen.dart';
import '../view/calendar_view_screen.dart';

class HomeController extends GetxController implements GetxService {
  final HomeService homeService;

  HomeController({required this.homeService});

  static HomeController get find => Get.find<HomeController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isTrainingButtonLoading = true;
  bool get isTrainingButtonLoading => _isTrainingButtonLoading;

  List<CalendarItem> _calendarData = [];
  List<CalendarItem> get calendarData => _calendarData;

  bool _baselineExists = false;
  bool get baselineExists => _baselineExists;

  int _currentDay = 0;
  int get currentDay => _currentDay;

  int _currentLevel = 1;
  int get currentLevel => _currentLevel;

  bool _isTrainingEnabled = false;
  bool get isTrainingEnabled => _isTrainingEnabled;

  bool _isProPlan = false;
  bool get isProPlan => _isProPlan;

  bool _isCalendarDataLoading = true;
  bool get isCalendarDataLoading => _isCalendarDataLoading;

  String _trainingDay = '';
  String get trainingDay => _trainingDay;

  bool _isLocked = false;
  bool get isLocked => _isLocked;

  bool _hasUnfinishedTraining = false;
  bool get hasUnfinishedTraining => _hasUnfinishedTraining;

  UserCalendarData? _userCalendarData;
  UserCalendarData? get userCalendarData => _userCalendarData;

  Map<String, dynamic> _userStats = {};
  Map<String, dynamic> get userStats => _userStats;

  String get speedDescription {
    final currentBaseline = _userStats['currentBaseline'] ?? 0.0;
    final speedUnit = _userStats['speedUnit'] ?? 'MPH';
    return '${currentBaseline.toInt()} $speedUnit';
  }

  String get speedDeltaDescription {
    final speedDelta = _userStats['speedDelta'] ?? 0.0;
    final speedUnit = _userStats['speedUnit'] ?? 'MPH';
    final sign = speedDelta >= 0 ? '+' : '';
    return '$sign${speedDelta.toStringAsFixed(1)} $speedUnit';
  }

  String get distanceDeltaDescription {
    final distanceDelta = _userStats['distanceDelta'] ?? 0.0;
    final distanceUnit = _userStats['distanceUnit'] ?? 'YDS';
    final sign = distanceDelta >= 0 ? '+' : '';
    return '$sign${distanceDelta.toStringAsFixed(1)} $distanceUnit';
  }

  List<HomeMenu> _homeMenuList = [];
  List<HomeMenu> get homeMenuList => _homeMenuList;

  @override
  void onInit() {
    super.onInit();
    _loadStaticMenuItems();
    loadHomeData();
  }

  void _loadStaticMenuItems() {
    _updateHomeMenuList();
    update();
  }

  Future<void> loadHomeData() async {
    _isLoading = true;
    _isCalendarDataLoading = true;
    _isTrainingButtonLoading = true;
    _updateHomeMenuList();
    update();

    try {
      _baselineExists = await homeService.isBaselineExists();
      _currentDay = await homeService.getCurrentDay();
      _currentLevel = await homeService.getCurrentLevel();
      _isTrainingEnabled = await homeService.isTrainingEnabled();
      _isProPlan = await homeService.isProPlan();
      _isLocked = await homeService.isTrainingLocked();
      _hasUnfinishedTraining = await homeService.hasUnfinishedTraining();
      _calendarData = await homeService.getCalendarData();
      _userCalendarData = await homeService.getUserCalendarData();
      _userStats = await homeService.getUserStats();

      _updateTrainingDay();
      _isCalendarDataLoading = false;
      _isTrainingButtonLoading = false;
      _updateHomeMenuList();
    } catch (e) {
      _isCalendarDataLoading = false;
      _isTrainingButtonLoading = false;
      _updateHomeMenuList();
    }

    _isLoading = false;
    update();
  }

  void _updateTrainingDay() {
    if (_baselineExists) {
      _trainingDay = "You're on Level $_currentLevel, Day $_currentDay";
    } else {
      _trainingDay = '';
    }
  }

  void _updateHomeMenuList() {
    final menuItems = <HomeMenu>[];

    if (_isTrainingButtonLoading) {
      menuItems.add(HomeMenu(
        title: '',
        description: '',
        icon: Iconsax.arrow_right_3,
        iconColor: Get.theme.colorScheme.surface,
        selected: true,
        isLoading: true,
      ));
    } else if (!_baselineExists) {
      menuItems.add(HomeMenu(
        title: 'Measure baseline',
        description: 'Let\'s calculate your swing speed!',
        icon: Iconsax.arrow_right_3,
        iconColor: Get.theme.colorScheme.surface,
        selected: true,
      ));
    } else if (_isLocked) {
      menuItems.add(HomeMenu(
        title: 'Training locked',
        description: 'Come back in 2 days!',
        icon: Iconsax.lock,
        iconColor: Get.theme.colorScheme.surface,
        enabled: false,
      ));
    } else if (_hasUnfinishedTraining) {
      menuItems.add(HomeMenu(
        title: 'Continue training',
        description: 'Pick up where you left off',
        icon: Iconsax.arrow_right_3,
        iconColor: Get.theme.colorScheme.surface,
        selected: true,
      ));
    } else {
      menuItems.add(HomeMenu(
        title: 'Start training',
        description: _trainingDay,
        icon: Iconsax.arrow_right_3,
        iconColor: Get.theme.colorScheme.surface,
        selected: true,
      ));
    }

    menuItems.add(HomeMenu(
      title: 'Watch tutorials'.tr,
      description: 'Procols & swing fix videos'.tr,
      icon: Iconsax.arrow_right_3,
      iconColor: Get.theme.colorScheme.surface,
    ));

    menuItems.add(HomeMenu(
      title: 'Shop'.tr,
      description: 'Visit our online store'.tr,
      icon: Iconsax.arrow_right_3,
      iconColor: Get.theme.colorScheme.surface,
    ));

    menuItems.add(HomeMenu(
      title: 'Contact us'.tr,
      description: 'How can we help?'.tr,
      icon: Iconsax.arrow_right_3,
      iconColor: Get.theme.colorScheme.surface,
    ));

    _homeMenuList = menuItems;
  }

  void onMenuTap(int index) {
    if (!_homeMenuList[index].enabled) return;

    final menuTitle = _homeMenuList[index].title.toLowerCase();
    
    if (menuTitle.contains('measure baseline')) {
      _openMeasureBaseline();
      return;
    }

    if (menuTitle.contains('continue training')) {
      _showContinueTrainingDialog();
      return;
    }

    switch (index) {
      case 0:
        if (_baselineExists) {
          if (_hasUnfinishedTraining) {
            _showContinueTrainingDialog();
          } else {
            TrainingScreen.show();
          }
        } else {
          _openMeasureBaseline();
        }
        break;
      case 1:
        TutorialsScreen.show();
        break;
      case 2:
        if (!_isProPlan) {
          Get.toNamed('/paywall');
        } else {
          Get.toNamed('/your-pro-content');
        }
        break;
      case 3:
        _openUrl('https://rypstick.com/');
        break;
      case 4:
        _openContactUs();
        break;
      default:
        break;
    }
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      showToast('error_opening_url'.tr);
    }
  }

  void _openContactUs() {
    ContactUsScreen.show();
  }

  void openCalendar() {
    CalendarViewScreen.show();
  }

  void _openMeasureBaseline() {
    MeasureBaselineScreen.show();
  }

  void _showContinueTrainingDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'You\'re on Level $_currentLevel Day $_currentDay',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const SizedBox.shrink(),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              TrainingActiveScreen.show();
            },
            child: Text(
              'Continue',
              style: TextStyle(
                color: const Color(0xFF4CAF50),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                // Ensure TrainingService is available
                if (!Get.isRegistered<TrainingService>()) {
                  // Initialize TrainingBinding if not already done
                  TrainingBinding().dependencies();
                }
                
                final trainingService = Get.find<TrainingService>();
                await trainingService.clearUnfinishedTraining();
                
                // Refresh home data to update menu and show current level/day
                await loadHomeData();
                
                // User stays on home screen - level/day will be displayed there
              } catch (e) {
                debugPrint('Error clearing training: $e');
                showToast('Error clearing training: ${e.toString()}');
              }
            },
            child: Text(
              'Start over',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void refreshData() {
    loadHomeData();
  }
}
