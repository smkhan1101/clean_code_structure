import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repository/home_repo.dart';
import '../../data/repository/home_repo_interface.dart';
import '../service/home_service.dart';
import '../service/home_service_impl.dart';
import '../../presentation/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepo>(() => HomeRepoImpl(prefs: Get.find<SharedPreferences>()));
    Get.lazyPut<HomeService>(() => HomeServiceImpl(homeRepo: Get.find<HomeRepo>()));
    Get.lazyPut<HomeController>(() => HomeController(homeService: Get.find<HomeService>()));
  }
}

