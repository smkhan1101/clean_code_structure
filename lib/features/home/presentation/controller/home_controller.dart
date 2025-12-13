import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../imports.dart';
import '../../data/model/calendar_item.dart';
import '../../data/model/home_menu.dart';
import '../../domain/service/home_service.dart';
import '../../../tutorials/presentation/view/tutorials_screen.dart';
import '../../../training/presentation/view/training_screen.dart';
import '../view/contact_us_screen.dart';

class HomeController extends GetxController implements GetxService {
  final HomeService homeService;

  HomeController({required this.homeService});

  static HomeController get find => Get.find<HomeController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  List<HomeMenu> _homeMenuList = [];
  List<HomeMenu> get homeMenuList => _homeMenuList;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    _isLoading = true;
    _isCalendarDataLoading = true;
    update();

    try {
      _baselineExists = await homeService.isBaselineExists();
      _currentDay = await homeService.getCurrentDay();
      _currentLevel = await homeService.getCurrentLevel();
      _isTrainingEnabled = await homeService.isTrainingEnabled();
      _isProPlan = await homeService.isProPlan();
      _calendarData = await homeService.getCalendarData();

      _updateTrainingDay();
      _updateHomeMenuList();
      _isCalendarDataLoading = false;
    } catch (e) {
      _isCalendarDataLoading = false;
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

    if (_isLocked) {
      menuItems.add(HomeMenu(
        title: 'training_locked'.tr,
        description: 'come_back'.tr,
        icon: Iconsax.lock,
        iconColor: Get.theme.colorScheme.surface,
        enabled: false,
      ));
    } else if (_isTrainingEnabled) {
      menuItems.add(HomeMenu(
        title: 'continue_training'.tr,
        description: 'Pick up where you left off'.tr,
        icon: Iconsax.arrow_right_3,
        iconColor: Get.theme.colorScheme.surface,
        selected: true,
      ));
    } else if (_baselineExists) {
      menuItems.add(HomeMenu(
        title: 'Start Training'.tr,
        description: _trainingDay,
        icon: Iconsax.arrow_right_3,
        iconColor: Get.theme.colorScheme.surface,
      ));
    } else {
      menuItems.add(HomeMenu(
        title: 'Measure your baseline'.tr,
        description: 'Let\'s calculate your swing speed!'.tr,
        icon: Iconsax.arrow_right_3,
        iconColor: Get.theme.colorScheme.surface,
      ));
    }

    menuItems.add(HomeMenu(
      title: 'Watch tutorials'.tr,
      description: 'Procols & swing fix videos'.tr,
      icon: Iconsax.arrow_right_3,
      iconColor: Get.theme.colorScheme.surface,
    ));

    if (!_isProPlan) {
      menuItems.add(HomeMenu(
        title: 'Upgrade to  the Pro Plan'.tr,
        description: 'You\'re eligible for a 50% OFF'.tr,
        icon: Iconsax.arrow_right_3,
        iconColor: Get.theme.colorScheme.surface,
      ));
    } else {
      menuItems.add(HomeMenu(
        title: 'your_pro_content'.tr,
        description: 'your_pro_content_description'.tr,
        icon: Iconsax.arrow_right_3,
        iconColor: Get.theme.colorScheme.surface,
      ));
    }

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

    switch (index) {
      case 0:
        TrainingScreen.show();
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

  void refreshData() {
    loadHomeData();
  }
}
