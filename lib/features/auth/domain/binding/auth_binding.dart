import 'package:get/get.dart';
import '../../data/repository/auth_repo.dart';
import '../../data/repository/auth_repo_interface.dart';
import '../service/auth_service.dart';
import '../service/auth_service_impl.dart';
import '../../presentation/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepo>(() => AuthRepoImpl());
    Get.lazyPut<AuthService>(() => AuthServiceImpl(authRepo: Get.find<AuthRepo>()));
    Get.lazyPut<AuthController>(() => AuthController(authService: Get.find<AuthService>()));
  }
}

