import 'package:get/get.dart';
import '../../data/repository/settings_repo.dart';
import '../../data/repository/settings_repo_interface.dart';
import '../service/settings_service.dart';
import '../service/settings_service_impl.dart';
import '../../presentation/controller/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsRepo>(() => SettingsRepoImpl());
    Get.lazyPut<SettingsService>(() => SettingsServiceImpl(settingsRepo: Get.find<SettingsRepo>()));
    Get.lazyPut<SettingsController>(() => SettingsController(settingsService: Get.find<SettingsService>()));
  }
}

