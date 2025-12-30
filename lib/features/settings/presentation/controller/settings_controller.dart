import 'package:get/get.dart';
import '../../../../imports.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../features/auth/presentation/controller/auth_controller.dart';
import '../../domain/service/settings_service.dart';

class SettingsController extends GetxController implements GetxService {
  final SettingsService settingsService;

  SettingsController({required this.settingsService});

  static SettingsController get find => Get.find<SettingsController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _email = '';
  String get email => _email;

  bool _isProPlan = false;
  bool get isProPlan => _isProPlan;

  String _notifications = 'Allow';
  String get notifications => _notifications;

  String _radar = 'No radar';
  String get radar => _radar;

  String _unit = 'Yards/MPH';
  String get unit => _unit;

  String _shaft = 'None';
  String get shaft => _shaft;

  bool _isNotDay1 = false;
  bool get isNotDay1 => _isNotDay1;

  String? _lastUserId;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  @override
  void onReady() {
    super.onReady();
    checkAndReloadIfUserChanged();
  }

  void checkAndReloadIfUserChanged() {
    final currentUser = AuthController.find.authService.getCurrentUser();
    final currentUserId = currentUser?.id;
    if (currentUserId != null && currentUserId != _lastUserId) {
      loadSettings();
    } else if (currentUserId == null && _lastUserId != null) {
      _clearState();
    }
  }

  Future<void> loadSettings({bool showLoading = false}) async {
    final currentUser = AuthController.find.authService.getCurrentUser();
    if (currentUser == null) {
      clearState();
      return;
    }
    _lastUserId = currentUser.id;
    if (showLoading) {
      _isLoading = true;
      update();
    }

    try {
      final settings = await settingsService.getUserSettings();
      _email = settings['email'] ?? '';
      _notifications = settings['notifications'] ?? 'Allow';
      _radar = settings['radar'] ?? 'No radar';
      _unit = settings['unit'] ?? 'Yards/MPH';
      _shaft = settings['shaft'] ?? 'None';
      _isNotDay1 = settings['isNotDay1'] ?? false;
    } catch (e) {
      if (showLoading) {
        showToast('error_loading_settings'.tr);
      }
    }

    if (showLoading) {
      _isLoading = false;
    }
    update();
  }

  void clearState() {
    _email = '';
    _notifications = 'Allow';
    _radar = 'No radar';
    _unit = 'Yards/MPH';
    _shaft = 'None';
    _isNotDay1 = false;
    _isProPlan = false;
    _lastUserId = null;
    _isLoading = false;
    update();
  }

  void _clearState() {
    clearState();
  }

  void setIsProPlan(bool value) {
    _isProPlan = value;
    update();
  }

  void updateSetting(String type, String value) {
    switch (type) {
      case 'notifications':
        _notifications = value;
        break;
      case 'radar':
        _radar = value;
        break;
      case 'unit':
        _unit = value;
        break;
      case 'shaft':
        _shaft = value;
        break;
    }
    update();
    settingsService.updateUserSettings({
      'notifications': _notifications,
      'radar': _radar,
      'unit': _unit,
      'shaft': _shaft,
    });
  }

  Future<void> signOut() async {
    try {
      await AuthController.find.logout();
    } catch (e) {
      showToast('error_signing_out'.tr);
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      showLoading();
      await settingsService.deleteAccount(password);
      hideLoading();
      await AuthController.find.logout();
    } catch (e) {
      hideLoading();
      showToast('error_deleting_account'.tr);
    }
  }

  Future<void> resetToLevel1Day1() async {
    try {
      showLoading();
      await settingsService.resetToLevel1Day1();
      hideLoading();
      showToast('reset_successful'.tr);
      loadSettings();
    } catch (e) {
      hideLoading();
      showToast('error_resetting'.tr);
    }
  }

  Future<void> rateApp() async {
    try {
      final uri = Uri.parse('https://play.google.com/store/apps/details?id=com.rypstick.app');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      showToast('error_opening_store'.tr);
    }
  }

  Future<void> contactUs() async {
    try {
      final uri = Uri.parse('mailto:rypstickstaff@gmail.com');
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      showToast('error_opening_email'.tr);
    }
  }
}

